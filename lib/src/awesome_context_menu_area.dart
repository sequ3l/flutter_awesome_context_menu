import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'awesome_context_menu.dart' as local;
import 'awesome_context_menu_item.dart';
import 'awesome_link_handler.dart';
import 'awesome_menu_item_cache.dart';
import 'awesome_platform_utils.dart';
import 'super_right_click_detector.dart';

/// A widget that provides a customizable context menu area.
///
/// Wrap your content with this widget to enable right-click context menu functionality.
/// Also handles normal clicks with the onClick callback and mouse hover events.
class AwesomeContextMenuArea extends StatefulWidget {
  /// The child widget to wrap.
  final Widget child;

  /// The list of menu items to show in the context menu.
  final List<AwesomeContextMenuItem>? menuItems;

  /// An optional URL associated with the content.
  /// If provided, default link-related menu items will be available.
  final String? link;

  /// Callback function to execute when right-click occurs.
  /// Returns the local position of the right-click.
  final void Function(Offset position)? onRightClick;

  /// Callback function to execute when normal click (left mouse button) occurs.
  /// This will be called when the user clicks on the widget.
  final VoidCallback? onClick;

  /// Callback function to execute when the mouse enters the widget area.
  /// This is useful for highlighting elements or showing tooltips.
  final void Function(PointerEnterEvent event)? onMouseEnter;

  /// Callback function to execute when the mouse leaves the widget area.
  /// This is useful for resetting highlights or hiding tooltips.
  final void Function(PointerExitEvent event)? onMouseExit;

  /// Callback function to execute when the mouse moves within the widget area.
  /// Provides the current pointer position.
  final void Function(PointerHoverEvent event)? onMouseHover;

  /// Callback function to execute when the mouse moves within the widget area.
  /// Provides the current pointer position. Similar to onMouseHover but triggered
  /// through PointerMoveEvent for more compatibility across platforms.
  final void Function(PointerMoveEvent event)? onMouseMove;

  /// Whether to show default browser-like menu items for links.
  final bool showDefaultLinkItems;

  /// Whether to handle CTRL+Click to open links in new tabs.
  /// If true, holding CTRL while clicking will open the link in a new tab.
  final bool handleCtrlClick;

  /// Callback function to execute when CTRL+Click occurs.
  /// This is only called if [handleCtrlClick] is true and [link] is provided.
  final VoidCallback? onCtrlClick;

  /// Callback to build custom menu items.
  /// Can be used to dynamically generate menu items at runtime.
  final List<AwesomeContextMenuItem> Function(BuildContext context)? menuItemBuilder;

  /// Maximum width of the context menu.
  final double maxMenuWidth;

  /// Background color of the context menu.
  final Color? backgroundColor;

  /// Text color of the context menu items.
  final Color? textColor;

  /// Custom animation duration for this specific menu.
  /// If not provided, uses the global animation duration set in AwesomeContextMenu.
  final Duration? animationDuration;

  /// Custom callback to determine the position of the menu.
  /// Receives the rectangle of the triggering widget and menu size,
  /// and returns the position where the menu should appear.
  final Offset Function(Rect rect, Size menuSize)? customPositionCallback;

  /// Whether to use a custom menu builder instead of the default menu items.
  /// Set to true when using [customMenuBuilder].
  final bool useCustomBuilder;

  /// Custom builder for creating completely custom menu UI.
  /// The second parameter is a callback to close the menu.
  final Widget Function(BuildContext context, VoidCallback closeMenu)? customMenuBuilder;

  /// Optional text label to display as a hint for interacting with this area
  /// (e.g., "Right-click" or "Long-press").
  final String? shortcutLabel;

  /// Creates an [AwesomeContextMenuArea].
  const AwesomeContextMenuArea({
    super.key,
    required this.child,
    this.menuItems,
    this.link,
    this.onRightClick,
    this.onClick,
    this.onMouseEnter,
    this.onMouseExit,
    this.onMouseHover,
    this.onMouseMove,
    this.showDefaultLinkItems = true,
    this.handleCtrlClick = true,
    this.onCtrlClick,
    this.menuItemBuilder,
    this.maxMenuWidth = 250.0,
    this.backgroundColor,
    this.textColor,
    this.animationDuration,
    this.customPositionCallback,
    this.useCustomBuilder = false,
    this.customMenuBuilder,
    this.shortcutLabel,
  });

  @override
  State<AwesomeContextMenuArea> createState() => _AwesomeContextMenuAreaState();
}

class _AwesomeContextMenuAreaState extends State<AwesomeContextMenuArea> {
  // Track if the control key is pressed
  bool _isCtrlPressed = false;

  // Cache for the built menu items to avoid rebuilding them on each right-click
  List<AwesomeContextMenuItem>? _cachedMenuItems;
  String? _lastCachedLink;

  // Instance-level overlay entry to prevent memory leaks
  OverlayEntry? _instanceOverlayEntry;

  @override
  void didUpdateWidget(AwesomeContextMenuArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Invalidate the cached menu items if relevant props have changed
    if (widget.link != oldWidget.link || widget.menuItems != oldWidget.menuItems || widget.showDefaultLinkItems != oldWidget.showDefaultLinkItems) {
      _cachedMenuItems = null;
    }
  }

  @override
  void dispose() {
    // Clean up cached items related to this widget
    _cachedMenuItems = null;
    // Ensure any instance overlay is removed
    _instanceOverlayEntry?.remove();
    _instanceOverlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (FocusNode node, KeyEvent event) {
        // Track control key state
        if (event.logicalKey == LogicalKeyboardKey.controlLeft || event.logicalKey == LogicalKeyboardKey.controlRight) {
          if (event is KeyDownEvent) {
            setState(() => _isCtrlPressed = true);
          } else if (event is KeyUpEvent) {
            setState(() => _isCtrlPressed = false);
          }
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: _determineCursor(),
        onEnter: widget.onMouseEnter,
        onExit: widget.onMouseExit,
        onHover: widget.onMouseHover,
        child: Listener(
          // Handle pointer move events for broader compatibility
          onPointerMove: (PointerMoveEvent event) {
            widget.onMouseMove?.call(event);
          },
          // Handle CTRL+Click detection
          onPointerDown: (PointerDownEvent event) {
            if (widget.handleCtrlClick && widget.link != null && event.kind == PointerDeviceKind.mouse && event.buttons == kPrimaryMouseButton && HardwareKeyboard.instance.isControlPressed) {
              _handleCtrlClick();
            }
          },
          child: SuperRightClickDetector(
            onRightClick: _handleRightClick,
            onTap: _handleLeftClick,
            onLongPress: () {
              // Only trigger on mobile platforms
              if (AwesomePlatformUtils.isMobile()) {
                // Get position from the current render object
                final RenderBox? box = context.findRenderObject() as RenderBox?;
                if (box != null && mounted) {
                  final Offset position = box.localToGlobal(box.size.center(Offset.zero));
                  _handleRightClickMenu(position);
                }
              }
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  /// Determines the appropriate cursor based on the widget's properties and state
  MouseCursor _determineCursor() {
    // Show a clickable cursor if there's a link or onClick callback
    if (widget.link != null || widget.onClick != null) {
      return SystemMouseCursors.click;
    }
    // Otherwise defer to the system's default cursor
    return MouseCursor.defer;
  }

  void _handleCtrlClick() {
    // Open link in new tab
    if (widget.link != null && AwesomeLinkHandler.isValidUrl(widget.link!)) {
      AwesomeLinkHandler.openInNewTab(widget.link!);
      widget.onCtrlClick?.call();
    }
  }

  /// Handles right-click menu logic with improved synchronization
  void _handleRightClickMenu(Offset position) {
    widget.onRightClick?.call(position);

    // If there's an existing menu, hide it first and wait for it to be fully hidden
    if (local.AwesomeContextMenu.isVisible()) {
      local.AwesomeContextMenu.hide();

      // Use a short delay to ensure proper cleanup
      Future.delayed(const Duration(milliseconds: 20), () {
        if (mounted) {
          _showContextMenu(position);
        }
      });
    } else {
      // No existing menu, show immediately
      _showContextMenu(position);
    }
  }

  void _showContextMenu(Offset position) {
    widget.onRightClick?.call(position);

    // Handle custom menu builder if provided
    if (widget.useCustomBuilder && widget.customMenuBuilder != null) {
      // First remove any existing overlay
      _instanceOverlayEntry?.remove();
      _instanceOverlayEntry = null;

      // Create a close menu callback
      closeMenu() {
        // Hide any standard AwesomeContextMenu that might be visible
        local.AwesomeContextMenu.hide();

        // Close our custom overlay
        if (_instanceOverlayEntry != null) {
          _instanceOverlayEntry?.remove();
          _instanceOverlayEntry = null;
        }
      }

      // Build the custom menu
      Widget customMenu = widget.customMenuBuilder!(context, closeMenu);

      // Use the overlay system to show the custom menu
      final OverlayState overlay = Overlay.of(context);
      _instanceOverlayEntry = OverlayEntry(
        builder: (context) => Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Invisible fullscreen button to close the menu when clicking outside
              Positioned.fill(
                child: GestureDetector(
                  onTap: closeMenu,
                  behavior: HitTestBehavior.translucent,
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Position the custom menu
              Positioned(
                left: position.dx,
                top: position.dy,
                child: GestureDetector(
                  // This gesture detector prevents menu from closing when interacting with form elements
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {}, // Empty onTap to prevent clicks from propagating
                  child: customMenu,
                ),
              ),
            ],
          ),
        ),
      );

      // Insert the overlay entry
      overlay.insert(_instanceOverlayEntry!);
      return;
    }

    // If not using custom builder, build menu items list based on provided options
    final List<AwesomeContextMenuItem> items = _buildMenuItems();
    if (items.isEmpty) return;

    // Apply custom position callback if provided
    Offset finalPosition = position;
    if (widget.customPositionCallback != null) {
      // Get widget's size and position
      final RenderBox box = context.findRenderObject() as RenderBox;
      final Rect globalRect = box.localToGlobal(Offset.zero) & box.size;

      // Estimate menu size (this is approximate since actual size depends on content)
      final Size estimatedMenuSize = Size(
        widget.maxMenuWidth,
        items.length * 40.0, // Rough estimate of height per item
      );

      // Get position from callback
      finalPosition = widget.customPositionCallback!(globalRect, estimatedMenuSize);
    }

    local.AwesomeContextMenu.show(
      context: context,
      items: items,
      position: finalPosition,
      maxMenuWidth: widget.maxMenuWidth,
      backgroundColor: widget.backgroundColor,
      textColor: widget.textColor,
      animationDuration: widget.animationDuration,
    );
  }

  List<AwesomeContextMenuItem> _buildMenuItems() {
    // Return cached items if available and link hasn't changed
    if (_cachedMenuItems != null && widget.link == _lastCachedLink) {
      return _cachedMenuItems!;
    }

    final List<AwesomeContextMenuItem> items = [];

    // Add custom items from menuItemBuilder if provided
    if (widget.menuItemBuilder != null) {
      items.addAll(widget.menuItemBuilder!(context));
    }

    // Add explicitly provided menu items
    if (widget.menuItems != null) {
      items.addAll(widget.menuItems!);
    }

    // Add default link items if link provided and showDefaultLinkItems is true
    if (widget.link != null && widget.link!.isNotEmpty && widget.showDefaultLinkItems) {
      final bool isValidUrl = AwesomeLinkHandler.isValidUrl(widget.link!);

      if (isValidUrl) {
        // If we already have items, add a separator first
        if (items.isNotEmpty) {
          items.add(AwesomeContextMenuItem.separator());
        }

        // Add default link-related items using the cache
        items.add(AwesomeMenuItemCache.getItem(
          'open_link_in_new_tab',
          label: 'Open link in new tab',
          icon: Icons.open_in_new,
          onSelected: () => AwesomeLinkHandler.openInNewTab(widget.link!),
        ));

        items.add(AwesomeMenuItemCache.getItem(
          'copy_link_address',
          label: 'Copy link address',
          icon: Icons.content_copy,
          onSelected: () => AwesomeLinkHandler.copyToClipboard(widget.link!),
        ));
      }
    }

    // Cache the built items
    _cachedMenuItems = List.from(items);
    _lastCachedLink = widget.link;

    return items;
  }

  /// Handle right-click from the SuperRightClickDetector
  void _handleRightClick(Offset position) {
    _handleRightClickMenu(position);
  }

  /// Handle left-click/tap from the SuperRightClickDetector
  void _handleLeftClick() {
    // Handle onClick callback if provided
    widget.onClick?.call();

    // Handle CTRL+Click if enabled and link is available
    if (widget.handleCtrlClick && widget.link != null && _isCtrlPressed) {
      _handleCtrlClick();
    }
  }
}

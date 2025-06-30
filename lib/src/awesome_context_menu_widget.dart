import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'awesome_context_menu_item.dart';
import 'awesome_platform_utils.dart';
import 'awesome_context_menu.dart';
import 'awesome_menu_item_cache.dart';

/// The actual menu widget that renders a single level of menu items
class AwesomeContextMenuWidget extends StatefulWidget {
  final List<AwesomeContextMenuItem> items;
  final Offset position;
  final double maxMenuWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final Function(List<AwesomeContextMenuItem>, Offset, int) onSubmenuOpen;
  final Function(int) onSubmenuClose;
  final int depth;
  // Add autofocus parameter to enable keyboard navigation
  final bool autofocus;
  final Duration animationDuration;

  const AwesomeContextMenuWidget({
    super.key,
    required this.items,
    required this.position,
    required this.maxMenuWidth,
    this.backgroundColor,
    this.textColor,
    required this.onSubmenuOpen,
    required this.onSubmenuClose,
    required this.depth,
    this.autofocus = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<AwesomeContextMenuWidget> createState() => _AwesomeContextMenuWidgetState();
}

class _AwesomeContextMenuWidgetState extends State<AwesomeContextMenuWidget> with SingleTickerProviderStateMixin {
  int? _hoveredItemIndex;
  int? _focusedItemIndex;

  // Animation controller for entrance animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Memoize calculated positions to avoid recalculating during rebuilds
  late double _left;
  late double _top;
  bool _positionsCalculated = false;

  // Keep a focus node to manage keyboard navigation
  final _menuFocusNode = FocusNode();

  // Cache for position calculations to improve performance
  final Map<int, Offset> _cachedSubmenuPositions = {};

  @override
  void initState() {
    super.initState();
    // Initialize with first non-separator item focused
    if (widget.autofocus) {
      for (int i = 0; i < widget.items.length; i++) {
        if (!widget.items[i].isSeparator && widget.items[i].enabled) {
          _focusedItemIndex = i;
          break;
        }
      }
    }

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Stop animation if it's running to prevent race conditions
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _animationController.dispose();
    _menuFocusNode.dispose();
    // Clear cached positions
    _cachedSubmenuPositions.clear();
    super.dispose();
  }

  // Default padding values
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  /// Gets the effective submenu interaction mode for a menu item
  SubMenuInteractionMode _getEffectiveInteractionMode(AwesomeContextMenuItem item) {
    if (item.subMenuInteractionMode != SubMenuInteractionMode.auto) {
      return item.subMenuInteractionMode;
    }
    return AwesomePlatformUtils.getPlatformDefaultInteractionMode();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? theme.popupMenuTheme.color ?? theme.cardColor;
    final txtColor = widget.textColor ?? theme.textTheme.bodyMedium?.color ?? Colors.black87;

    // Calculate the position considering screen boundaries - only do this once
    if (!_positionsCalculated) {
      _calculateOptimalPosition(context);
      _positionsCalculated = true;
    }

    return Positioned(
      left: _left,
      top: _top,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(4.0),
            color: bgColor,
            child: IntrinsicWidth(
              stepWidth: 56.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.maxMenuWidth,
                  minWidth: 120.0,
                ),
                child: Focus(
                  autofocus: widget.autofocus,
                  focusNode: _menuFocusNode,
                  onKey: (FocusNode node, RawKeyEvent event) {
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        _moveFocus(1);
                        return KeyEventResult.handled;
                      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                        _moveFocus(-1);
                        return KeyEventResult.handled;
                      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                        // Open submenu if the focused item has one
                        if (_focusedItemIndex != null) {
                          final item = widget.items[_focusedItemIndex!];
                          if (item.hasSubmenu && item.enabled) {
                            _openSubmenu(item);
                            return KeyEventResult.handled;
                          }
                        }
                      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                        // Close this menu if it's a submenu
                        if (widget.depth > 0) {
                          widget.onSubmenuClose(widget.depth);
                          return KeyEventResult.handled;
                        }
                      } else if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space) {
                        _activateFocusedItem();
                        return KeyEventResult.handled;
                      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                        // Close the entire menu system
                        MenuDismissHelper.dismissMenu(context);
                        return KeyEventResult.handled;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Semantics(
                    label: 'Context Menu',
                    hint: 'Use arrow keys to navigate, Enter to select, Escape to close',
                    container: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];

                        if (item.isSeparator) {
                          return const Divider(height: 1, thickness: 1, color: Colors.black12);
                        }

                        return _buildMenuItem(index, item, txtColor);
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Calculate the optimal position for the menu, considering screen boundaries
  void _calculateOptimalPosition(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    final double menuWidth = widget.maxMenuWidth;

    // Account for system UI and safe areas
    final double availableWidth = screenSize.width - viewPadding.horizontal;
    final double availableHeight = screenSize.height - viewPadding.vertical - viewInsets.bottom;

    // Calculate menu dimensions more accurately
    // Using theme-based calculations instead of hard-coded values
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double baseItemHeight = _itemPadding.vertical + (textTheme.bodyMedium?.fontSize ?? 14.0) * 1.5;

    // Calculate approximate total height more accurately by considering item types
    double estimatedTotalHeight = 0;
    for (var item in widget.items) {
      if (item.isSeparator) {
        estimatedTotalHeight += 1.0; // Separator height
      } else {
        estimatedTotalHeight += baseItemHeight;
      }
    }

    // Initial position
    double left = widget.position.dx;
    double top = widget.position.dy;

    // Adjust if menu would go off-screen to the right
    if (left + menuWidth > availableWidth) {
      left = availableWidth - menuWidth - 8;

      // If this is a submenu, position to the left of the parent instead of right
      if (widget.depth > 0) {
        left = widget.position.dx - menuWidth;
      }
    }

    // Make sure it's not off-screen to the left
    if (left < viewPadding.left + 8) left = viewPadding.left + 8;

    // Adjust if menu would go off-screen at the bottom
    if (top + estimatedTotalHeight > availableHeight) {
      top = availableHeight - estimatedTotalHeight - 8;
      if (top < viewPadding.top + 8) top = viewPadding.top + 8; // don't go off the top
    }

    _left = left;
    _top = top;
  }

  void _moveFocus(int offset) {
    setState(() {
      int newIndex = (_focusedItemIndex ?? 0) + offset;
      while (newIndex >= 0 && newIndex < widget.items.length) {
        if (!widget.items[newIndex].isSeparator && widget.items[newIndex].enabled) {
          _focusedItemIndex = newIndex;
          break;
        }
        newIndex += offset;
      }
    });
  }

  void _activateFocusedItem() {
    if (_focusedItemIndex != null) {
      final item = widget.items[_focusedItemIndex!];
      if (item.enabled) {
        if (item.hasSubmenu) {
          _openSubmenu(item);
        } else if (item.onSelected != null) {
          item.onSelected!();
          if (item.dismissMenuOnSelect) {
            MenuDismissHelper.dismissMenu(context);
          }
        }
      }
    }
  }

  void _openSubmenu(AwesomeContextMenuItem item) {
    if (!item.hasSubmenu || !item.enabled || !mounted) return;

    // Use cached position if available
    final cacheKey = item.hashCode;
    if (_cachedSubmenuPositions.containsKey(cacheKey)) {
      widget.onSubmenuOpen(item.children!, _cachedSubmenuPositions[cacheKey]!, widget.depth);
      return;
    }

    int? itemIndex;
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i] == item) {
        itemIndex = i;
        break;
      }
    }

    if (itemIndex == null) return;

    // We need to find the render box of this menu item for positioning
    final RenderBox? overlay = context.findRenderObject() as RenderBox?;
    if (overlay == null || !overlay.hasSize) {
      // Schedule retry after next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openSubmenu(item);
      });
      return;
    }

    // Get the size and position of this menu
    final Size menuSize = overlay.size;
    final Offset menuPosition = overlay.localToGlobal(Offset.zero);

    // Calculate the approximate position of this specific menu item
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double baseItemHeight = _itemPadding.vertical + (textTheme.bodyMedium?.fontSize ?? 14.0) * 1.5;

    // Calculate position more accurately
    double yOffset = 0;
    for (int i = 0; i < itemIndex; i++) {
      if (widget.items[i].isSeparator) {
        yOffset += 1.0; // Separator height
      } else {
        yOffset += baseItemHeight;
      }
    }

    // Calculate the absolute position where the submenu should appear
    final Offset submenuPosition = Offset(
      menuPosition.dx + menuSize.width - 4, // Slightly overlap
      menuPosition.dy + yOffset, // More accurate position
    );

    // Cache the calculated position
    _cachedSubmenuPositions[cacheKey] = submenuPosition;

    // Open the submenu
    widget.onSubmenuOpen(item.children!, submenuPosition, widget.depth);
  }

  Widget _buildMenuItem(int index, AwesomeContextMenuItem item, Color txtColor) {
    final hasSubmenu = item.hasSubmenu;
    final interactionMode = _getEffectiveInteractionMode(item);
    final isHovered = _hoveredItemIndex == index;
    final isFocused = _focusedItemIndex == index;

    // Helper function to handle submenu opening
    void openSubmenu() {
      if (!item.hasSubmenu || !item.enabled) return;

      // We need to find the render box of this menu item for positioning
      final RenderBox? overlay = context.findRenderObject() as RenderBox?;
      if (overlay == null || !overlay.hasSize) return;

      // Get the size and position of this menu
      final Size menuSize = overlay.size;
      final Offset menuPosition = overlay.localToGlobal(Offset.zero);

      // Calculate the approximate position of this specific menu item
      final TextTheme textTheme = Theme.of(context).textTheme;
      final double baseItemHeight = _itemPadding.vertical + (textTheme.bodyMedium?.fontSize ?? 14.0) * 1.5;

      // Calculate position more accurately
      double yOffset = 0;
      for (int i = 0; i < index; i++) {
        if (widget.items[i].isSeparator) {
          yOffset += 1.0; // Separator height
        } else {
          yOffset += baseItemHeight;
        }
      }

      // Calculate the absolute position where the submenu should appear
      final Offset submenuPosition = Offset(
        menuPosition.dx + menuSize.width - 4, // Slightly overlap
        menuPosition.dy + yOffset, // More accurate position
      );

      // Open the submenu
      widget.onSubmenuOpen(item.children!, submenuPosition, widget.depth);
    }

    // Get cached icons if possible
    Widget? leadingIcon;
    if (item.icon != null) {
      leadingIcon = AwesomeMenuItemCache.getIcon(item.icon!, color: item.enabled ? txtColor : txtColor.withOpacity(0.5));
    }

    // Trailing icon for submenus or non-dismissing items
    Widget? trailingIcon;
    if (hasSubmenu) {
      trailingIcon = AwesomeMenuItemCache.getIcon(Icons.arrow_right, size: 16.0, color: item.enabled ? txtColor : txtColor.withOpacity(0.5));
    } else if (!item.dismissMenuOnSelect) {
      trailingIcon = AwesomeMenuItemCache.getIcon(Icons.check_box_outline_blank, size: 14.0, color: txtColor.withOpacity(0.3));
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredItemIndex = index;

          // If this item has a submenu and uses hover interaction, open it
          if (hasSubmenu && item.enabled && interactionMode == SubMenuInteractionMode.hover) {
            openSubmenu();
          } else if (_hoveredItemIndex != index) {
            // If hovering over a different item, close any deeper submenus
            widget.onSubmenuClose(widget.depth + 1);
          }
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredItemIndex = null;
        });
      },
      child: Semantics(
        button: true,
        enabled: item.enabled,
        label: item.label,
        hint: item.hasSubmenu ? 'Has submenu - use arrow keys or double tap to open' : (item.enabled ? 'Tap to activate' : 'Disabled'),
        focused: isFocused,
        child: InkWell(
          onTap: item.enabled
              ? () {
                  if (hasSubmenu && interactionMode == SubMenuInteractionMode.click) {
                    openSubmenu();
                  } else if (!hasSubmenu && item.onSelected != null) {
                    item.onSelected!();
                    if (item.dismissMenuOnSelect) {
                      // Dismiss the entire menu tree
                      MenuDismissHelper.dismissMenu(context);
                    }
                  }
                }
              : null,
          onLongPress: (hasSubmenu && item.enabled && interactionMode == SubMenuInteractionMode.longPress) ? () => openSubmenu() : null,
          child: Container(
            color: isHovered || isFocused ? Colors.grey.withOpacity(0.1) : Colors.transparent,
            padding: _itemPadding,
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon,
                  const SizedBox(width: 12.0),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: item.enabled ? txtColor : txtColor.withOpacity(0.5),
                    ),
                  ),
                ),

                // Show the appropriate trailing icon
                if (trailingIcon != null) trailingIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper class to dismiss menus across the widget tree
class MenuDismissHelper {
  /// Dismiss the menu by calling the global hide method
  static void dismissMenu(BuildContext context) {
    AwesomeContextMenu.hide();
  }
}

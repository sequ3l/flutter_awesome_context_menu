import 'package:flutter/material.dart';
import 'awesome_context_menu_item.dart';
import 'awesome_context_menu_widget.dart';

/// The overlay that contains the entire context menu system
class AwesomeContextMenuOverlay extends StatefulWidget {
  final List<AwesomeContextMenuItem> items;
  final Offset position;
  final double maxMenuWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onDismiss;
  final Duration animationDuration;

  // Add a global key to access the state
  AwesomeContextMenuOverlay({
    required this.items,
    required this.position,
    required this.maxMenuWidth,
    this.backgroundColor,
    this.textColor,
    required this.onDismiss,
    this.animationDuration = const Duration(milliseconds: 150),
  }) : super(key: GlobalKey<AwesomeContextMenuOverlayState>());

  @override
  State<AwesomeContextMenuOverlay> createState() => AwesomeContextMenuOverlayState();
}

class AwesomeContextMenuOverlayState extends State<AwesomeContextMenuOverlay> {
  // Track active submenus with their positions and items
  final List<SubmenuInfo> _activeSubmenus = [];

  // Store a mutable copy of the items
  late List<AwesomeContextMenuItem> _rootItems;

  // Key for the transparent tap capture layer
  final _tapCaptureLayerKey = GlobalKey();

  // Use a map to improve lookup efficiency for submenus
  final Map<int, SubmenuInfo> _submenuLookup = {};

  @override
  void initState() {
    super.initState();
    _rootItems = List.from(widget.items);
  }

  @override
  void dispose() {
    // Clean up resources
    _activeSubmenus.clear();
    _submenuLookup.clear();
    super.dispose();
  }

  // Method to update the root items
  void updateRootItems(List<AwesomeContextMenuItem> items) {
    setState(() {
      _activeSubmenus.clear();
      _submenuLookup.clear();
      _rootItems = List.from(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Context Menu',
      explicitChildNodes: true,
      container: true,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // Invisible full-screen layer to capture taps outside
            Positioned.fill(
              key: _tapCaptureLayerKey,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onDismiss,
                onSecondaryTap: widget.onDismiss, // Also dismiss on right-click outside
                // Remove immediate dismissal handlers that conflict with nested context menus
                // onTapDown: (_) => widget.onDismiss(),
                // onSecondaryTapDown: (_) => widget.onDismiss(),
                child: Container(color: Colors.transparent),
              ),
            ),

            // Root menu
            AwesomeContextMenuWidget(
              items: _rootItems, // Use our mutable copy instead of widget.items
              position: widget.position,
              maxMenuWidth: widget.maxMenuWidth,
              backgroundColor: widget.backgroundColor,
              textColor: widget.textColor,
              onSubmenuOpen: _handleSubmenuOpen,
              onSubmenuClose: _handleSubmenuClose,
              depth: 0,
              animationDuration: widget.animationDuration,
            ),

            // Render all active submenus
            ..._activeSubmenus.map((submenuInfo) => AwesomeContextMenuWidget(
                  key: ValueKey('submenu-${submenuInfo.depth}'),
                  items: submenuInfo.items,
                  position: submenuInfo.position,
                  maxMenuWidth: widget.maxMenuWidth,
                  backgroundColor: widget.backgroundColor,
                  textColor: widget.textColor,
                  onSubmenuOpen: _handleSubmenuOpen,
                  onSubmenuClose: _handleSubmenuClose,
                  depth: submenuInfo.depth,
                  animationDuration: widget.animationDuration,
                )),
          ],
        ),
      ),
    );
  }

  void _handleSubmenuOpen(List<AwesomeContextMenuItem> items, Offset position, int depth) {
    setState(() {
      // Remove any deeper level submenus
      _activeSubmenus.removeWhere((info) => info.depth > depth);
      _submenuLookup.removeWhere((key, info) => key > depth);

      // Add the new submenu
      final submenuInfo = SubmenuInfo(
        items: items,
        position: position,
        depth: depth + 1,
      );

      _activeSubmenus.add(submenuInfo);
      _submenuLookup[depth + 1] = submenuInfo;
    });
  }

  void _handleSubmenuClose(int depth) {
    setState(() {
      // Close this submenu and any deeper ones using more efficient lookup
      _activeSubmenus.removeWhere((info) => info.depth >= depth);
      final depthsToRemove = _submenuLookup.keys.where((d) => d >= depth).toList();
      for (final d in depthsToRemove) {
        _submenuLookup.remove(d);
      }
    });
  }
}

/// Information about an active submenu
class SubmenuInfo {
  final List<AwesomeContextMenuItem> items;
  final Offset position;
  final int depth;

  SubmenuInfo({
    required this.items,
    required this.position,
    required this.depth,
  });
}

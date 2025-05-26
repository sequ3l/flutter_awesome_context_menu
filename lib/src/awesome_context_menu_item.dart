import 'package:flutter/material.dart';
import 'awesome_menu_item_cache.dart';

/// A class representing an individual item in the Awesome Context Menu.
class AwesomeContextMenuItem {
  /// The text label for the menu item.
  final String label;

  /// Optional icon to display alongside the label.
  final IconData? icon;

  /// Callback function that executes when the menu item is selected.
  final VoidCallback? onSelected;

  /// Whether this menu item is enabled or disabled.
  final bool enabled;

  /// Whether this menu item is a separator.
  final bool isSeparator;

  /// Whether to dismiss the menu when this item is selected.
  ///
  /// If true (default), the menu will be dismissed when the item is selected.
  /// If false, the menu will remain open after the item is selected.
  ///
  /// This is useful for actions that modify state but should allow the user
  /// to make multiple selections without reopening the menu.
  final bool dismissMenuOnSelect;

  /// Child menu items that will be displayed in a submenu.
  ///
  /// When this list is non-empty, the menu item will display a submenu indicator
  /// and will show the children when the user interacts with it (hover on desktop,
  /// click or long press on mobile).
  final List<AwesomeContextMenuItem>? children;

  /// Interaction mode to show submenu items.
  ///
  /// Determines how nested menu items will be revealed.
  /// [SubMenuInteractionMode.auto] will use the platform default:
  /// - hover for desktop platforms (Windows, macOS, Linux, Web)
  /// - click for mobile platforms (Android, iOS)
  final SubMenuInteractionMode subMenuInteractionMode;

  /// Optional shortcut text to display next to the menu item (e.g., "Ctrl+C").
  ///
  /// This is for display purposes only and doesn't handle the actual shortcut.
  final String? shortcut;

  /// Constructs a [AwesomeContextMenuItem].
  ///
  /// The [label] is required unless [isSeparator] is true.
  /// The [onSelected] callback is executed when the menu item is tapped.
  /// If [enabled] is false, the menu item will be displayed as disabled.
  /// Set [dismissMenuOnSelect] to false to keep the menu open after selection.
  /// If [children] is provided, this item will act as a submenu parent.
  /// [shortcut] can be used to display keyboard shortcut hints.
  const AwesomeContextMenuItem({
    this.label = '',
    this.icon,
    this.onSelected,
    this.enabled = true,
    this.isSeparator = false,
    this.dismissMenuOnSelect = true,
    this.children,
    this.subMenuInteractionMode = SubMenuInteractionMode.auto,
    this.shortcut,
  }) : assert(
          isSeparator || label != '',
          'Label cannot be empty unless this is a separator',
        );

  /// Creates a separator menu item.
  factory AwesomeContextMenuItem.separator() {
    return const AwesomeContextMenuItem(isSeparator: true);
  }

  /// Whether this menu item has children and can open a submenu.
  bool get hasSubmenu => children != null && children!.isNotEmpty;

  /// Retrieves a cached menu item by key, or creates a new one if not in cache.
  ///
  /// This improves performance by reusing menu item instances that are frequently used.
  /// [key] is a unique identifier for the menu item in the cache.
  /// [builder] is a function that creates the menu item if it's not in the cache.
  static AwesomeContextMenuItem getCachedItem(
      String key, AwesomeContextMenuItem Function() builder) {
    // Use public methods from AwesomeMenuItemCache instead of directly accessing private fields
    final cachedItem = AwesomeMenuItemCache.getCachedItem(key);

    if (cachedItem != null) {
      return cachedItem;
    }

    // Create new item using the provided builder
    final newItem = builder();

    // Store the item in cache
    AwesomeMenuItemCache.storeItem(key, newItem);

    return newItem;
  }
}

/// Defines how submenu items are revealed when interacting with a parent menu item.
enum SubMenuInteractionMode {
  /// Automatically choose the best interaction mode for the current platform.
  /// - Hover for desktop platforms (Windows, macOS, Linux, Web)
  /// - Click for mobile platforms (Android, iOS)
  auto,

  /// Show submenu when hovering over the parent menu item.
  /// Best for desktop platforms.
  hover,

  /// Show submenu when clicking/tapping the parent menu item.
  /// Works on all platforms.
  click,

  /// Show submenu when long-pressing the parent menu item.
  /// Alternative option for mobile platforms.
  longPress,
}

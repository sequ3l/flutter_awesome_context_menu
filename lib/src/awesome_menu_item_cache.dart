import 'package:flutter/material.dart';
import 'awesome_context_menu_item.dart';

/// A cache for frequently used menu items to improve performance and memory usage
class AwesomeMenuItemCache {
  // Private constructor to prevent direct instantiation
  AwesomeMenuItemCache._();

  // Static cache for common menu items
  static final Map<String, AwesomeContextMenuItem> _itemCache = {};

  // Static cache for icon widgets to prevent rebuilding
  static final Map<IconData, Icon> _iconCache = {};

  // LRU tracking for items - most recently used items at the end
  static final List<String> _lruItemKeys = [];

  // LRU tracking for icons - most recently used icons at the end
  static final List<IconData> _lruIconKeys = [];

  // Default max cache sizes
  static int _maxItemCacheSize = 50;
  static int _maxIconCacheSize = 25;

  /// Sets the maximum item cache size
  static void setMaxItemCacheSize(int maxSize) {
    _maxItemCacheSize = maxSize;
    _enforceItemCacheLimit();
  }

  /// Sets the maximum icon cache size
  static void setMaxIconCacheSize(int maxSize) {
    _maxIconCacheSize = maxSize;
    _enforceIconCacheLimit();
  }

  /// Public method to retrieve a cached item by key
  static AwesomeContextMenuItem? getCachedItem(String key) {
    if (_itemCache.containsKey(key)) {
      // Update LRU tracking - move this key to the end (most recently used)
      _lruItemKeys.remove(key);
      _lruItemKeys.add(key);

      return _itemCache[key];
    }
    return null;
  }

  /// Public method to store an item in the cache
  static void storeItem(String key, AwesomeContextMenuItem item) {
    _itemCache[key] = item;
    _lruItemKeys.add(key);
    _enforceItemCacheLimit();
  }

  /// Retrieves a cached menu item by key, or creates and caches it if not found
  static AwesomeContextMenuItem getItem(
    String key, {
    required String label,
    IconData? icon,
    VoidCallback? onSelected,
    bool enabled = true,
    bool isSeparator = false,
    bool dismissMenuOnSelect = true,
    List<AwesomeContextMenuItem>? children,
    SubMenuInteractionMode subMenuInteractionMode = SubMenuInteractionMode.auto,
  }) {
    if (_itemCache.containsKey(key)) {
      final cachedItem = _itemCache[key]!;

      // Update LRU tracking - move this key to the end (most recently used)
      _lruItemKeys.remove(key);
      _lruItemKeys.add(key);

      // Update the callback if provided, keeping the rest cached
      if (onSelected != null) {
        return AwesomeContextMenuItem(
          label: cachedItem.label,
          icon: cachedItem.icon,
          onSelected: onSelected,
          enabled: enabled,
          isSeparator: cachedItem.isSeparator,
          dismissMenuOnSelect: dismissMenuOnSelect,
          children: children ?? cachedItem.children,
          subMenuInteractionMode: subMenuInteractionMode,
        );
      }
      return cachedItem;
    }

    // Create new item and cache it
    final newItem = AwesomeContextMenuItem(
      label: label,
      icon: icon,
      onSelected: onSelected,
      enabled: enabled,
      isSeparator: isSeparator,
      dismissMenuOnSelect: dismissMenuOnSelect,
      children: children,
      subMenuInteractionMode: subMenuInteractionMode,
    );

    // Add to cache and update LRU tracking
    _itemCache[key] = newItem;
    _lruItemKeys.add(key);

    // Check if we need to enforce cache size limits
    _enforceItemCacheLimit();

    return newItem;
  }

  /// Get a cached icon or create and cache a new one
  static Icon getIcon(IconData iconData, {Color? color, double size = 18.0}) {
    final iconKey = iconData;
    if (_iconCache.containsKey(iconKey)) {
      // Update LRU tracking
      _lruIconKeys.remove(iconKey);
      _lruIconKeys.add(iconKey);

      final cachedIcon = _iconCache[iconKey]!;
      // If color is different, create a new icon but don't cache it
      if (color != null && cachedIcon.color != color) {
        return Icon(iconData, color: color, size: size);
      }
      return cachedIcon;
    }

    // Create and cache a new icon
    final newIcon = Icon(iconData, size: size);
    _iconCache[iconKey] = newIcon;
    _lruIconKeys.add(iconKey);

    // Check if we need to enforce cache size limits
    _enforceIconCacheLimit();

    return newIcon;
  }

  /// Removes least recently used items if cache exceeds maximum size
  static void _enforceItemCacheLimit() {
    while (_lruItemKeys.length > _maxItemCacheSize) {
      final oldestKey = _lruItemKeys.removeAt(0);
      _itemCache.remove(oldestKey);
    }
  }

  /// Removes least recently used icons if cache exceeds maximum size
  static void _enforceIconCacheLimit() {
    while (_lruIconKeys.length > _maxIconCacheSize) {
      final oldestKey = _lruIconKeys.removeAt(0);
      _iconCache.remove(oldestKey);
    }
  }

  /// Clears all cached items
  static void clearCache() {
    _itemCache.clear();
    _iconCache.clear();
    _lruItemKeys.clear();
    _lruIconKeys.clear();
  }

  /// Removes specific items from the cache
  static void removeFromCache(List<String> keys) {
    for (final key in keys) {
      _itemCache.remove(key);
      _lruItemKeys.remove(key);
    }
  }

  /// Gets the number of cached menu items
  static int get itemCacheSize => _itemCache.length;

  /// Gets the number of cached icons
  static int get iconCacheSize => _iconCache.length;
}

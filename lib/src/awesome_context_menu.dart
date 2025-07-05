import 'package:flutter/material.dart';
import 'awesome_context_menu_item.dart';
import 'awesome_context_menu_overlay.dart';
import 'awesome_platform_utils.dart';
import 'awesome_menu_item_cache.dart';
import 'dart:async';

/// A customizable context menu widget that displays a list of [AwesomeContextMenuItem]s.
class AwesomeContextMenu {
  /// Shows a context menu at the specified position.
  static OverlayEntry? _currentOverlayEntry;

  // Keep a reference to the current context menu overlay state
  static AwesomeContextMenuOverlayState? _currentMenuState;

  // Timer for auto-disposing unused cached resources
  static Timer? _cacheCleanupTimer;

  // Constant for menu inactivity timeout (15 minutes)
  static const Duration _cacheCleanupInterval = Duration(minutes: 15);

  // Flag to track if cache management is enabled
  static bool _autoCacheCleanupEnabled = true;

  // Animation duration for menu appearance
  static Duration _animationDuration = const Duration(milliseconds: 150);

  // Flag to prevent concurrent operations
  static bool _isOperationInProgress = false;

  // Global timestamp to track the last menu show operation
  static int _lastMenuShowTimestamp = 0;

  // Minimum time between menu operations to prevent rapid-fire requests
  static const int _minimumMenuInterval = 100; // milliseconds - increased from 50

  // Track when the last overlay was created to prevent premature cleanup
  static int _lastOverlayCreationTimestamp = 0;

  /// Shows the context menu at the specified position.
  static void show({
    required BuildContext context,
    required List<AwesomeContextMenuItem> items,
    required Offset position,
    double maxMenuWidth = 250.0,
    Color? backgroundColor,
    Color? textColor,
    Duration? animationDuration,
  }) {
    final int now = DateTime.now().millisecondsSinceEpoch;

    // Prevent rapid-fire menu requests that could cause visual flicker
    if (now - _lastMenuShowTimestamp < _minimumMenuInterval) {
      return;
    }

    // Prevent concurrent operations
    if (_isOperationInProgress) {
      return;
    }

    _lastMenuShowTimestamp = now;
    _isOperationInProgress = true;

    try {
      // If there's an existing menu, remove it first
      hide();

      final OverlayState overlay = Overlay.of(context);

      _currentOverlayEntry = OverlayEntry(
        builder: (context) {
          final menuOverlay = AwesomeContextMenuOverlay(
            items: items,
            position: position,
            maxMenuWidth: maxMenuWidth,
            backgroundColor: backgroundColor,
            textColor: textColor,
            onDismiss: () {
              hide();
            },
            animationDuration: animationDuration ?? _animationDuration,
          );

          // We'll save a reference to the menu state when it's created
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _currentMenuState = (menuOverlay.key as GlobalKey<AwesomeContextMenuOverlayState>).currentState;
          });

          return menuOverlay;
        },
      );

      overlay.insert(_currentOverlayEntry!);
      _lastOverlayCreationTimestamp = DateTime.now().millisecondsSinceEpoch;

      // Schedule cache cleanup if not already scheduled
      _scheduleCacheCleanup();
    } finally {
      _isOperationInProgress = false;
    }
  }

  /// Updates the menu items of the currently visible context menu (if any).
  static void updateItems(List<AwesomeContextMenuItem> items) {
    if (_currentMenuState != null) {
      _currentMenuState!.updateRootItems(items);
    }
  }

  /// Checks if a context menu is currently visible
  static bool isVisible() {
    return _currentOverlayEntry != null;
  }

  /// Checks if a menu operation is currently in progress
  static bool isOperationInProgress() {
    return _isOperationInProgress;
  }

  /// Hides the currently visible context menu (if any).
  static void hide() {
    _cleanupResources();
  }

  /// Clean up all resources to prevent memory leaks
  static void _cleanupResources() {
    if (_currentOverlayEntry != null) {
      // Check if cleanup is being called too soon after overlay creation
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeSinceCreation = now - _lastOverlayCreationTimestamp;

      if (timeSinceCreation < 100) {
        // Block cleanup for first 100ms
        return;
      }

      _currentOverlayEntry?.remove();
      _currentOverlayEntry = null;
      _currentMenuState = null;
    }
    // Also cancel the cleanup timer to prevent unnecessary work
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = null;
  }

  /// Enables or disables automatic cache cleanup
  static void setAutoCacheCleanup(bool enabled) {
    _autoCacheCleanupEnabled = enabled;
    if (!enabled) {
      _cacheCleanupTimer?.cancel();
      _cacheCleanupTimer = null;
    } else if (_cacheCleanupTimer == null) {
      _scheduleCacheCleanup();
    }
  }

  /// Sets the default animation duration for menus
  static void setAnimationDuration(Duration duration) {
    _animationDuration = duration;
  }

  /// Manually cleans up the cache
  static void cleanupCache() {
    AwesomeMenuItemCache.clearCache();
  }

  /// Schedules a periodic cleanup of cached resources
  static void _scheduleCacheCleanup() {
    if (!_autoCacheCleanupEnabled || _cacheCleanupTimer != null) return;

    _cacheCleanupTimer = Timer.periodic(_cacheCleanupInterval, (_) {
      // Only clean the cache if there's no active menu
      if (!isVisible()) {
        AwesomeMenuItemCache.clearCache();
      }
    });
  }

  /// Get the appropriate submenu interaction mode for the current platform.
  static SubMenuInteractionMode getPlatformDefaultInteractionMode() {
    return AwesomePlatformUtils.getPlatformDefaultInteractionMode();
  }

  /// Get the current animation duration
  static Duration getAnimationDuration() {
    return _animationDuration;
  }
}

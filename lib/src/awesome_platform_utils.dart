import 'package:flutter/foundation.dart' show kIsWeb;
import 'awesome_context_menu_item.dart';

// Use conditional imports to handle platform-specific code
import 'platform/platform_io.dart'
    if (dart.library.js) 'platform/platform_web.dart';

/// Utility class to handle platform-specific logic and operations
class AwesomePlatformUtils {
  /// Determines whether the current platform should use hover for submenus.
  static bool get isHoverPlatform {
    if (kIsWeb) return true;
    return isDesktopPlatform();
  }

  /// Returns whether the app is running on a mobile platform (iOS or Android)
  /// Also returns true for mobile browsers on web
  static bool isMobile() {
    // Check mobile platforms including mobile browsers
    return isMobilePlatform();
  }

  /// Returns whether the app is running on a desktop platform (Windows, macOS, or Linux)
  static bool isDesktop() {
    if (kIsWeb) return false;
    return isDesktopPlatform();
  }

  /// Returns whether the app is running on the web platform
  static bool isWeb() {
    return kIsWeb;
  }

  /// Returns the current platform as a user-friendly string
  static String getCurrentPlatform() {
    if (kIsWeb) return 'web';
    return getPlatformName();
  }

  /// Get the appropriate submenu interaction mode for the current platform.
  static SubMenuInteractionMode getPlatformDefaultInteractionMode() {
    return isHoverPlatform
        ? SubMenuInteractionMode.hover
        : SubMenuInteractionMode.click;
  }
}

// Platform implementation for web platform
// This file is used when the package is running on the web

import 'dart:html' as html;

/// Check if running on a mobile platform (iOS or Android)
/// Detects mobile browsers using user agent
bool isMobilePlatform() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  final platform = html.window.navigator.platform?.toLowerCase() ?? '';

  // More comprehensive mobile detection
  final mobileKeywords = ['android', 'iphone', 'ipad', 'ipod', 'blackberry', 'windows phone', 'mobile', 'tablet'];

  // Check for touch support as an additional indicator
  final touchSupport = html.window.navigator.maxTouchPoints != null && html.window.navigator.maxTouchPoints! > 0;

  return mobileKeywords.any((keyword) => userAgent.contains(keyword) || platform.contains(keyword)) || touchSupport;
}

/// Check if running on a desktop platform (Windows, macOS, Linux)
/// Always returns false on web
bool isDesktopPlatform() {
  return false; // Web is handled separately using kIsWeb
}

/// Get the current platform name as a string
/// Returns more specific platform info for mobile browsers
String getPlatformName() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  if (userAgent.contains('android')) {
    return 'web (Android)';
  } else if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
    return 'web (iOS)';
  } else if (userAgent.contains('mobile')) {
    return 'web (Mobile)';
  }
  return 'web';
}

// Platform implementation for web platform
// This file is used when the package is running on the web

/// Check if running on a mobile platform (iOS or Android)
/// Always returns false on web
bool isMobilePlatform() {
  return false; // Web is considered as non-mobile platform
}

/// Check if running on a desktop platform (Windows, macOS, Linux)
/// Always returns false on web
bool isDesktopPlatform() {
  return false; // Web is handled separately using kIsWeb
}

/// Get the current platform name as a string
/// Always returns 'web' for consistency
String getPlatformName() {
  return 'web';
}
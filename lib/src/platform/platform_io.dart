// Platform implementation for IO platforms (Android, iOS, Windows, macOS, Linux)
import 'dart:io' show Platform;

/// Check if running on a mobile platform (iOS or Android)
bool isMobilePlatform() {
  try {
    return Platform.isAndroid || Platform.isIOS;
  } catch (e) {
    return false;
  }
}

/// Check if running on a desktop platform (Windows, macOS, Linux)
bool isDesktopPlatform() {
  try {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  } catch (e) {
    return false;
  }
}

/// Get the current platform name as a string
String getPlatformName() {
  try {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    if (Platform.isFuchsia) return 'fuchsia';
    return 'unknown';
  } catch (e) {
    return 'unknown';
  }
}

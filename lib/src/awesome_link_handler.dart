import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// A utility class to handle link-related operations for the Awesome Context Menu.
class AwesomeLinkHandler {
  /// Opens a URL in a new tab.
  static Future<bool> openInNewTab(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !uri.hasAuthority) {
        throw ArgumentError('Invalid URL format: $url');
      }
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // Use debugPrint for better error reporting
      debugPrint('Failed to open URL: $url, Error: $e');
      return false;
    }
  }

  /// Copies a URL to the clipboard.
  static Future<void> copyToClipboard(String url) async {
    try {
      await Clipboard.setData(ClipboardData(text: url));
    } catch (e) {
      debugPrint('Failed to copy to clipboard: $e');
      // Could add user feedback here in the future
    }
  }

  /// Validates if a given string is a valid URL.
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (_) {
      return false;
    }
  }
}

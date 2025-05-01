import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// A utility class to handle link-related operations for the Awesome Context Menu.
class AwesomeLinkHandler {
  /// Opens a URL in a new tab.
  static Future<bool> openInNewTab(String url) async {
    final uri = Uri.parse(url);
    return await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  /// Copies a URL to the clipboard.
  static Future<void> copyToClipboard(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
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

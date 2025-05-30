## 0.0.8

* Fixed long-press context menu functionality on mobile web browsers:
  * Enhanced platform detection to recognize mobile browsers (Android Chrome, Safari on iOS, etc.)
  * Updated `AwesomePlatformUtils.isMobile()` to return true for mobile web browsers
  * Added user agent detection in web platform implementation
  * Implemented long-press gesture support for web applications running on mobile devices
  * Fixed missing `onLongPress` handler in `AwesomeContextMenuArea` widget
  * Added proper context menu positioning for long-press events on mobile browsers
  * Improved platform reporting to show "web (Android)" or "web (iOS)" for better debugging

## 0.0.7

* Enhanced test suite:
  * Added comprehensive widget tests for AwesomeContextMenuArea rendering and behavior
  * Implemented unit tests for AwesomeContextMenuItem construction and properties
  * Added tests for AwesomeLinkHandler URL validation
  * Improved test coverage for AwesomeMenuItemCache functionality and LRU behavior
  * Added tests for hierarchical menu structures and SubMenuInteractionMode
  * Implemented mouse event handler tests for hover, click, and pointer events
  * Added tests for custom styling, positioning, and builder configurations
  * Included tests for keyboard shortcuts and persistent menu items

* Documentation improvements:
  * Added detailed example project README.md
  * Updated project demo website references
  * Improved API documentation with more code examples
  * Enhanced readability of implementation docs
  * Fixed typos and formatting issues in existing documentation

## 0.0.6

* Fixed context menu flickering issue:
  * Resolved issue where menus would rapidly show, hide, then show again on right-click
  * Implemented timestamp-based event throttling to prevent duplicate events
  * Removed duplicate event handling by consolidating into a single event handler
  * Added delayed show/hide sequence to improve menu transition experience
  * Extended event handling timeout for better stability
  * Fixed minor documentation inconsistencies

## 0.0.5

* Documentation improvements:
  * Fixed README.md errors

## 0.0.4

* Added comprehensive project documentation:
  * Detailed project analysis in ANALYSIS.md
  * In-depth implementation details in IMPLEMENTATION.md
  * Updated README.md with AI-assisted development information
  * Fixed class name references throughout documentation for consistency
  * Ensured all code examples use correct class names with proper prefixes
  * Aligned documentation with actual implementation interfaces

## 0.0.3

* Web platform compatibility improvements:
  * Refactored platform detection code to avoid direct `dart:io` imports on web
  * Implemented conditional imports for platform-specific code
  * Added separate implementations for web and native platforms
  * Fixed pub.dev platform compatibility issues
  * Full web platform support without compromising native platform features

## 0.0.2

* Setup pub.dev Github Actions publishing

## 0.0.1

* Initial public release of Flutter Awesome Context Menu package
* Core features:
  * Right-click context menu support for desktop and web platforms
  * Long-press support for mobile platforms
  * Link handling with options like "Open in new tab" and "Copy link address"
  * Custom context menu items with icons and keyboard shortcut hints
  * Hierarchical/nested submenus with platform-adaptive interaction modes
  * Persistent menus that stay open after selection
  * Dynamic menu item generation and caching for performance
  * Comprehensive mouse event handling
  * CTRL+Click support for opening links in new tabs
  * Fully customizable menu styling and animation control
  * Proper positioning relative to viewport edges
  * Programmatic control to show/hide/update menus
* Platform support: Windows, macOS, Linux, Web, Android, and iOS
* Comprehensive example app with 20+ use cases demonstrating all features

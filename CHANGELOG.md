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

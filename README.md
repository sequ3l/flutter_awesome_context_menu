<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Awesome Context Menu

[![Pub Version](https://img.shields.io/pub/v/flutter_awesome_context_menu.svg)](https://pub.dev/packages/flutter_awesome_context_menu)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-blue.svg)](https://github.com/sequ3l/flutter_awesome_context_menu)
[![Star on GitHub](https://img.shields.io/github/stars/sequ3l/flutter_awesome_context_menu.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/sequ3l/flutter_awesome_context_menu)

A Flutter package that provides a browser-like right-click context menu for your Flutter applications. This package makes it easy to add context menu functionality similar to what you'd find in web browsers when right-clicking on links, as well as create fully custom context menus for any widget.

[**Live Demo**](https://sequ3l.github.io/flutter_awesome_context_menu_examples/) - Try the package in your browser

## AI-Assisted Development

This package was created through a combination of developer expertise and AI-powered collaborative development using GitHub Copilot in Agent mode with Anthropic's Claude 3.7 Sonnet model. What would typically require weeks or even a month of traditional development was completed in approximately a day through rapid application development techniques.

For those interested in the technical details:
- 📋 [**ANALYSIS.md**](ANALYSIS.md) provides a comprehensive breakdown of the project architecture, components, and features
- 🔧 [**IMPLEMENTATION.md**](IMPLEMENTATION.md) dives deep into the implementation details and design decisions

This project demonstrates how modern AI tools can dramatically accelerate the development of feature-rich packages without compromising on quality or flexibility. The development approach focused on creating robust, well-documented components through iterative refinement guided by AI assistance.

## Table of Contents

- [Flutter Compatibility](#flutter-compatibility)
- [Features](#features)
- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Platform Setup](#platform-setup)
    - [Web Platform Setup](#web-platform-setup)
    - [Android Setup](#android-setup)
    - [iOS Setup](#ios-setup)
- [Usage](#usage)
  - [Basic Usage with Link Handling](#basic-usage-with-link-handling)
  - [Custom Context Menu (No Link)](#custom-context-menu-no-link)
  - [Combining Link and Custom Items](#combining-link-and-custom-items)
  - [Dynamic Menu Items](#dynamic-menu-items)
  - [Persistent Menu Items](#persistent-menu-items)
  - [Hierarchical Context Menus](#hierarchical-context-menus)
  - [Nested Context Menus](#nested-context-menus)
- [Advanced Features](#advanced-features)
  - [Menu Styling](#menu-styling)
  - [Theme-Aware Menus](#theme-aware-menus)
  - [Menu Positioning](#menu-positioning)
  - [Mouse Event Handling](#mouse-event-handling)
  - [CTRL+Click Configuration](#ctrlclick-configuration)
  - [Menu Item Caching](#menu-item-caching)
  - [Custom Animation Settings](#custom-animation-settings)
  - [Interactive Forms in Menu](#interactive-forms-in-menu)
  - [Keyboard Shortcuts](#keyboard-shortcuts)
  - [Platform-Adaptive Menus](#platform-adaptive-menus)
- [Using AwesomeContextMenu directly](#using-awesomecontextmenu-directly)
- [Real-world Examples](#real-world-examples)
  - [Text Selection Context Menu](#text-selection-context-menu)
  - [Image Context Menu](#image-context-menu)
  - [File Context Menu](#file-context-menu)
- [API Reference](#api-reference)
  - [AwesomeContextMenuArea](#awesomecontextmenuarea)
  - [AwesomeContextMenuItem](#awesomecontextmenuitem)
  - [SubMenuInteractionMode](#submenuinteractionmode)
  - [LinkHandler](#linkhandler)
  - [PlatformUtils](#platformutils)
  - [MenuItemCache](#menuitemcache)
- [Platform Support](#platform-support)
- [Support This Project](#support-this-project)
- [Contributing](#contributing)
- [License](#license)

## Flutter Compatibility

This package is compatible with Flutter 3.x and later versions. The package uses standard Flutter APIs for mouse/touch event handling, overlay management, and widget composition that have remained stable across these Flutter versions.

## Features

- 🖱️ Right-click detection for desktop and web platforms
- 🎨 Fully customizable context menus for any widget
- 🔗 Optional built-in link handling features (open in new tab, copy link, etc.)
- ⌨️ CTRL+Click support for opening links in a new tab
- ✨ Support for custom menu items with icons
- 🧩 Flexible API that works with any widget
- 🖱️ Mouse hover and click event handling
- 🔄 Dynamic menu item generation
- 📱 Partial mobile support through long-press
- 📂 Hierarchical/nested submenus with platform-adaptive interaction
- 🚀 Performance optimization with menu item caching
- ⌨️ Display keyboard shortcuts alongside menu items
- 📝 Interactive form elements in menus
- 🎭 Theme-aware styling that adapts to your app's theme
- 📊 Custom positioning to control where menus appear
- ⚡ Customizable animation settings
- 🛠️ Optimized event handling to prevent menu flickering

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_awesome_context_menu: ^0.0.6
```

Or, if you want to use the latest development version:

```yaml
dependencies:
  flutter_awesome_context_menu:
    git:
      url: https://github.com/sequ3l/flutter_awesome_context_menu.git
```

### Dependencies

This package requires the `url_launcher` package to handle link operations. If you use the link functionality, make sure to configure platform-specific settings as required by `url_launcher`:

```yaml
dependencies:
  flutter_awesome_context_menu: ^0.0.6
  url_launcher: ^6.3.1 # Already included as a dependency of this package
```

#### Web Platform Setup

For web applications, no additional setup is required for basic functionality. However, for the best experience, you should disable the browser's default context menu to prevent conflicts with the Flutter Awesome Context Menu.

Add the following to your `index.html` file (typically located in your project's `web` folder):

```html
<style>
  /* Prevent text selection on double-click */
  body {
    user-select: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
  }
</style>
  
<script>
  // Disable the browser's default context menu
  document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
    return false;
  });
</script>
```

This code prevents the browser's native context menu from appearing when a user right-clicks, allowing your Flutter Awesome Context Menu to work as intended. The CSS also prevents text selection on double-click, which can improve the user experience on web platforms.

#### Android Setup

Update your `AndroidManifest.xml` file to include:

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" />
  </intent>
</queries>
```

#### iOS Setup

Update your `ios/Runner/Info.plist` to include:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
</array>
```

## Usage

### Basic Usage with Link Handling

To add a Awesome Context Menu with link functionality to any widget:

```dart
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';

AwesomeContextMenuArea(
  link: 'https://flutter.dev',  // Optional: provide a URL to enable link context menu items
  child: Text(
    'Flutter Website',
    style: TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  ),
)
```

When a link is provided, this will automatically show the standard browser link context menu options:
- "Open link in new tab"
- "Copy link address"

Additionally, CTRL+Click (or CMD+Click on macOS) will open the link directly in a new tab.

### Custom Context Menu (No Link)

You can use the package purely for custom context menus without any link functionality:

```dart
AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Custom action',
      icon: Icons.star,
      onSelected: () {
        print('Custom action selected!');
      },
    ),
    AwesomeContextMenuItem.separator(),
    AwesomeContextMenuItem(
      label: 'Disabled item',
      icon: Icons.block,
      enabled: false,
    ),
  ],
  child: Text('Right-click me for a custom menu'),
)
```

### Combining Link and Custom Items

You can combine both link functionality and custom menu items:

```dart
AwesomeContextMenuArea(
  link: 'https://github.com/flutter/flutter',
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Star Repository',
      icon: Icons.star,
      onSelected: () {
        print('Star Repository clicked');
      },
    ),
  ],
  child: Text('Flutter Repository'),
)
```

### Dynamic Menu Items

You can generate menu items dynamically using the `menuItemBuilder` callback:

```dart
AwesomeContextMenuArea(
  menuItemBuilder: (context) {
    return [
      AwesomeContextMenuItem(
        label: 'Generated at ${DateTime.now().toString()}',
        icon: Icons.access_time,
        onSelected: () {},
      ),
      AwesomeContextMenuItem(
        label: 'Screen width: ${MediaQuery.of(context).size.width.toStringAsFixed(0)}px',
        icon: Icons.aspect_ratio,
        onSelected: () {},
      ),
    ];
  },
  child: Text('Dynamic menu items'),
)
```

### Persistent Menu Items

You can create menu items that don't dismiss the menu when selected:

```dart
AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Toggle Option',
      icon: Icons.check_box_outline_blank,
      dismissMenuOnSelect: false, // Keep menu open after selection
      onSelected: () {
        // Toggle some state without closing the menu
      },
    ),
  ],
  child: Text('Menu stays open after selection'),
)
```

### Hierarchical Context Menus

You can create nested context menus with submenus:

```dart
AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: 'File',
      icon: Icons.folder,
      children: [  // Submenu items
        AwesomeContextMenuItem(
          label: 'New',
          icon: Icons.add,
          children: [  // Second level submenu
            AwesomeContextMenuItem(
              label: 'Document',
              icon: Icons.description,
              onSelected: () => print('New Document'),
            ),
            AwesomeContextMenuItem(
              label: 'Spreadsheet',
              icon: Icons.grid_on,
              onSelected: () => print('New Spreadsheet'),
            ),
          ],
        ),
        AwesomeContextMenuItem(
          label: 'Open',
          icon: Icons.folder_open,
          onSelected: () => print('Open'),
        ),
        AwesomeContextMenuItem.separator(),
        AwesomeContextMenuItem(
          label: 'Save',
          icon: Icons.save,
          onSelected: () => print('Save'),
        ),
      ],
    ),
    AwesomeContextMenuItem(
      label: 'Edit',
      icon: Icons.edit,
      children: [
        AwesomeContextMenuItem(
          label: 'Cut',
          icon: Icons.content_cut,
          onSelected: () => print('Cut'),
        ),
        AwesomeContextMenuItem(
          label: 'Copy',
          icon: Icons.content_copy,
          onSelected: () => print('Copy'),
        ),
        AwesomeContextMenuItem(
          label: 'Paste',
          icon: Icons.content_paste,
          onSelected: () => print('Paste'),
        ),
      ],
    ),
  ],
  child: Text('Menu with hierarchical submenus'),
)
```

#### Custom Submenu Interaction Modes

You can control how submenus are revealed:

```dart
AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Hover to Reveal',
      icon: Icons.mouse,
      subMenuInteractionMode: SubMenuInteractionMode.hover,
      children: [
        AwesomeContextMenuItem(
          label: 'Only shown on hover',
          onSelected: () {},
        ),
      ],
    ),
    AwesomeContextMenuItem(
      label: 'Click to Reveal',
      icon: Icons.touch_app,
      subMenuInteractionMode: SubMenuInteractionMode.click,
      children: [
        AwesomeContextMenuItem(
          label: 'Only shown on click/tap',
          onSelected: () {},
        ),
      ],
    ),
    AwesomeContextMenuItem(
      label: 'Long Press to Reveal',
      icon: Icons.touch_app,
      subMenuInteractionMode: SubMenuInteractionMode.longPress,
      children: [
        AwesomeContextMenuItem(
          label: 'Only shown on long press',
          onSelected: () {},
        ),
      ],
    ),
    AwesomeContextMenuItem(
      label: 'Auto (Platform Dependent)',
      icon: Icons.devices,
      // This is the default behavior - hover on desktop, click on mobile
      subMenuInteractionMode: SubMenuInteractionMode.auto,
      children: [
        AwesomeContextMenuItem(
          label: 'Uses platform default interaction',
          onSelected: () {},
        ),
      ],
    ),
  ],
  child: Text('Multiple submenu interaction modes'),
)
```

### Nested Context Menus

You can nest `AwesomeContextMenuArea` widgets to create layered context menus that don't interfere with each other:

```dart
AwesomeContextMenuArea(
  // Parent context menu configuration
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Parent action',
      icon: Icons.house,
      onSelected: () {
        print('Parent action selected');
      },
    ),
  ],
  child: Container(
    padding: const EdgeInsets.all(16),
    color: Colors.blue.withOpacity(0.1),
    child: Column(
      children: [
        Text('Parent area'),
        // Nested context menu
        AwesomeContextMenuArea(
          // Child context menu configuration
          menuItems: [
            AwesomeContextMenuItem(
              label: 'Child action',
              icon: Icons.child_care,
              onSelected: () {
                print('Child action selected');
              },
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.green.withOpacity(0.1),
            child: Text('Child area with its own context menu'),
          ),
        ),
      ],
    ),
  ),
)
```

This is useful for creating page-level context menus while having specific widgets with their own context menus. The child context menu will take precedence when right-clicking in its area, while the parent context menu will be displayed when right-clicking elsewhere in the parent widget.

## Advanced Features

### Menu Styling

You can customize the appearance of the context menu:

```dart
AwesomeContextMenuArea(
  link: 'https://flutter.dev',
  backgroundColor: Colors.black87,
  textColor: Colors.white,
  maxMenuWidth: 300,
  child: Text('Custom styled menu'),
)
```

### Theme-Aware Menus

You can create menus that automatically adapt to your app's current theme:

```dart
AwesomeContextMenuArea(
  backgroundColor: isDark ? theme.colorScheme.surfaceVariant : null,
  textColor: isDark ? theme.colorScheme.onSurfaceVariant : null,
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Current theme: ${isDark ? "Dark" : "Light"}',
      icon: isDark ? Icons.dark_mode : Icons.light_mode,
    ),
    // Additional menu items...
  ],
  child: YourWidget(),
)
```

### Menu Positioning

Control exactly where the context menu appears:

```dart
AwesomeContextMenuArea(
  customPositionCallback: (rect, size) {
    // Position menu at the top-left corner of the widget
    return rect.topLeft;
    
    // Or at the bottom-right:
    // return rect.bottomRight;
    
    // Or at the center:
    // return rect.center;
  },
  menuItems: [...],
  child: YourWidget(),
)
```

### Mouse Event Handling

The widget provides comprehensive mouse event handling:

```dart
AwesomeContextMenuArea(
  link: 'https://flutter.dev',
  onRightClick: (position) {
    print('Right-clicked at position: $position');
  },
  onClick: () {
    print('Normal left click occurred');
  },
  onMouseEnter: (event) {
    print('Mouse entered the area');
  },
  onMouseExit: (event) {
    print('Mouse exited the area');
  },
  onMouseHover: (event) {
    print('Mouse hovering at ${event.position}');
  },
  child: Text('Event handling example'),
)
```

### CTRL+Click Configuration

You can customize the CTRL+Click functionality:

```dart
AwesomeContextMenuArea(
  link: 'https://flutter.dev',
  handleCtrlClick: true, // Set to false to disable CTRL+Click behavior
  onCtrlClick: () {
    print('CTRL+Click detected and handled');
  },
  child: Text('CTRL+Click example'),
)
```

### Menu Item Caching

Improve performance by caching frequently used menu items:

```dart
AwesomeContextMenuItem.getCachedItem(
  'edit',  // Cache key
  () => AwesomeContextMenuItem(
    label: 'Edit',
    icon: Icons.edit,
    onSelected: () => print('Edit action'),
  ),
)
```

You can clear the cache manually:

```dart
AwesomeContextMenu.cleanupCache();
```

Or control auto-cleanup:

```dart
AwesomeContextMenu.setAutoCacheCleanup(true); // Enable automatic cache cleanup
```

### Custom Animation Settings

Control the animation speed of your context menus:

```dart
// Set globally for all menus
AwesomeContextMenu.setAnimationDuration(Duration(milliseconds: 300));

// Or individually for a specific menu
AwesomeContextMenuArea(
  animationDuration: Duration(milliseconds: 200),
  menuItems: [...],
  child: YourWidget(),
)
```

### Interactive Forms in Menu

Create rich, interactive menus with form elements:

```dart
AwesomeContextMenuArea(
  useCustomBuilder: true,
  customMenuBuilder: (context, closeMenu) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            decoration: InputDecoration(hintText: 'Enter text...'),
          ),
          Slider(
            value: 0.5,
            onChanged: (value) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: closeMenu,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save changes
                  closeMenu();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  },
  child: YourWidget(),
)
```

> **Note:** Interactive form elements like TextField and Slider will work properly within the menu and won't cause the menu to dismiss unexpectedly. The menu will properly close when clicking outside the menu area or when using the provided closeMenu callback function.

### Keyboard Shortcuts

Display keyboard shortcuts alongside menu items:

```dart
AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: 'Copy',
      icon: Icons.content_copy,
      shortcut: 'Ctrl+C',
      onSelected: () {},
    ),
    AwesomeContextMenuItem(
      label: 'Paste',
      icon: Icons.content_paste,
      shortcut: 'Ctrl+V',
      onSelected: () {},
    ),
  ],
  child: YourWidget(),
)
```

### Platform-Adaptive Menus

Create menus that adapt to the current platform:

```dart
final bool isMobile = PlatformUtils.isMobile();
final String platform = PlatformUtils.getCurrentPlatform();
final SubMenuInteractionMode defaultMode = AwesomeContextMenu.getPlatformDefaultInteractionMode();

AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: isMobile ? 'Mobile Action' : 'Desktop Action',
      icon: isMobile ? Icons.smartphone : Icons.desktop_windows,
      onSelected: () {},
    ),
    AwesomeContextMenuItem(
      label: 'Platform Submenu',
      subMenuInteractionMode: defaultMode, // Platform-specific interaction
      children: [...],
    ),
  ],
  shortcutLabel: isMobile ? 'Long press' : 'Right-click',
  child: YourWidget(),
)
```

## Using AwesomeContextMenu directly

While `AwesomeContextMenuArea` is the main widget for creating context menu areas, you can also use the `AwesomeContextMenu` class directly:

```dart
// Show a context menu programmatically
void showMyContextMenu(BuildContext context, Offset position) {
  AwesomeContextMenu.show(
    context: context,
    items: [
      AwesomeContextMenuItem(
        label: 'Custom Action',
        icon: Icons.star,
        onSelected: () {
          print('Action triggered!');
        },
      ),
    ],
    position: position,
    maxMenuWidth: 250.0,
  );
}

// To update the menu items of a currently visible menu:
void updateCurrentMenu() {
  AwesomeContextMenu.updateItems([
    AwesomeContextMenuItem(
      label: 'Updated Item',
      icon: Icons.refresh,
      onSelected: () {},
    ),
  ]);
}

// To hide the menu programmatically:
void hideMenu() {
  AwesomeContextMenu.hide();
}
```

### Real-world Examples

#### Text Selection Context Menu

```dart
SelectableText(
  'Select this text to see a custom context menu',
  contextMenuBuilder: (context, editableTextState) {
    final TextEditingValue value = editableTextState.textEditingValue;
    final selectedText = value.selection.textInside(value.text);
    
    return AwesomeContextMenuArea(
      menuItems: [
        if (selectedText.isNotEmpty) ...[
          AwesomeContextMenuItem(
            label: 'Copy',
            icon: Icons.copy,
            onSelected: () {
              Clipboard.setData(ClipboardData(text: selectedText));
            },
          ),
          AwesomeContextMenuItem(
            label: 'Search for "$selectedText"',
            icon: Icons.search,
            onSelected: () {
              launchUrl(Uri.parse('https://google.com/search?q=$selectedText'));
            },
          ),
        ]
      ],
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: editableTextState.renderObject.buildTextSpanWithSelection(
          context, 
          value, 
          TextStyle(color: Colors.black),
        ),
      ),
    );
  },
)
```

#### Image Context Menu

```dart
AwesomeContextMenuArea(
  menuItems: [
    AwesomeContextMenuItem(
      label: 'View Image',
      icon: Icons.image,
      onSelected: () {
        // Open image in full-screen viewer
      },
    ),
    AwesomeContextMenuItem(
      label: 'Save Image',
      icon: Icons.download,
      onSelected: () {
        // Save the image
      },
    ),
    AwesomeContextMenuItem(
      label: 'Copy Image',
      icon: Icons.content_copy,
      onSelected: () {
        // Copy image to clipboard
      },
    ),
  ],
  child: Image.network('https://picsum.photos/200'),
)
```

#### File Context Menu

```dart
AwesomeContextMenuArea(
  menuItemBuilder: (context) {
    // You can dynamically build menu items based on current state
    if (isDirectory) {
      return [
        AwesomeContextMenuItem(
          label: 'Open Folder',
          icon: Icons.folder_open,
          onSelected: () => openFolder(path),
        ),
        AwesomeContextMenuItem(
          label: 'New File',
          icon: Icons.add,
          onSelected: () => createNewFile(path),
        ),
      ];
    } else {
      return [
        AwesomeContextMenuItem(
          label: 'Open File',
          icon: Icons.description,
          onSelected: () => openFile(path),
        ),
        AwesomeContextMenuItem(
          label: 'Delete',
          icon: Icons.delete,
          onSelected: () => deleteFile(path),
        ),
      ];
    }
  },
  child: ListTile(
    leading: Icon(isDirectory ? Icons.folder : Icons.insert_drive_file),
    title: Text(fileName),
  ),
)
```

## API Reference

### AwesomeContextMenuArea

Main widget to wrap content with context menu functionality.

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The widget to wrap with context menu functionality |
| `menuItems` | `List<AwesomeContextMenuItem>?` | List of custom menu items to show |
| `link` | `String?` | URL to associate with this area |
| `onRightClick` | `void Function(Offset)?` | Callback when right-click occurs |
| `onClick` | `VoidCallback?` | Callback when normal click occurs |
| `onMouseEnter` | `void Function(PointerEnterEvent)?` | Callback when mouse enters the area |
| `onMouseExit` | `void Function(PointerExitEvent)?` | Callback when mouse exits the area |
| `onMouseHover` | `void Function(PointerHoverEvent)?` | Callback when mouse hovers over the area |
| `onMouseMove` | `void Function(PointerMoveEvent)?` | Callback when mouse moves within the area |
| `showDefaultLinkItems` | `bool` | Whether to show default browser link menu items |
| `handleCtrlClick` | `bool` | Whether to handle CTRL+Click to open links in new tabs |
| `onCtrlClick` | `VoidCallback?` | Callback when CTRL+Click occurs on a link |
| `menuItemBuilder` | `List<AwesomeContextMenuItem> Function(BuildContext)?` | Dynamic menu item builder |
| `maxMenuWidth` | `double` | Maximum width of the context menu |
| `backgroundColor` | `Color?` | Background color of the context menu |
| `textColor` | `Color?` | Text color of the context menu items |
| `animationDuration` | `Duration?` | Duration for menu animation |
| `customPositionCallback` | `Offset Function(Rect, Size)?` | Custom positioning for menu |
| `useCustomBuilder` | `bool` | Whether to use a custom menu builder |
| `customMenuBuilder` | `Widget Function(BuildContext, VoidCallback)?` | Builder for custom menu UI |
| `shortcutLabel` | `String?` | Text label for interaction hint (e.g., "Right-click") |

### AwesomeContextMenuItem

Represents an individual menu item in the context menu.

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `String` | Text label for the menu item |
| `icon` | `IconData?` | Optional icon for the menu item |
| `onSelected` | `VoidCallback?` | Callback when menu item is selected |
| `enabled` | `bool` | Whether the menu item is enabled |
| `isSeparator` | `bool` | Whether this item is a separator line |
| `dismissMenuOnSelect` | `bool` | Whether to dismiss the menu when this item is selected |
| `children` | `List<AwesomeContextMenuItem>?` | Child menu items for hierarchical menus |
| `subMenuInteractionMode` | `SubMenuInteractionMode` | How to reveal the submenu (hover, click, long press) |
| `shortcut` | `String?` | Text representing a keyboard shortcut |

### SubMenuInteractionMode

Defines how submenu items are revealed when interacting with a parent menu item.

| Value | Description |
|-------|-------------|
| `auto` | Automatically choose the best interaction mode for the current platform (hover for desktop, click for mobile) |
| `hover` | Show submenu when hovering over the parent menu item (best for desktop) |
| `click` | Show submenu when clicking/tapping the parent menu item (works on all platforms) |
| `longPress` | Show submenu when long-pressing the parent menu item (alternative for mobile) |

### LinkHandler

Utility class for handling link-related operations.

| Method | Parameters | Description |
|--------|------------|-------------|
| `openInNewTab` | `String url` | Opens a URL in a new tab |
| `copyToClipboard` | `String url` | Copies URL to clipboard |
| `isValidUrl` | `String url` | Validates if string is a valid URL |

### PlatformUtils

Utility class for platform detection and adaptation.

| Method | Parameters | Description |
|--------|------------|-------------|
| `isHoverPlatform` | - | Returns true if running on a platform that supports hover interactions (desktop or web) |
| `isMobile` | - | Returns true if running on a mobile platform |
| `isDesktop` | - | Returns true if running on a desktop platform |
| `isWeb` | - | Returns true if running on the web |
| `getCurrentPlatform` | - | Returns the current platform as a string |
| `getPlatformDefaultInteractionMode` | - | Returns the recommended interaction mode for the current platform |

### MenuItemCache

Utility class for caching frequently used menu items and icons.

| Method | Parameters | Description |
|--------|------------|-------------|
| `getCachedItem` | `String key` | Retrieves a cached menu item by key |
| `storeItem` | `String key, AwesomeContextMenuItem item` | Stores a menu item in the cache |
| `getItem` | Various parameters for creating a menu item | Creates or retrieves a cached menu item |
| `getIcon` | `IconData iconData, [Color? color], [double size]` | Creates or retrieves a cached icon |
| `clearCache` | - | Clears all cached items and icons |
| `setMaxItemCacheSize` | `int maxSize` | Sets the maximum number of menu items to cache |
| `setMaxIconCacheSize` | `int maxSize` | Sets the maximum number of icons to cache |

## Platform Support

| Platform | Support |
|----------|---------|
| Windows  | ✓ |
| macOS    | ✓ |
| Linux    | ✓ |
| Web      | ✓ |
| Android  | Partial (shows on long press) |
| iOS      | Partial (shows on long press) |

## Support This Project

If you find this package helpful, consider buying me a coffee to support ongoing development and maintenance!

<a href="https://www.buymeacoffee.com/sequ3l" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60px">
</a>

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'Add some amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

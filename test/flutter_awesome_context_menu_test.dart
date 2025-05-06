import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';

void main() {
  group('AwesomeContextMenuItem Tests', () {
    test('AwesomeContextMenuItem should construct properly', () {
      const item = AwesomeContextMenuItem(
        label: 'Test Item',
        icon: Icons.add,
        enabled: true,
      );

      expect(item.label, 'Test Item');
      expect(item.icon, Icons.add);
      expect(item.enabled, true);
      expect(item.isSeparator, false);
      expect(item.dismissMenuOnSelect, true); // Default value should be true
    });

    test('AwesomeContextMenuItem.separator() should create a separator', () {
      final separator = AwesomeContextMenuItem.separator();

      expect(separator.isSeparator, true);
      expect(separator.enabled, true);
      expect(separator.label, '');
    });

    test('AwesomeContextMenuItem asserts on empty label unless it is a separator', () {
      expect(() => AwesomeContextMenuItem(label: ''), throwsAssertionError);
      expect(() => AwesomeContextMenuItem.separator(), isNot(throwsAssertionError));
    });

    test('AwesomeContextMenuItem hasSubmenu should be true when children are provided', () {
      const itemWithSubmenu = AwesomeContextMenuItem(
        label: 'Parent Item',
        children: [
          AwesomeContextMenuItem(label: 'Child Item 1'),
          AwesomeContextMenuItem(label: 'Child Item 2'),
        ],
      );

      expect(itemWithSubmenu.hasSubmenu, isTrue);
      expect(itemWithSubmenu.children?.length, 2);

      const itemWithoutSubmenu = AwesomeContextMenuItem(label: 'Item without children');
      expect(itemWithoutSubmenu.hasSubmenu, isFalse);
      expect(itemWithoutSubmenu.children, isNull);
    });
  });

  group('AwesomeLinkHandler Tests', () {
    test('isValidUrl validates URLs correctly', () {
      expect(AwesomeLinkHandler.isValidUrl('https://flutter.dev'), isTrue);
      expect(AwesomeLinkHandler.isValidUrl('http://example.com'), isTrue);
      expect(AwesomeLinkHandler.isValidUrl('flutter.dev'), isFalse);
      expect(AwesomeLinkHandler.isValidUrl('not a url'), isFalse);
      expect(AwesomeLinkHandler.isValidUrl(''), isFalse);
    });
  });

  group('AwesomeMenuItemCache Tests', () {
    test('AwesomeMenuItemCache getItem should create and cache items', () {
      // Get a new cached item
      final item1 = AwesomeMenuItemCache.getItem(
        'test_item',
        label: 'Cached Item',
        icon: Icons.star,
      );

      expect(item1.label, 'Cached Item');
      expect(item1.icon, Icons.star);

      // Get the same item again, should be from cache
      final item2 = AwesomeMenuItemCache.getItem(
        'test_item',
        label: 'Cached Item',
        icon: Icons.star,
      );

      // Should be the same instance
      expect(identical(item1, item2), isTrue);

      // Clean up
      AwesomeMenuItemCache.clearCache();
      expect(AwesomeMenuItemCache.itemCacheSize, 0);
    });

    test('AwesomeMenuItemCache removes least recently used items when limit exceeded', () {
      // Set a small cache size limit for testing
      AwesomeMenuItemCache.setMaxItemCacheSize(3);

      // Add items to fill cache
      AwesomeMenuItemCache.getItem('item1', label: 'Item 1');
      AwesomeMenuItemCache.getItem('item2', label: 'Item 2');
      AwesomeMenuItemCache.getItem('item3', label: 'Item 3');

      // Add one more item to push out the least recently used
      AwesomeMenuItemCache.getItem('item4', label: 'Item 4');

      // item1 should be removed
      var newItem1 = AwesomeMenuItemCache.getItem('item1', label: 'Item 1 New');
      expect(newItem1.label, 'Item 1 New'); // Not from cache, new instance

      // Clean up
      AwesomeMenuItemCache.clearCache();
    });
  });

  group('AwesomeContextMenuArea Widget Tests', () {
    testWidgets('AwesomeContextMenuArea renders child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              child: Text('Test Child'),
            ),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('AwesomeContextMenuArea with link changes cursor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              link: 'https://flutter.dev',
              child: Text('Test Link'),
            ),
          ),
        ),
      );

      expect(find.text('Test Link'), findsOneWidget);

      final mouseRegion = tester.widget<MouseRegion>(
        find.ancestor(
          of: find.text('Test Link'),
          matching: find.byType(MouseRegion),
        ),
      );

      expect(mouseRegion.cursor, equals(SystemMouseCursors.click));
    });

    testWidgets('AwesomeContextMenuArea handles onClick callback', (WidgetTester tester) async {
      bool onClickCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              onClick: () {
                onClickCalled = true;
              },
              child: const Text('Clickable'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clickable'));
      await tester.pump();

      expect(onClickCalled, isTrue);
    });

    testWidgets('AwesomeContextMenuArea handles mouse events', (WidgetTester tester) async {
      bool mouseEnterCalled = false;
      bool mouseExitCalled = false;
      bool mouseHoverCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AwesomeContextMenuArea(
                onMouseEnter: (_) => mouseEnterCalled = true,
                onMouseExit: (_) => mouseExitCalled = true,
                onMouseHover: (_) => mouseHoverCalled = true,
                child: const SizedBox(
                  width: 100,
                  height: 100,
                  child: Text('Hover Target'),
                ),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);

      // Test mouse enter
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.text('Hover Target')));
      await tester.pump();
      expect(mouseEnterCalled, isTrue);
      expect(mouseHoverCalled, isTrue);

      // Test mouse exit
      await gesture.moveTo(const Offset(0, 0));
      await tester.pump();
      expect(mouseExitCalled, isTrue);
    });
  });

  group('AwesomeContextMenu Tests', () {
    test('AwesomeContextMenu animation duration can be configured', () {
      // Default duration
      expect(AwesomeContextMenu.getAnimationDuration().inMilliseconds, 150);

      // Set custom duration
      const customDuration = Duration(milliseconds: 300);
      AwesomeContextMenu.setAnimationDuration(customDuration);

      expect(AwesomeContextMenu.getAnimationDuration(), customDuration);

      // Reset to default for other tests
      AwesomeContextMenu.setAnimationDuration(const Duration(milliseconds: 150));
    });

    test('AwesomeContextMenu platform default interaction mode', () {
      // Get default interaction mode
      final mode = AwesomeContextMenu.getPlatformDefaultInteractionMode();
      // Should return a valid interaction mode
      expect(mode, isA<SubMenuInteractionMode>());
    });
  });

  group('Platform Utils Tests', () {
    test('AwesomePlatformUtils provides platform information', () {
      // These are static methods that return platform-specific information
      expect(AwesomePlatformUtils.getCurrentPlatform(), isA<String>());
      expect(AwesomePlatformUtils.isWeb(), isA<bool>());
      expect(AwesomePlatformUtils.isDesktop(), isA<bool>());
      expect(AwesomePlatformUtils.isMobile(), isA<bool>());
      expect(AwesomePlatformUtils.isHoverPlatform, isA<bool>());
      expect(AwesomePlatformUtils.getPlatformDefaultInteractionMode(), isA<SubMenuInteractionMode>());
    });
  });

  group('Hierarchical Menu Structure Tests', () {
    test('AwesomeContextMenuItem properly represents hierarchical structure', () {
      const parentItem = AwesomeContextMenuItem(
        label: 'Parent Menu',
        icon: Icons.folder,
        children: [
          AwesomeContextMenuItem(
            label: 'Child Item 1',
            icon: Icons.description,
          ),
          AwesomeContextMenuItem(
            label: 'Child Item 2',
            icon: Icons.image,
            children: [
              AwesomeContextMenuItem(
                label: 'Grandchild Item',
                icon: Icons.photo,
              ),
            ],
          ),
        ],
      );

      // Verify hierarchical structure
      expect(parentItem.hasSubmenu, isTrue);
      expect(parentItem.children, hasLength(2));
      expect(parentItem.children![0].label, 'Child Item 1');
      expect(parentItem.children![1].hasSubmenu, isTrue);
      expect(parentItem.children![1].children![0].label, 'Grandchild Item');
    });

    test('SubMenuInteractionMode values are defined correctly', () {
      // Verify all modes are available
      expect(SubMenuInteractionMode.auto, isNotNull);
      expect(SubMenuInteractionMode.hover, isNotNull);
      expect(SubMenuInteractionMode.click, isNotNull);
      expect(SubMenuInteractionMode.longPress, isNotNull);
    });
  });

  group('Menu Item Properties Tests', () {
    test('AwesomeContextMenuItem properly handles keyboard shortcuts', () {
      const item = AwesomeContextMenuItem(
        label: 'Copy',
        icon: Icons.content_copy,
        shortcut: 'Ctrl+C',
      );

      expect(item.shortcut, 'Ctrl+C');
    });

    test('AwesomeContextMenuItem handles dismissMenuOnSelect property', () {
      const itemDismiss = AwesomeContextMenuItem(
        label: 'Normal Item',
        dismissMenuOnSelect: true,
      );

      const itemPersistent = AwesomeContextMenuItem(
        label: 'Persistent Item',
        dismissMenuOnSelect: false,
      );

      expect(itemDismiss.dismissMenuOnSelect, isTrue);
      expect(itemPersistent.dismissMenuOnSelect, isFalse);
    });

    test('AwesomeContextMenuItem handles enabled state', () {
      const enabledItem = AwesomeContextMenuItem(
        label: 'Enabled Item',
        enabled: true,
      );

      const disabledItem = AwesomeContextMenuItem(
        label: 'Disabled Item',
        enabled: false,
      );

      expect(enabledItem.enabled, isTrue);
      expect(disabledItem.enabled, isFalse);
    });
  });

  group('AwesomeContextMenuArea Configuration Tests', () {
    test('AwesomeContextMenuArea accepts all configuration properties', () {
      final widget = AwesomeContextMenuArea(
        link: 'https://flutter.dev',
        menuItems: [
          AwesomeContextMenuItem(label: 'Test Item'),
        ],
        showDefaultLinkItems: true,
        handleCtrlClick: true,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        maxMenuWidth: 300,
        animationDuration: const Duration(milliseconds: 200),
        shortcutLabel: 'Right-click',
        child: const Text('Test Widget'),
      );

      // Verify that all properties are accepted without errors
      expect(widget.link, 'https://flutter.dev');
      expect(widget.menuItems, isNotNull);
      expect(widget.menuItems!.length, 1);
      expect(widget.showDefaultLinkItems, isTrue);
      expect(widget.handleCtrlClick, isTrue);
      expect(widget.backgroundColor, Colors.black);
      expect(widget.textColor, Colors.white);
      expect(widget.maxMenuWidth, 300);
      expect(widget.animationDuration, const Duration(milliseconds: 200));
      expect(widget.shortcutLabel, 'Right-click');
    });
  });

  group('Dynamic Menu Generation Tests', () {
    testWidgets('menuItemBuilder generates items dynamically', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: AwesomeContextMenuArea(
                  menuItemBuilder: (context) {
                    return [
                      AwesomeContextMenuItem(
                        label: 'Dynamic Item',
                        icon: Icons.refresh,
                      ),
                    ];
                  },
                  child: const Text('Dynamic Menu Test'),
                ),
              );
            },
          ),
        ),
      );

      // Verify widget built successfully
      expect(find.text('Dynamic Menu Test'), findsOneWidget);

      // Access the AwesomeContextMenuArea to verify menuItemBuilder
      final finder = find.byType(AwesomeContextMenuArea);
      expect(finder, findsOneWidget);

      final widget = tester.widget<AwesomeContextMenuArea>(finder);
      expect(widget.menuItemBuilder, isNotNull);
    });
  });

  group('Custom Builder Tests', () {
    testWidgets('customMenuBuilder is properly configured', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              useCustomBuilder: true,
              customMenuBuilder: (context, closeMenu) {
                return Container(
                  color: Colors.blue,
                  child: const Text('Custom Menu'),
                );
              },
              child: const Text('Custom Builder Test'),
            ),
          ),
        ),
      );

      // Verify widget built successfully
      expect(find.text('Custom Builder Test'), findsOneWidget);

      // Verify custom builder properties
      final widget = tester.widget<AwesomeContextMenuArea>(find.byType(AwesomeContextMenuArea));
      expect(widget.useCustomBuilder, isTrue);
      expect(widget.customMenuBuilder, isNotNull);
    });
  });

  group('Menu Styling Tests', () {
    testWidgets('styling properties are properly configured', (tester) async {
      final customColor = Colors.purple[900]!;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              backgroundColor: customColor,
              textColor: Colors.white,
              maxMenuWidth: 300,
              menuItems: [AwesomeContextMenuItem(label: 'Styled Item')],
              child: const Text('Styled Menu Test'),
            ),
          ),
        ),
      );

      // Verify widget built successfully
      expect(find.text('Styled Menu Test'), findsOneWidget);

      // Verify styling properties
      final widget = tester.widget<AwesomeContextMenuArea>(find.byType(AwesomeContextMenuArea));
      expect(widget.backgroundColor, customColor);
      expect(widget.textColor, Colors.white);
      expect(widget.maxMenuWidth, 300);
    });
  });

  group('Mouse Event Handlers Tests', () {
    testWidgets('mouse event handlers are properly configured', (tester) async {
      bool onRightClickCalled = false;
      bool onClickCalled = false;
      bool onMouseEnterCalled = false;
      bool onMouseExitCalled = false;
      bool onMouseHoverCalled = false;
      bool onMouseMoveCalled = false;
      bool onCtrlClickCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              onRightClick: (_) => onRightClickCalled = true,
              onClick: () => onClickCalled = true,
              onMouseEnter: (_) => onMouseEnterCalled = true,
              onMouseExit: (_) => onMouseExitCalled = true,
              onMouseHover: (_) => onMouseHoverCalled = true,
              onMouseMove: (_) => onMouseMoveCalled = true,
              onCtrlClick: () => onCtrlClickCalled = true,
              child: const Text('Event Handlers Test'),
            ),
          ),
        ),
      );

      // Verify widget built successfully
      expect(find.text('Event Handlers Test'), findsOneWidget);

      // Verify handlers are configured
      final widget = tester.widget<AwesomeContextMenuArea>(find.byType(AwesomeContextMenuArea));
      expect(widget.onRightClick, isNotNull);
      expect(widget.onClick, isNotNull);
      expect(widget.onMouseEnter, isNotNull);
      expect(widget.onMouseExit, isNotNull);
      expect(widget.onMouseHover, isNotNull);
      expect(widget.onMouseMove, isNotNull);
      expect(widget.onCtrlClick, isNotNull);

      // Test basic click handling (one that's reliable in widget tests)
      await tester.tap(find.text('Event Handlers Test'));
      await tester.pump();
      expect(onClickCalled, isTrue);
    });
  });

  group('Custom Position Callback Tests', () {
    testWidgets('customPositionCallback is properly configured', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              customPositionCallback: (rect, menuSize) {
                return rect.topRight;
              },
              menuItems: [AwesomeContextMenuItem(label: 'Positioned Item')],
              child: const Text('Custom Position Test'),
            ),
          ),
        ),
      );

      // Verify widget built successfully
      expect(find.text('Custom Position Test'), findsOneWidget);

      // Verify custom position callback is configured
      final widget = tester.widget<AwesomeContextMenuArea>(find.byType(AwesomeContextMenuArea));
      expect(widget.customPositionCallback, isNotNull);
    });
  });
}

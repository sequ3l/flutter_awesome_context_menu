import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Added import for PointerDeviceKind
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
    // These tests are more limited since we can't easily test overlay behavior in widget tests
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
  });
}

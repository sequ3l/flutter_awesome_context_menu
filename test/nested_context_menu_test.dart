import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';

void main() {
  group('Nested Context Menu Tests', () {
    testWidgets('Nested context menus should not show double menus', (WidgetTester tester) async {
      // Build a widget with nested context menus
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              menuItems: [
                AwesomeContextMenuItem(
                  label: 'Outer Menu Item 1',
                  onSelected: () {},
                ),
                AwesomeContextMenuItem(
                  label: 'Outer Menu Item 2',
                  onSelected: () {},
                ),
              ],
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue.withOpacity(0.1),
                child: Center(
                  child: AwesomeContextMenuArea(
                    menuItems: [
                      AwesomeContextMenuItem(
                        label: 'Inner Menu Item 1',
                        onSelected: () {},
                      ),
                      AwesomeContextMenuItem(
                        label: 'Inner Menu Item 2',
                        onSelected: () {},
                      ),
                    ],
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.green.withOpacity(0.1),
                      child: const Text('Inner Area'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify the widgets are rendered
      expect(find.text('Inner Area'), findsOneWidget);

      // Simulate a right-click on the inner area
      await tester.tap(find.text('Inner Area'), buttons: kSecondaryMouseButton);
      await tester.pump();

      // Verify that only one context menu is shown
      // The inner menu should take priority and be the only one visible
      expect(AwesomeContextMenu.isVisible(), isTrue);

      // Verify the menu contains the inner menu items
      expect(find.text('Inner Menu Item 1'), findsOneWidget);
      expect(find.text('Inner Menu Item 2'), findsOneWidget);
      
      // Verify the outer menu items are NOT shown
      expect(find.text('Outer Menu Item 1'), findsNothing);
      expect(find.text('Outer Menu Item 2'), findsNothing);

      // Hide the menu
      AwesomeContextMenu.hide();
      await tester.pump();

      // Verify menu is hidden
      expect(AwesomeContextMenu.isVisible(), isFalse);
    });

    testWidgets('Nested context menus with TextField should work correctly', (WidgetTester tester) async {
      // Build a widget with nested context menus including a TextField
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AwesomeContextMenuArea(
              menuItems: [
                AwesomeContextMenuItem(
                  label: 'Container Menu',
                  onSelected: () {},
                ),
              ],
              child: Container(
                width: 300,
                height: 200,
                color: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AwesomeContextMenuArea(
                    menuItems: [
                      AwesomeContextMenuItem(
                        label: 'Cut',
                        onSelected: () {},
                      ),
                      AwesomeContextMenuItem(
                        label: 'Copy',
                        onSelected: () {},
                      ),
                      AwesomeContextMenuItem(
                        label: 'Paste',
                        onSelected: () {},
                      ),
                    ],
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify the TextField is rendered
      expect(find.byType(TextField), findsOneWidget);

      // Simulate a right-click on the TextField
      await tester.tap(find.byType(TextField), buttons: kSecondaryMouseButton);
      await tester.pump();

      // Verify that only one context menu is shown
      expect(AwesomeContextMenu.isVisible(), isTrue);

      // Verify the menu contains the text field menu items
      expect(find.text('Cut'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);
      
      // Verify the container menu items are NOT shown
      expect(find.text('Container Menu'), findsNothing);

      // Hide the menu
      AwesomeContextMenu.hide();
      await tester.pump();

      // Verify menu is hidden
      expect(AwesomeContextMenu.isVisible(), isFalse);
    });

    testWidgets('SuperRightClickDetector should handle right-clicks correctly', (WidgetTester tester) async {
      bool rightClickCalled = false;
      bool tapCalled = false;
      Offset? rightClickPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuperRightClickDetector(
              onRightClick: (position) {
                rightClickCalled = true;
                rightClickPosition = position;
              },
              onTap: () {
                tapCalled = true;
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Test right-click
      await tester.tap(find.text('Test'), buttons: kSecondaryMouseButton);
      await tester.pump();

      expect(rightClickCalled, isTrue);
      expect(rightClickPosition, isNotNull);
      expect(tapCalled, isFalse);

      // Reset
      rightClickCalled = false;
      rightClickPosition = null;

      // Test left-click
      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(tapCalled, isTrue);
      expect(rightClickCalled, isFalse);
    });
  });
} 
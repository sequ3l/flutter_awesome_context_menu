import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import all example widgets
import 'examples/example_1.dart';
import 'examples/example_2.dart';
import 'examples/example_3.dart';
import 'examples/example_4.dart';
import 'examples/example_5.dart';
import 'examples/example_6.dart';
import 'examples/example_7.dart';
import 'examples/example_8.dart';
import 'examples/example_9.dart';
import 'examples/example_10.dart';
import 'examples/example_11.dart'; // Import the new nested context menus example
import 'examples/example_12.dart'; // New hierarchical context menus example
import 'examples/example_13.dart'; // Import menu item caching example
import 'examples/example_14.dart'; // Import custom animations example
import 'examples/example_15.dart'; // Import form menu example
import 'examples/example_16.dart'; // Import positioning example
import 'examples/example_17.dart'; // Import platform adaptive example
import 'examples/example_18.dart'; // Import theme-aware example
import 'examples/example_19.dart'; // Import programmatic menu example
import 'examples/example_20.dart'; // Import keyboard shortcuts example
import 'examples/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Awesome Context Menu Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D5FEF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Awesome Context Menu Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lastAction = "No action yet";

  void _updateLastAction(String action) {
    setState(() {
      _lastAction = action;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.05),
              colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Right-click on any of the examples below:',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),

                  // Responsive grid layout for examples
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate number of columns based on available width
                      final double maxWidth = constraints.maxWidth;
                      int crossAxisCount;

                      if (maxWidth >= 1000) {
                        crossAxisCount = 3; // 3 columns on large screens
                      } else if (maxWidth >= 700) {
                        crossAxisCount = 2; // 2 columns on medium screens
                      } else {
                        crossAxisCount = 1; // 1 column on small screens
                      }

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: crossAxisCount == 1
                            ? 3.5
                            : 2.2, // Reduced aspect ratio for more height
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          // Example 1: Default Menu
                          Example1DefaultMenu(updateAction: _updateLastAction),

                          // Example 2: Custom Menu
                          Example2CustomMenu(updateAction: _updateLastAction),

                          // Example 3: Combined Menu
                          Example3CombinedMenu(updateAction: _updateLastAction),

                          // Example 4: Dynamic Menu
                          Example4DynamicMenu(updateAction: _updateLastAction),

                          // Example 5: CTRL+Click
                          Example5CtrlClick(updateAction: _updateLastAction),

                          // Example 6: Grouping
                          Example6Grouping(updateAction: _updateLastAction),

                          // Example 7: Normal Click
                          Example7NormalClick(updateAction: _updateLastAction),

                          // Example 8: Hover Effects
                          Example8HoverEffects(updateAction: _updateLastAction),

                          // Example 9: Persistent Menu
                          Example9PersistentMenu(
                              updateAction: _updateLastAction),

                          // Example 10: Multi-Selection Menu
                          Example10MultiSelectMenu(
                              updateAction: _updateLastAction),

                          // Example 13: Menu Item Caching
                          Example13MenuItemCache(
                              updateAction: _updateLastAction),

                          // Example 17: Platform Adaptive Menu
                          Example17PlatformAdaptive(
                              updateAction: _updateLastAction),

                          // Example 18: Theme-Aware Menu
                          Example18ThemeAware(updateAction: _updateLastAction),

                          // Example 19: Programmatic Menu
                          Example19ProgrammaticMenu(
                              updateAction: _updateLastAction),

                          // Example 20: Keyboard Shortcuts
                          Example20KeyboardShortcuts(
                              updateAction: _updateLastAction),
                        ],
                      );
                    },
                  ),

                  // Special dedicated section for Example 11 (Nested Menus)
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Example: Nested Context Menus',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This example demonstrates how context menus can be nested within each other for complex UI interactions',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Use the simplified Example11NestedContextMenus widget
                        Example11NestedContextMenus(
                            updateAction: _updateLastAction),

                        const SizedBox(height: 16),
                        // Helper explanation text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: Colors.amber.shade800),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Nested context menus allow you to create hierarchical right-click menus. '
                                  'The inner menu takes precedence when right-clicking on it, while '
                                  'the outer menu is shown when right-clicking elsewhere.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Special dedicated section for Example 12 (Hierarchical Menus)
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Example: Hierarchical Context Menus',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple.shade700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This example demonstrates submenus within context menus, creating multi-level navigation',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Wrap in a SizedBox with explicit height to avoid layout issues
                        SizedBox(
                          width: double.infinity,
                          // Providing adequate height for the Example12
                          height: 220,
                          child: Example12HierarchicalMenu(
                              updateAction: _updateLastAction),
                        ),

                        const SizedBox(height: 16),
                        // Helper explanation text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.menu_open,
                                  color: Colors.purple.shade800),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Submenus can be revealed through different interaction methods: '
                                  'hover (desktop), click, or long-press (mobile). Each mode can be '
                                  'specifically set or automatically determined based on the platform.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Special section for Example 14 (Custom Animations)
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Example: Custom Animation Settings',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple.shade700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This example shows how to customize the animation duration of context menus',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add the custom animations example in a SizedBox with a fixed height
                        SizedBox(
                          width: double.infinity,
                          height: 200, // Increased height from 150px to 200px
                          child: Example14CustomAnimations(
                              updateAction: _updateLastAction),
                        ),

                        const SizedBox(height: 16),
                        // Helper explanation text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.deepPurple.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.animation,
                                  color: Colors.deepPurple.shade800),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Adjust the animation duration to control how quickly context menus appear and disappear. '
                                  'Changes apply to all menus in the application.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Special section for Example 15 (Form Menu)
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Example: Interactive Forms in Menu',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This example demonstrates how to create interactive forms within context menus',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add the form menu example in a SizedBox with fixed height
                        SizedBox(
                          width: double.infinity,
                          height: 180, // Increased height from 120px to 180px
                          child: Example15FormMenu(
                              updateAction: _updateLastAction),
                        ),

                        const SizedBox(height: 16),
                        // Helper explanation text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit_note,
                                  color: Colors.blue.shade800),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Create rich, interactive context menus with form elements like sliders, '
                                  'text fields, checkboxes, and more using the customMenuBuilder property.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Special section for Example 16 (Menu Positioning)
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced Example: Menu Positioning',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This example shows how to control where context menus appear relative to the target widget',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Add the menu positioning example in a SizedBox with fixed height
                        SizedBox(
                          width: double.infinity,
                          height: 300, // Increased height from 240px to 300px
                          child: Example16MenuPositioning(
                              updateAction: _updateLastAction),
                        ),

                        const SizedBox(height: 16),
                        // Helper explanation text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.place, color: Colors.red.shade800),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Use the customPositionCallback property to precisely control where menus appear. '
                                  'This is useful for creating custom UI patterns or avoiding screen edges.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  buildActionFeedback(context, _lastAction),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// filepath: c:\dev\flutter_awesome_context_menu\example\lib\examples\example_11.dart
import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example11NestedContextMenus extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example11NestedContextMenus({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example11NestedContextMenus> createState() =>
      _Example11NestedContextMenusState();
}

class _Example11NestedContextMenusState
    extends State<Example11NestedContextMenus> {
  // State variables to track which menu was last activated
  String _lastActivatedMenu = "None";
  Color _parentAreaColor = Colors.blue.withOpacity(0.1);
  Color _childAreaColor = Colors.green.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    // Simple direct implementation without using buildExampleCard
    return Container(
      width: double.infinity, // Added explicit width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
        children: [
          // Parent context menu covers the entire area
          AwesomeContextMenuArea(
            onRightClick: (position) {
              setState(() {
                _lastActivatedMenu = "Parent Menu";
                _parentAreaColor = Colors.blue.withOpacity(0.3);
                _childAreaColor = Colors.green.withOpacity(0.1);
              });
              widget.updateAction("Opened parent context menu");
            },
            menuItems: [
              AwesomeContextMenuItem(
                label: 'Parent Menu Action 1',
                icon: Icons.house,
                onSelected: () {
                  widget.updateAction("Parent menu action 1 selected");
                },
              ),
              AwesomeContextMenuItem(
                label: 'Parent Menu Action 2',
                icon: Icons.settings,
                onSelected: () {
                  widget.updateAction("Parent menu action 2 selected");
                },
              ),
            ],
            child: Container(
              constraints: const BoxConstraints(
                  minHeight: 180,
                  maxHeight: 220), // Use constraints instead of fixed height
              padding:
                  const EdgeInsets.all(12), // Reduced padding to save space
              decoration: BoxDecoration(
                color: _parentAreaColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Parent Context Menu Area',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  Text(
                    'Right-click anywhere in this blue area to see the parent menu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                  const SizedBox(height: 16), // Reduced spacing

                  // Child context menu area embedded inside the parent
                  Center(
                    child: AwesomeContextMenuArea(
                      onRightClick: (position) {
                        setState(() {
                          _lastActivatedMenu = "Child Menu";
                          _childAreaColor = Colors.green.withOpacity(0.3);
                          _parentAreaColor = Colors.blue.withOpacity(0.1);
                        });
                        widget.updateAction("Opened child context menu");
                      },
                      menuItems: [
                        AwesomeContextMenuItem(
                          label: 'Child Menu Action 1',
                          icon: Icons.child_care,
                          onSelected: () {
                            widget.updateAction("Child menu action 1 selected");
                          },
                        ),
                        AwesomeContextMenuItem(
                          label: 'Child Menu Action 2',
                          icon: Icons.child_friendly,
                          onSelected: () {
                            widget.updateAction("Child menu action 2 selected");
                          },
                        ),
                        AwesomeContextMenuItem.separator(),
                        AwesomeContextMenuItem(
                          label: 'Child Menu Action 3',
                          icon: Icons.escalator_warning,
                          onSelected: () {
                            widget.updateAction("Child menu action 3 selected");
                          },
                        ),
                      ],
                      backgroundColor: Colors.lightGreen.shade100,
                      child: Container(
                        width: 200,
                        height: 70, // Fixed height
                        decoration: BoxDecoration(
                          color: _childAreaColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade500),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Child Context Menu',
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12, // Reduced font size
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4), // Reduced spacing
                              Text(
                                'Right-click here for child menu',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced spacing
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade200,
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.shade300,
                          Colors.black.withOpacity(0.1)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Last activated: $_lastActivatedMenu',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11, // Reduced font size
                            color: _lastActivatedMenu == "Child Menu"
                                ? Colors.green.shade800
                                : Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

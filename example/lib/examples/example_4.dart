import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example4DynamicMenu extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example4DynamicMenu({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return buildExampleCard(
      title: 'Example 4: Dynamic Menu',
      description: 'Right-click for time-based menu:',
      content: AwesomeContextMenuArea(
        menuItemBuilder: (context) {
          return [
            AwesomeContextMenuItem(
              label: 'Generated at ${DateTime.now().toString().substring(11, 19)}',
              icon: Icons.access_time,
              onSelected: () => updateAction('Time item selected'),
            ),
            AwesomeContextMenuItem(
              label: 'Width: ${MediaQuery.of(context).size.width.toStringAsFixed(0)}px',
              icon: Icons.aspect_ratio,
              onSelected: () => updateAction('Screen size item selected'),
            ),
          ];
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.6),
                primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Dynamic menu items',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

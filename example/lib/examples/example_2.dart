import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example2CustomMenu extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example2CustomMenu({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return buildExampleCard(
      title: 'Example 2: Custom Menu',
      description: 'Right-click for custom menu items:',
      content: AwesomeContextMenuArea(
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Custom action 1',
            icon: Icons.star,
            onSelected: () => updateAction('Custom action 1 selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Custom action 2',
            icon: Icons.favorite,
            onSelected: () => updateAction('Custom action 2 selected'),
          ),
          AwesomeContextMenuItem.separator(),
          const AwesomeContextMenuItem(
            label: 'Disabled action',
            icon: Icons.block,
            enabled: false,
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.7),
                primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Right-click for custom menu',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

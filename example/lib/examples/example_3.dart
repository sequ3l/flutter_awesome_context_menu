import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example3CombinedMenu extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example3CombinedMenu({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return buildExampleCard(
      title: 'Example 3: Combined Menu',
      description: 'Link menu with custom items:',
      content: AwesomeContextMenuArea(
        link: 'https://github.com/flutter/flutter',
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Star Repository',
            icon: Icons.star,
            onSelected: () => updateAction('Star Repository selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Fork Repository',
            icon: Icons.fork_right,
            onSelected: () => updateAction('Fork Repository selected'),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  'https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png',
                  height: 22, // Further reduced size
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              Text(
                'Flutter GitHub',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12, // Smaller font
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

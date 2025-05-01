import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example5CtrlClick extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example5CtrlClick({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 5: CTRL+Click',
      description: 'Try CTRL/CMD+Click to open in a new tab:',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Try CTRL+Click:',
            style: GoogleFonts.montserrat(),
          ),
          const SizedBox(height: 8),
          AwesomeContextMenuArea(
            link: 'https://dart.dev',
            onCtrlClick: () => updateAction('CTRL+Click detected on Dart link'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0175C2),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0175C2).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Dart Website',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'macOS: use CMD+Click',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

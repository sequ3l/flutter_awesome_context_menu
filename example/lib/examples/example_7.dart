import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example7NormalClick extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example7NormalClick({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example7NormalClick> createState() => _Example7NormalClickState();
}

class _Example7NormalClickState extends State<Example7NormalClick> {
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 7: Click Handler',
      description: 'Click and right-click support:',
      content: AwesomeContextMenuArea(
        onClick: () {
          setState(() {
            _clickCount++;
          });
          widget.updateAction('Normal click detected - count: $_clickCount');
        },
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Reset counter',
            icon: Icons.refresh,
            onSelected: () {
              setState(() {
                _clickCount = 0;
              });
              widget.updateAction('Counter reset to 0');
            },
          ),
        ],
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.touch_app,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Clicks: $_clickCount',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

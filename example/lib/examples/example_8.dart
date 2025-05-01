import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example8HoverEffects extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example8HoverEffects({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example8HoverEffects> createState() => _Example8HoverEffectsState();
}

class _Example8HoverEffectsState extends State<Example8HoverEffects> {
  Color _hoverColor = Colors.transparent;
  double _hoverScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 8: Hover Effects',
      description: 'Mouse hover events:',
      content: AwesomeContextMenuArea(
        onMouseEnter: (_) {
          setState(() {
            _hoverColor = Colors.deepOrange;
            _hoverScale = 1.05;
          });
          widget.updateAction('Mouse entered hover area');
        },
        onMouseExit: (_) {
          setState(() {
            _hoverColor = Colors.teal;
            _hoverScale = 1.0;
          });
          widget.updateAction('Mouse exited hover area');
        },
        onMouseHover: (event) {
          // Could use position for additional effects
        },
        onClick: () => widget.updateAction('Clicked on hover example'),
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Hover example menu item',
            icon: Icons.mouse,
            onSelected: () => widget.updateAction('Hover example menu selected'),
          ),
        ],
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_hoverScale),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _hoverColor == Colors.transparent ? Colors.teal : _hoverColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: (_hoverColor == Colors.transparent ? Colors.teal : _hoverColor).withOpacity(0.3),
                blurRadius: _hoverScale * 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mouse_outlined,
                color: Colors.white,
                size: 16 * _hoverScale,
              ),
              SizedBox(width: 8 * _hoverScale),
              Text(
                'Hover me',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14 * _hoverScale,
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

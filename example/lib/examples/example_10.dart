import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example10MultiSelectMenu extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example10MultiSelectMenu({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example10MultiSelectMenu> createState() => _Example10MultiSelectMenuState();
}

class _Example10MultiSelectMenuState extends State<Example10MultiSelectMenu> {
  // Track selected options
  final Map<String, bool> _selections = {
    'Option 1': false,
    'Option 2': false,
    'Option 3': false,
    'Option 4': false,
  };

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 10: Multi-Select',
      description: 'Toggle items with persistent menu:',
      content: AwesomeContextMenuArea(
        menuItemBuilder: (context) {
          return _buildMenuItems();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduced padding
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF00796B),
                Color(0xFF009688),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00796B).withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.checklist,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Multi-Select Menu',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '${_selections.values.where((isSelected) => isSelected).length} option(s) selected',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AwesomeContextMenuItem> _buildMenuItems() {
    final List<AwesomeContextMenuItem> items = [];

    // Add all checkable options
    _selections.forEach((option, isSelected) {
      items.add(
        AwesomeContextMenuItem(
          label: option,
          icon: isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          onSelected: () {
            setState(() {
              _selections[option] = !isSelected;
            });

            // Update the menu items to reflect the changes immediately
            AwesomeContextMenu.updateItems(_buildMenuItems());

            // Notify of change
            widget.updateAction('Toggled $option: ${!isSelected ? 'checked' : 'unchecked'}');
          },
          dismissMenuOnSelect: false, // Keep menu open when toggling options
        ),
      );
    });

    // Add separator
    items.add(AwesomeContextMenuItem.separator());

    // Add an "Apply" action that will close the menu
    items.add(
      AwesomeContextMenuItem(
        label: 'Apply Selections',
        icon: Icons.done_all,
        onSelected: _applySelections,
        // Uses default dismissMenuOnSelect: true to close menu
      ),
    );

    return items;
  }

  void _applySelections() {
    final selectedOptions = _selections.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
    final selectedText = selectedOptions.isEmpty ? 'No options selected' : 'Selected: ${selectedOptions.join(', ')}';
    widget.updateAction(selectedText);
  }
}

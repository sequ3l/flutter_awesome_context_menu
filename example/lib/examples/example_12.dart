// filepath: c:\dev\flutter_awesome_context_menu\example\lib\examples\example_12.dart
import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example12HierarchicalMenu extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example12HierarchicalMenu({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 12: Hierarchical Menus',
      description: 'Context menus with nested submenus:',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AwesomeContextMenuArea(
            menuItems: [
              AwesomeContextMenuItem(
                label: 'File',
                icon: Icons.folder,
                children: [
                  // Submenu items
                  AwesomeContextMenuItem(
                    label: 'New',
                    icon: Icons.add,
                    children: [
                      // Second level submenu
                      AwesomeContextMenuItem(
                        label: 'Document',
                        icon: Icons.description,
                        onSelected: () => updateAction('New Document selected'),
                      ),
                      AwesomeContextMenuItem(
                        label: 'Spreadsheet',
                        icon: Icons.grid_on,
                        onSelected: () =>
                            updateAction('New Spreadsheet selected'),
                      ),
                      AwesomeContextMenuItem(
                        label: 'Presentation',
                        icon: Icons.slideshow,
                        onSelected: () =>
                            updateAction('New Presentation selected'),
                      ),
                    ],
                  ),
                  AwesomeContextMenuItem(
                    label: 'Open',
                    icon: Icons.folder_open,
                    onSelected: () => updateAction('Open selected'),
                  ),
                  AwesomeContextMenuItem.separator(),
                  AwesomeContextMenuItem(
                    label: 'Save',
                    icon: Icons.save,
                    onSelected: () => updateAction('Save selected'),
                  ),
                  AwesomeContextMenuItem(
                    label: 'Save As...',
                    icon: Icons.save_as,
                    onSelected: () => updateAction('Save As selected'),
                  ),
                ],
              ),
              AwesomeContextMenuItem(
                label: 'Edit',
                icon: Icons.edit,
                children: [
                  AwesomeContextMenuItem(
                    label: 'Cut',
                    icon: Icons.content_cut,
                    onSelected: () => updateAction('Cut selected'),
                  ),
                  AwesomeContextMenuItem(
                    label: 'Copy',
                    icon: Icons.content_copy,
                    onSelected: () => updateAction('Copy selected'),
                  ),
                  AwesomeContextMenuItem(
                    label: 'Paste',
                    icon: Icons.content_paste,
                    onSelected: () => updateAction('Paste selected'),
                  ),
                ],
              ),
              AwesomeContextMenuItem(
                label: 'View',
                icon: Icons.visibility,
                children: [
                  AwesomeContextMenuItem(
                    label: 'Zoom',
                    icon: Icons.zoom_in,
                    children: [
                      AwesomeContextMenuItem(
                        label: 'Zoom In',
                        onSelected: () => updateAction('Zoom In selected'),
                      ),
                      AwesomeContextMenuItem(
                        label: 'Zoom Out',
                        onSelected: () => updateAction('Zoom Out selected'),
                      ),
                      AwesomeContextMenuItem(
                        label: 'Reset Zoom',
                        onSelected: () => updateAction('Reset Zoom selected'),
                      ),
                    ],
                  ),
                  AwesomeContextMenuItem(
                    label: 'Full Screen',
                    icon: Icons.fullscreen,
                    onSelected: () => updateAction('Full Screen selected'),
                  ),
                ],
              ),
            ],
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6A1B9A),
                    Color(0xFF9C27B0),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A1B9A).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_open,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Standard Application Menu',
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
          const SizedBox(height: 20),

          // Changed from Row to Wrap for better layout flexibility
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildInteractionModeExample(
                label: 'Hover Mode',
                color: Colors.blue.shade700,
                mode: SubMenuInteractionMode.hover,
                updateAction: updateAction,
              ),
              _buildInteractionModeExample(
                label: 'Click Mode',
                color: Colors.green.shade700,
                mode: SubMenuInteractionMode.click,
                updateAction: updateAction,
              ),
              _buildInteractionModeExample(
                label: 'Long Press',
                color: Colors.orange.shade700,
                mode: SubMenuInteractionMode.longPress,
                updateAction: updateAction,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              'Menus use platform defaults (hover on desktop, click on mobile)',
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

  // Helper method to build each interaction mode example button
  Widget _buildInteractionModeExample({
    required String label,
    required Color color,
    required SubMenuInteractionMode mode,
    required UpdateActionCallback updateAction,
  }) {
    return AwesomeContextMenuArea(
      menuItems: [
        AwesomeContextMenuItem(
          label: '$label Submenu',
          icon: mode == SubMenuInteractionMode.hover
              ? Icons.mouse
              : Icons.touch_app,
          subMenuInteractionMode: mode,
          children: [
            AwesomeContextMenuItem(
              label: 'Item 1',
              onSelected: () => updateAction('$label submenu: Item 1'),
            ),
            AwesomeContextMenuItem(
              label: 'Item 2',
              onSelected: () => updateAction('$label submenu: Item 2'),
            ),
          ],
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example13MenuItemCache extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example13MenuItemCache({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 13: Menu Item Caching',
      description: 'Optimizing performance with cached items:',
      content: AwesomeContextMenuArea(
        menuItemBuilder: (context) {
          // Demonstrate fetching cached menu items instead of recreating them
          return [
            AwesomeContextMenuItem.getCachedItem(
              'edit', // Cache key
              () => AwesomeContextMenuItem(
                label: 'Edit',
                icon: Icons.edit,
                onSelected: () => updateAction('Used cached Edit menu item'),
              ),
            ),
            AwesomeContextMenuItem.getCachedItem(
              'delete', // Cache key
              () => AwesomeContextMenuItem(
                label: 'Delete',
                icon: Icons.delete,
                onSelected: () => updateAction('Used cached Delete menu item'),
              ),
            ),
            AwesomeContextMenuItem.separator(),
            AwesomeContextMenuItem(
              label: 'Clear cache',
              icon: Icons.cleaning_services,
              onSelected: () {
                AwesomeContextMenu.cleanupCache();
                updateAction('Menu item cache cleared');
              },
            ),
          ];
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.memory, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'Cached Menu Items',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example18ThemeAware extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example18ThemeAware({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return buildExampleCard(
      title: 'Example 18: Theme-Aware Menu',
      description: 'Menu styling adapts to current theme:',
      content: AwesomeContextMenuArea(
        backgroundColor: isDark ? theme.colorScheme.surfaceVariant : null,
        textColor: isDark ? theme.colorScheme.onSurfaceVariant : null,
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Current theme: ${isDark ? "Dark" : "Light"}',
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            enabled: false,
          ),
          AwesomeContextMenuItem.separator(),
          AwesomeContextMenuItem(
            label: 'Action 1',
            icon: Icons.star,
            onSelected: () => updateAction('Action 1 selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Action 2',
            icon: Icons.bookmark,
            onSelected: () => updateAction('Action 2 selected'),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: theme.colorScheme.onPrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Theme-aware menu',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
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

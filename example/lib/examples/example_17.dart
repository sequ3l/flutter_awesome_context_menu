import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example17PlatformAdaptive extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example17PlatformAdaptive({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AwesomePlatformUtils.isMobile();
    final String platform = AwesomePlatformUtils.getCurrentPlatform();
    final SubMenuInteractionMode defaultMode =
        AwesomeContextMenu.getPlatformDefaultInteractionMode();

    return buildExampleCard(
      title: 'Example 17: Platform Adaptive',
      description: 'Menu adapts to current platform:',
      content: AwesomeContextMenuArea(
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Platform: $platform',
            icon: _getPlatformIcon(),
            enabled: false,
          ),
          AwesomeContextMenuItem.separator(),
          AwesomeContextMenuItem(
            label: isMobile ? 'Mobile Action' : 'Desktop Action',
            icon: isMobile ? Icons.smartphone : Icons.desktop_windows,
            onSelected: () => updateAction(
                '${isMobile ? "Mobile" : "Desktop"} action selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Platform Submenu',
            icon: Icons.devices_other,
            subMenuInteractionMode: defaultMode, // Use platform default
            children: [
              AwesomeContextMenuItem(
                label: 'Submenu using $defaultMode mode',
                onSelected: () =>
                    updateAction('Platform submenu item selected'),
              ),
            ],
          ),
        ],
        shortcutLabel: isMobile ? 'Long press' : 'Right-click',
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.indigoAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getPlatformIcon(), color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Platform: $platform',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPlatformIcon() {
    final platform = AwesomePlatformUtils.getCurrentPlatform();
    switch (platform) {
      case 'windows':
        return Icons.desktop_windows;
      case 'macos':
        return Icons.apple;
      case 'linux':
        return Icons.laptop_chromebook;
      case 'web':
        return Icons.web;
      case 'android':
        return Icons.android;
      case 'ios':
        return Icons.phone_iphone;
      default:
        return Icons.device_unknown;
    }
  }
}

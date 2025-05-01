import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example15FormMenu extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example15FormMenu({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example15FormMenu> createState() => _Example15FormMenuState();
}

class _Example15FormMenuState extends State<Example15FormMenu> {
  double _opacity = 1.0;
  String _input = '';

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 15: Form Elements',
      description: 'Interactive inputs in context menu:',
      content: SizedBox(
        width: double.infinity,
        height: 60, // Fixed height to prevent layout issues
        child: AwesomeContextMenuArea(
          useCustomBuilder: true, // Use custom builder for complex menu
          customMenuBuilder: (context, closeMenu) {
            return _CustomFormMenu(
              initialOpacity: _opacity,
              onOpacityChanged: (value) {
                setState(() {
                  _opacity = value;
                });
              },
              onInputChanged: (value) {
                _input = value;
              },
              onSave: () {
                widget.updateAction('Saved: $_input, Opacity: ${(_opacity * 100).round()}%');
                closeMenu();
              },
              onCancel: closeMenu,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(_opacity),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Form Menu',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted into a separate StatefulWidget to properly handle internal state changes
class _CustomFormMenu extends StatefulWidget {
  final double initialOpacity;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _CustomFormMenu({
    required this.initialOpacity,
    required this.onOpacityChanged,
    required this.onInputChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_CustomFormMenu> createState() => _CustomFormMenuState();
}

class _CustomFormMenuState extends State<_CustomFormMenu> {
  late double _menuOpacity;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _menuOpacity = widget.initialOpacity;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Opacity', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _menuOpacity,
            onChanged: (value) {
              // Update local state for immediate UI feedback
              setState(() {
                _menuOpacity = value;
              });
              // Also update parent widget's state
              widget.onOpacityChanged(value);
            },
          ),
          const Text('Quick Note', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _textController,
            onChanged: widget.onInputChanged,
            decoration: const InputDecoration(
              hintText: 'Enter text...',
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: widget.onSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example17NestedContextMenus extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example17NestedContextMenus({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example17NestedContextMenus> createState() => _Example17NestedContextMenusState();
}

class _Example17NestedContextMenusState extends State<Example17NestedContextMenus> {
  final TextEditingController _textController = TextEditingController();
  String _clipboardContent = '';

  @override
  void initState() {
    super.initState();
    _textController.text = 'This is sample text in a text field';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _getClipboardContent() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      setState(() {
        _clipboardContent = clipboardData?.text ?? 'No text in clipboard';
      });
    } catch (e) {
      setState(() {
        _clipboardContent = 'Failed to get clipboard content';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 17: Nested Context Menus',
      description: 'Demonstrates proper handling of nested context menus. The outer container has its own context menu, while the text field has a text-specific context menu. Notice how only the appropriate menu appears when right-clicking in different areas.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outer container with context menu
          AwesomeContextMenuArea(
            menuItems: [
              AwesomeContextMenuItem(
                label: 'Container Menu',
                icon: Icons.dashboard,
                enabled: false,
              ),
              AwesomeContextMenuItem.separator(),
              AwesomeContextMenuItem(
                label: 'Container Action',
                icon: Icons.widgets,
                onSelected: () => widget.updateAction('Container action selected'),
              ),
              AwesomeContextMenuItem(
                label: 'Container Settings',
                icon: Icons.settings,
                onSelected: () => widget.updateAction('Container settings selected'),
              ),
            ],
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Container with Context Menu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Right-click here to see the container menu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Nested text field with its own context menu
                  AwesomeContextMenuArea(
                    menuItems: [
                      AwesomeContextMenuItem(
                        label: 'Text Field Menu',
                        icon: Icons.text_fields,
                        enabled: false,
                      ),
                      AwesomeContextMenuItem.separator(),
                      AwesomeContextMenuItem(
                        label: 'Cut Text',
                        icon: Icons.cut,
                        shortcut: 'Ctrl+X',
                        onSelected: () {
                          final selectedText = _textController.selection.textInside(_textController.text);
                          if (selectedText.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: selectedText));
                            // Remove selected text
                            final selection = _textController.selection;
                            final newText = _textController.text.replaceRange(
                              selection.start,
                              selection.end,
                              '',
                            );
                            _textController.text = newText;
                            _textController.selection = TextSelection.collapsed(offset: selection.start);
                            widget.updateAction('Text cut to clipboard');
                          } else {
                            widget.updateAction('No text selected to cut');
                          }
                        },
                      ),
                      AwesomeContextMenuItem(
                        label: 'Copy Text',
                        icon: Icons.copy,
                        shortcut: 'Ctrl+C',
                        onSelected: () {
                          final selectedText = _textController.selection.textInside(_textController.text);
                          if (selectedText.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: selectedText));
                            widget.updateAction('Text copied to clipboard');
                          } else {
                            widget.updateAction('No text selected to copy');
                          }
                        },
                      ),
                      AwesomeContextMenuItem(
                        label: 'Paste Text',
                        icon: Icons.paste,
                        shortcut: 'Ctrl+V',
                        onSelected: () async {
                          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                          if (clipboardData?.text != null) {
                            // Insert text at cursor position
                            final selection = _textController.selection;
                            final newText = _textController.text.replaceRange(
                              selection.start,
                              selection.end,
                              clipboardData!.text!,
                            );
                            final newOffset = selection.start + clipboardData.text!.length;
                            _textController.text = newText;
                            _textController.selection = TextSelection.collapsed(offset: newOffset);
                            widget.updateAction('Text pasted from clipboard');
                          } else {
                            widget.updateAction('No text in clipboard to paste');
                          }
                        },
                      ),
                      AwesomeContextMenuItem.separator(),
                      AwesomeContextMenuItem(
                        label: 'Select All',
                        icon: Icons.select_all,
                        shortcut: 'Ctrl+A',
                        onSelected: () {
                          _textController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _textController.text.length,
                          );
                          widget.updateAction('All text selected');
                        },
                      ),
                      AwesomeContextMenuItem(
                        label: 'Clear Text',
                        icon: Icons.clear,
                        onSelected: () {
                          _textController.clear();
                          widget.updateAction('Text field cleared');
                        },
                      ),
                    ],
                    child: TextField(
                      controller: _textController,
                      maxLines: 3,
                      // Disable Flutter's built-in context menu to prevent conflicts
                      contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
                      decoration: const InputDecoration(
                        labelText: 'Text Field with Context Menu',
                        hintText: 'Right-click on this text field to see text-specific options',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Information about the behavior
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.green, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Nested Context Menu Behavior:',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Right-click on the text field shows text-specific options\n'
                          '• Right-click outside the text field shows container options\n'
                          '• Only one context menu appears at a time (no interference)',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Additional demonstration with button
          Row(
            children: [
              ElevatedButton(
                onPressed: _getClipboardContent,
                child: const Text('Check Clipboard'),
              ),
              const SizedBox(width: 12),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Clipboard: $_clipboardContent',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

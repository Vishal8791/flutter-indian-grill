import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

class ResizableTextarea extends StatefulWidget {
  final TextEditingController controller;
  final double initialHeight;

  const ResizableTextarea({
    super.key,
    required this.controller,
    this.initialHeight = 120,
  });

  @override
  State<ResizableTextarea> createState() => _ResizableTextareaState();
}

class _ResizableTextareaState extends State<ResizableTextarea> {
  late final String viewId;

  @override
  void initState() {
    super.initState();

    viewId = 'textarea-${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      // Only runs on web
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
        final textarea = html.TextAreaElement()
          ..style.resize = 'both'
          ..style.width = '100%'
          ..style.height = '${widget.initialHeight}px'
          ..style.padding = '10px'
          ..style.border = '1px solid #999'
          ..style.borderRadius = '4px'
          ..style.fontSize = '14px'
          ..value = widget.controller.text;

        textarea.onInput.listen((_) {
          widget.controller.text = textarea.value ?? '';
        });

        return textarea;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      // Fallback for mobile/desktop
      return TextField(
        controller: widget.controller,
        maxLines: null,
        minLines: 5,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      );
    }

    return SizedBox(
      height: widget.initialHeight,
      child: HtmlElementView(viewType: viewId),
    );
  }
}

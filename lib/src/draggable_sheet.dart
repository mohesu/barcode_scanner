import 'package:flutter/material.dart';

/// A draggable sheet that can be used to show any widget
/// with a title and a drag handler.
///
class DraggableSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final bool hideDragHandler;
  final bool hideTitle;
  DraggableSheet({
    super.key,
    this.title = 'Scan any QR code',
    this.child = const SizedBox.shrink(),
    this.hideDragHandler = false,
    this.hideTitle = false,
  });
  final _controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            ...[
              if (!hideDragHandler)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const SizedBox(
                    width: 40,
                    height: 5,
                  ),
                ),
              if (!hideTitle) ...[
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(),
              ]
            ],
            Expanded(
              child: child,
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableText(this.text, {this.trimLines = 3, super.key});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  bool _checkTextOverflow(double maxWidth) {
    final span = TextSpan(text: widget.text);
    final postPainter = TextPainter(
      text: span,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    bool nextOverflowing = postPainter.didExceedMaxLines;

    return nextOverflowing;
  }

  void toggle(double maxWidth, bool value) {
    setState(() => _isExpanded = value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isOverflowing = _checkTextOverflow(maxWidth);
        if (_isExpanded || !isOverflowing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(text: widget.text, style: postTextStyle()),
              ),
              if (isOverflowing)
                GestureDetector(
                  onTap: () => toggle(maxWidth, false),
                  child: Text("접기", style: TextStyle(color: Colors.grey)),
                ),
            ],
          );
        } else {
          final span = TextSpan(text: widget.text);
          final tp = TextPainter(
            text: span,
            maxLines: widget.trimLines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: maxWidth);

          String displayText = widget.text;
          if (tp.didExceedMaxLines) {
            final endIndex =
                tp.getPositionForOffset(Offset(tp.width, tp.height)).offset;
            displayText = widget.text.substring(0, endIndex);
          }

          return RichText(
            text: TextSpan(
              text: displayText.trim(),
              style: postTextStyle(),
              children: [
                const TextSpan(text: '... '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () => toggle(maxWidth, true),
                    child: Text("더보기", style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  TextStyle postTextStyle() =>
      TextStyle(fontSize: 16, color: Colors.black, height: 1.5);
}

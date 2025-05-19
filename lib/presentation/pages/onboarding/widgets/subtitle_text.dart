import 'package:flutter/material.dart';

class TitleSubtitleText extends StatelessWidget {
  final String text;

  const TitleSubtitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.5,
      ),
    );
  }
}

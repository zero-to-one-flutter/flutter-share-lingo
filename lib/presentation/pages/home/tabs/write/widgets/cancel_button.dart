import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: const SizedBox(
        width: 61,
        height: 40,
        child: Center(
          child: Text(
            '취소',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4A4A4A),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

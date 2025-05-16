import 'package:flutter/material.dart';

class PostInputField extends StatelessWidget {
  const PostInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 369,
      height: 482,
      decoration: const BoxDecoration(color: Color(0xFFEDEDED)),
      child: const Center(
        child: Text(
          '텍스트 입력 필드',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

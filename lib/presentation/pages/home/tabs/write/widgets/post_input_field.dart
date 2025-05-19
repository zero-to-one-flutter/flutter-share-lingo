import 'package:flutter/material.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;

  const PostInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 482,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFEDEDED),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요...',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}

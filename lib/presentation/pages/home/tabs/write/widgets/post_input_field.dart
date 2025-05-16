import 'package:flutter/material.dart';

class PostInputField extends StatelessWidget {
  const PostInputField({super.key});

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
      child: const TextField(
        maxLines: null, // 여러 줄 입력 가능
        expands: true, // 남은 영역 모두 차지
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: '내용을 입력하세요...',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}

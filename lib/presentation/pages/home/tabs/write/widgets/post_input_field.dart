import 'package:flutter/material.dart';

import '../../../../../../app/constants/app_colors.dart';

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
        color: AppColors.chipGrey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 10,
        expands: false,
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
        validator: (value) {
          if (value == null || value.trim().isEmpty) return '내용을 입력하세요';
          if (value.trim().length < 2) return '1글자 이상 입력해 주세요';
          return null;
        },
      ),
    );
  }
}

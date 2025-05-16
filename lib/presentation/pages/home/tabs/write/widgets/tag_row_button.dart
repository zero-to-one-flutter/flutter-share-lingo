import 'package:flutter/material.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/tag_select/select_tag_page.dart';

class TagRowButton extends StatelessWidget {
  const TagRowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽: 태그 추가 버튼
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectTagPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFA9A9A9),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: const Text(
              '태그 추가',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        // 오른쪽: 카메라 버튼
        GestureDetector(
          onTap: () {
            // TODO: 사진 선택 기능
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF007AFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

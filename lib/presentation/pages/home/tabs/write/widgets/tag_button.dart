import 'package:flutter/material.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/tag_select/select_tag_page.dart';

class TagButton extends StatelessWidget {
  const TagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectTagPage()),
        );
      },
      child: Container(
        width: 104,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFA9A9A9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
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
    );
  }
}

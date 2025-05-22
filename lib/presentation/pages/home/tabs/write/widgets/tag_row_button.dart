import 'package:flutter/material.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/tag_select/select_tag_page.dart';

import '../../../../../../app/constants/app_colors.dart';

class TagRowButton extends StatelessWidget {
  final void Function(String tag) onTagSelected;
  final VoidCallback onPickImage;
  final VoidCallback onAddPoll;

  ///투표 버튼 콜백

  const TagRowButton({
    super.key,
    required this.onTagSelected,
    required this.onPickImage,
    required this.onAddPoll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽: 태그 추가 버튼
          GestureDetector(
            onTap: () async {
              //  추후 SelectTagPage에서 선택된 태그 받아올 수 있도록 설계
              final selectedTag = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => const SelectTagPage()),
              );

              //  선택된 태그가 있으면 콜백 실행
              if (selectedTag != null && selectedTag.isNotEmpty) {
                onTagSelected(selectedTag);
              }
            },
            child: Chip(
              label: const Text(
                '태그 추가',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              backgroundColor: AppColors.lightGrey,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: const StadiumBorder(),
              side: BorderSide.none,
              elevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          GestureDetector(
            onTap: onAddPoll,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.poll, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8), // 왼쪽 여백
          // 오른쪽: 카메라 버튼
          GestureDetector(
            onTap: () {
              onPickImage();
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
      ),
    );
  }
}

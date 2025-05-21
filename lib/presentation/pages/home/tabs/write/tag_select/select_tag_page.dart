import 'package:flutter/material.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/app/constants/app_constants.dart';

class SelectTagPage extends StatelessWidget {
  const SelectTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 X + 제목
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '태그 선택',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // 그냥 닫기
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),

            // 태그 리스트
            Expanded(
              child: ListView.separated(
                itemCount: AppConstants.tags.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, AppConstants.tags[index]); // 태그 리턴
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.widgetBackgroundBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#${AppConstants.tags[index]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

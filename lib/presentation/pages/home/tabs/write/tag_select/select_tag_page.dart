import 'package:flutter/material.dart';

class SelectTagPage extends StatelessWidget {
  const SelectTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      '#어떻게 고쳐야 하나요?',
      '#무슨 의미인가요?',
      '#자연스럽게 번역해 주세요',
      '#발음 피드백 주세요',
    ];

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
                    Navigator.pop(context); // 또는 PostWritePage 이동
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
                itemCount: tags.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tags[index],
                      style: const TextStyle(fontSize: 16),
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

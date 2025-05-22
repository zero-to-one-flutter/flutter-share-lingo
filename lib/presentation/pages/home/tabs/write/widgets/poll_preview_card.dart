import 'package:flutter/material.dart';

class PollPreviewCard extends StatelessWidget {
  final String question;
  final List<String> options;

  const PollPreviewCard({
    super.key,
    required this.question,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        border: Border.all(color: Colors.indigo.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 투표 미리보기',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(question, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 10),
          ...options.map(
            (option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.radio_button_unchecked, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(option)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

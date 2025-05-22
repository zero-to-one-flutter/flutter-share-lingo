import 'package:flutter/material.dart';

class PollInputDialog extends StatefulWidget {
  final void Function({
    required String question,
    required String option1,
    required String option2,
  })
  onConfirm;

  const PollInputDialog({super.key, required this.onConfirm});

  @override
  State<PollInputDialog> createState() => _PollInputDialogState();
}

class _PollInputDialogState extends State<PollInputDialog> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('투표 만들기'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _questionController,
            decoration: const InputDecoration(labelText: '질문'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _option1Controller,
            decoration: const InputDecoration(labelText: '선택지 1'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _option2Controller,
            decoration: const InputDecoration(labelText: '선택지 2'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // 닫기
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            final q = _questionController.text.trim();
            final o1 = _option1Controller.text.trim();
            final o2 = _option2Controller.text.trim();

            if (q.isNotEmpty && o1.isNotEmpty && o2.isNotEmpty) {
              widget.onConfirm(question: q, option1: o1, option2: o2);
              Navigator.of(context).pop(); // 다이얼로그 닫기
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}

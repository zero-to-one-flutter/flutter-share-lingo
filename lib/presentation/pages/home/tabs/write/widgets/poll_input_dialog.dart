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

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        '투표',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _questionController,
            decoration: _buildInputDecoration('질문을 입력하세요'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _option1Controller,
            decoration: _buildInputDecoration('선택지 1'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _option2Controller,
            decoration: _buildInputDecoration('선택지 2'),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final q = _questionController.text.trim();
            final o1 = _option1Controller.text.trim();
            final o2 = _option2Controller.text.trim();

            if (q.isNotEmpty && o1.isNotEmpty && o2.isNotEmpty) {
              widget.onConfirm(question: q, option1: o1, option2: o2);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('확인', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

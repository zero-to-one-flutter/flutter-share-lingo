import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/constants/app_colors.dart';

class PollInputDialog extends StatefulWidget {
  final void Function({
  required String question,
  required String option1,
  required String option2,
  }) onConfirm;

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

  Widget _buildTextField(TextEditingController controller, String placeholder) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      style: const TextStyle(fontSize: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        '투표',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_questionController, '질문을 입력하세요'),
                const SizedBox(height: 12),
                _buildTextField(_option1Controller, '선택지 1'),
                const SizedBox(height: 12),
                _buildTextField(_option2Controller, '선택지 2'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소', style: TextStyle(color: Colors.grey)),
        ),
        CupertinoDialogAction(
          onPressed: () {
            final q = _questionController.text.trim();
            final o1 = _option1Controller.text.trim();
            final o2 = _option2Controller.text.trim();

            if (q.isNotEmpty && o1.isNotEmpty && o2.isNotEmpty) {
              widget.onConfirm(question: q, option1: o1, option2: o2);
              Navigator.of(context).pop();
            }
          },
          isDefaultAction: true,
          child: Text(
            '확인',
            style: TextStyle(
              color: AppColors.buttonsBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:share_lingo/core/utils/snackbar_util.dart';
import 'cancel_button.dart';
import 'submit_button.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 393,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CancelButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SubmitButton(
              onPressed: () {
                // TODO: 게시 로직 작성
                SnackbarUtil.showSnackBar(context, '게시되었습니다');
              },
            ),
          ],
        ),
      ),
    );
  }
}

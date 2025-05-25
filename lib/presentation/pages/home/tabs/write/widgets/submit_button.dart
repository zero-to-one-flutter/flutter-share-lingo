import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';

class SubmitButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postWriteViewModelProvider);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 55,
        height: 33,
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child:
              state.isLoading
                  ? CupertinoActivityIndicator(color: Colors.white,)
                  : Text(
                    '게시',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
        ),
      ),
    );
  }
}

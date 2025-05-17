import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/utils/snackbar_util.dart';
import 'package:share_lingo/presentation/pages/home/home_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/cancel_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/post_input_field.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/submit_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/tag_row_button.dart';

class PostWriteTab extends ConsumerWidget {
  const PostWriteTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: CancelButton(
          onPressed: () {
            ref
                .read<HomeViewModel>(homeViewModelProvider.notifier)
                .onIndexChanged(0); //  홈으로 이동
          },
        ),
        actions: [
          SubmitButton(
            onPressed: () {
              SnackbarUtil.showSnackBar(context, '게시되었습니다');
              ref
                  .read<HomeViewModel>(homeViewModelProvider.notifier)
                  .onIndexChanged(0); //  게시 후 홈으로
            },
          ),
        ],
      ),
      body: Column(
        children: const [
          SizedBox(height: 20),
          PostInputField(),
          SizedBox(height: 16),
          TagRowButton(),
          Spacer(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'widgets/post_input_field.dart';
import 'widgets/tag_row_button.dart';
import 'widgets/bottom_bar.dart';

class PostWriteTab extends StatelessWidget {
  const PostWriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: const Text("글 작성")),
        SizedBox(height: 20),
        PostInputField(),
        SizedBox(height: 16),
        TagRowButton(),
        Spacer(),
        BottomBar(),
      ],
    );
  }
}

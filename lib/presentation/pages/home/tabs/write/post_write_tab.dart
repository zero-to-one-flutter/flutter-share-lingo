import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_lingo/core/utils/snackbar_util.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/cancel_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/post_input_field.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/submit_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/tag_row_button.dart';

class PostWriteTab extends ConsumerStatefulWidget {
  const PostWriteTab({super.key});

  @override
  ConsumerState<PostWriteTab> createState() => _PostWriteTabState();
}

class _PostWriteTabState extends ConsumerState<PostWriteTab> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTags = [];
  final List<Uint8List> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      SnackbarUtil.showSnackBar(context, '이미지는 최대 3장까지 가능합니다.');
      return;
    }
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImages.add(bytes);
      });
    }
  }

  Future<void> _submit() async {
    final scaffoldContext = context; // 🔐 context 안전하게 저장
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'test-user';
    final content = _contentController.text;
    final postNotifier = ref.read(postWriteViewModelProvider.notifier);

    await postNotifier.submitPost(
      uid: uid,
      content: content,
      tags: _selectedTags.map((tag) => tag.replaceAll('#', '')).toList(),
      imageBytesList: _selectedImages,
    );

    if (!mounted) return;

    await ref.read(feedNotifierProvider.notifier).refresh();

    _contentController.clear();
    _selectedImages.clear();
    _selectedTags.clear();
    setState(() {});

    SnackbarUtil.showSnackBar(scaffoldContext, '게시되었습니다');
    Navigator.of(scaffoldContext).pop();
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CancelButton(onPressed: _cancel),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SubmitButton(onPressed: _submit),
          ),
        ],
      ),

      body: SafeArea(
        child: LayoutBuilder(
          //반응형 대응
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 5,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PostInputField(controller: _contentController),
                      const SizedBox(height: 16),
                      if (_selectedImages.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Image.memory(
                                    _selectedImages[index],
                                    height: 100,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImages.removeAt(index);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      TagRowButton(
                        onTagSelected: (tag) {
                          if (!_selectedTags.contains(tag)) {
                            setState(() => _selectedTags.add(tag));
                          }
                        },
                        onPickImage: _pickImage,
                      ),
                      if (_selectedTags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                _selectedTags.map((tag) {
                                  return Chip(
                                    label: Text(tag),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedTags.remove(tag);
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

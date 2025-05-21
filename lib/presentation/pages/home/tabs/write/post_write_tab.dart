import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/core/providers/post_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/post/create_post_usecase.dart';
import 'package:share_lingo/domain/usecase/post/update_post_usecase.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostWriteTab extends ConsumerStatefulWidget {
  final PostEntity? post;

  const PostWriteTab({super.key, this.post});

  @override
  ConsumerState<PostWriteTab> createState() => _PostWriteTabState();
}

class _PostWriteTabState extends ConsumerState<PostWriteTab> {
  final _contentController = TextEditingController();
  final List<File> _selectedImages = [];
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _contentController.text = widget.post!.content;
      // TODO: Load existing images if any
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(userGlobalViewModelProvider);
      if (user == null) throw Exception('User not authenticated');

      if (widget.post != null) {
        // Update existing post
        final updatedPost = widget.post!.copyWith(
          content: _contentController.text,
          updatedAt: DateTime.now(),
        );

        // Update in Firestore
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post!.id)
            .update({
              'content': _contentController.text,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        // Invalidate the posts provider to trigger a refresh
        ref.invalidate(postsProvider);
      } else {
        // Create new post
        final post = PostEntity(
          id: '', // Will be set by Firestore
          uid: user.id,
          userName: user.name ?? 'Anonymous',
          userProfileImage: user.profileImage ?? '',
          userNativeLanguage: user.nativeLanguage ?? 'Unknown',
          userTargetLanguage: user.targetLanguage ?? 'Unknown',
          content: _contentController.text,
          imageUrl: [], // TODO: Handle image uploads
          tags: [], // TODO: Extract tags from content
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          likeCount: 0,
          commentCount: 0,
          deleted: false,
        );
        await ref.read(createPostUseCaseProvider).call(post);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.post != null ? '게시물이 수정되었습니다' : '게시물이 작성되었습니다',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post != null ? '게시물 수정' : '게시물 작성'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitPost,
            child:
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(
                      widget.post != null ? '수정' : '게시',
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: '무슨 생각을 하고 계신가요?',
                  border: InputBorder.none,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_selectedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_selectedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    color: AppColors.widgetBackgroundBlue,
                  ),
                  Text(
                    '이미지 추가',
                    style: TextStyle(
                      color: AppColors.widgetBackgroundBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

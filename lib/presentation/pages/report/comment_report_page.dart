import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

class CommentReportPage extends ConsumerStatefulWidget {
  final String postId;
  final String commentId;
  final String commentContent;

  const CommentReportPage({
    super.key,
    required this.postId,
    required this.commentId,
    required this.commentContent,
  });

  @override
  ConsumerState<CommentReportPage> createState() => _CommentReportPageState();
}

class _CommentReportPageState extends ConsumerState<CommentReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  String _selectedReason = '스팸';
  bool _isSubmitting = false;

  final List<String> _reportReasons = [
    '스팸',
    '부적절한 콘텐츠',
    '괴롭힘',
    '혐오 발언',
    '폭력',
    '기타',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(userGlobalViewModelProvider);
      if (user == null) throw Exception('User not authenticated');

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(widget.commentId)
          .collection('reports')
          .add({
        'postId': widget.postId,
        'commentId': widget.commentId,
        'commentContent': widget.commentContent,
        'reporterId': user.id,
        'reporterName': user.name,
        'reason': _selectedReason,
        'description': _reasonController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('신고가 접수되었습니다.')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('신고 접수 중 오류가 발생했습니다: $e')));
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
      appBar: AppBar(title: const Text('댓글 신고')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              '신고 사유를 선택해주세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._reportReasons.map(
                  (reason) => RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedReason = value);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: '추가 설명 (선택사항)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '내용을 입력하세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReport,
              child:
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('신고하기'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

class ReportPage extends ConsumerStatefulWidget {
  final String postId;
  final String postContent;

  const ReportPage({
    super.key,
    required this.postId,
    required this.postContent,
  });

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
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

      await FirebaseFirestore.instance.collection('reports').add({
        'postId': widget.postId,
        'postContent': widget.postContent,
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
        ).showSnackBar(const SnackBar(content: Text('신고가 성공적으로 접수되었습니다')));
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
      appBar: AppBar(title: const Text('게시물 신고'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이 게시물을 신고하는 이유는 무엇인가요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(_selectedReason),
                value: _selectedReason,
                decoration: const InputDecoration(
                  labelText: '신고 사유',
                  border: OutlineInputBorder(),
                ),
                items:
                    _reportReasons.map((reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      );
                    }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedReason = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '신고 사유를 선택해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: '추가 설명',
                  hintText: '신고에 대한 자세한 내용을 작성해주세요',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '추가 설명을 작성해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('신고하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

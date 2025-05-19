import 'dart:typed_data';
import '../repository/post_repository.dart';

class UploadImageUseCase {
  final PostRepository repository;

  UploadImageUseCase(this.repository);

  Future<String> call({
    required String uid,
    required Uint8List imageBytes,
  }) async {
    return await repository.uploadImage(uid, imageBytes);
  }
}

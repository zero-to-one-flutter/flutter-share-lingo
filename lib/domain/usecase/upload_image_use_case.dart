import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/data_providers.dart';
import '../repository/image_repository.dart';

class UploadImageFileUseCase {
  final ImageRepository _repository;

  UploadImageFileUseCase(this._repository);

  Future<String> execute(File imageFile, String uid, String folder) {
    return _repository.uploadImage(imageFile, uid, folder);
  }
}

final uploadImageFileUseCaseProvider = Provider<UploadImageFileUseCase>(
      (ref) => UploadImageFileUseCase(ref.read(imageRepositoryProvider)),
);

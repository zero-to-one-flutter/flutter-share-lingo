import 'dart:io';
import '../../domain/repository/image_repository.dart';
import '../data_source/image_storage_data_source.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageStorageDataSource _dataSource;

  ImageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadImage(File imageFile, String uid, String folder) {
    return _dataSource.uploadImage(imageFile, uid, folder);
  }
}

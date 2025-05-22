import 'dart:io';

abstract class ImageRepository {
  Future<String> uploadImage(File imageFile, String uid, String folder);
}

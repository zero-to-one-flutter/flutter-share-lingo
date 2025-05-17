import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_lingo/data/dto/user_dto.dart';

abstract class UserDataSource {
  Future<UserDto?> getUserById(String uid);

  Future<void> saveUser(UserDto user);

  // Future<List<UserDto>> getRecommendedUsers(UserDto user);
}

class UserFirestoreDataSource implements UserDataSource {
  final FirebaseFirestore _firestore;

  UserFirestoreDataSource(this._firestore);

  @override
  Future<UserDto?> getUserById(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserDto.fromMap(uid, doc.data()!);
  }

  @override
  Future<void> saveUser(UserDto user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  /*@override
  Future<List<UserDto>> getRecommendedUsers(UserDto user) async {
    final snapshot =
        await _firestore
            .collection('users')
            .where('nativeLanguage', isEqualTo: user.targetLanguage)
            .where('targetLanguage', isEqualTo: user.nativeLanguage)
            .get();
    return List<UserDto>.from(
      snapshot.docs
          .where((queryDocumentSnapshot) => queryDocumentSnapshot.id != user.id)
          .map((queryDocumentSnapshot) {
            return UserDto.fromMap(
              queryDocumentSnapshot.id,
              queryDocumentSnapshot.data(),
            );
          }),
    );
  }*/
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/data/repository/post_repository_impl.dart';
import 'package:share_lingo/data/data_source/post_remote_data_source.dart';
import 'package:share_lingo/data/dto/post_dto.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  MockPostRemoteDataSource? mockRemoteDataSource;
  PostRepositoryImpl? repository;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    repository = PostRepositoryImpl(mockRemoteDataSource!);
  });

  test('fetchInitialPosts test', () async {
    final mockDto = [
      PostDto(
        id: 'testId',
        uid: 'test123',
        userName: 'user',
        userProfileImage: 'abcd.jpg',
        userNativeLanguage: 'KO',
        userTargetLanguage: 'EN',
        userDistrict: null,
        userLocation: null,
        content: '내용입니다',
        imageUrl: [],
        tags: ['kor'],
        createdAt: DateTime(2023, 1, 1),
        // updatedAt: DateTime(2023, 1, 1),
        likeCount: 0,
        commentCount: 0,
        deleted: false,
      ),
    ];

    when(
      () => mockRemoteDataSource!.fetchInitialPosts(),
    ).thenAnswer((_) async => mockDto);

    final result = await repository!.fetchInitialPosts();

    expect(result.length, 1);
    expect(result.first.uid, 'test123');
    expect(result.first.userLocation, null);
  });
}

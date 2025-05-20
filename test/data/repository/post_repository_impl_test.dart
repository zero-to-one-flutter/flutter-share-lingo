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
        uid: 'a12345',
        content: 'Nice to meet you',
        imageUrl: ['abc.jpg', 'def.jpg'],
        commentCount: 5,
        tags: ['help', 'request'],
        createdAt: DateTime.now(),
        likeCount: 1,
        deleted: false,
      ),
    ];

    when(
      () => mockRemoteDataSource!.fetchInitialPosts(),
    ).thenAnswer((_) async => mockDto);

    final result = await repository!.fetchInitialPosts();

    expect(result.length, 1);
    expect(result.first.uid, 'a12345');
    expect(result.first.imageUrl[1], 'def.jpg');
  });
}

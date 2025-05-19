import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/data/data_source/post_remote_data_source.dart';
import 'package:share_lingo/data/repository/post_repository_impl.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late MockPostRemoteDataSource mockRemoteDataSource;
  late PostRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    repository = PostRepositoryImpl(mockRemoteDataSource);
  });

  test('PostRepositoryImpl - createPost() 정상 위임', () async {
    final entity = PostEntity(
      uid: 'abc123',
      content: 'Hello',
      imageUrl: '',
      tags: ['eng'],
      createdAt: DateTime.now(),
      likeCount: 0,
      commentCount: 0,
      deleted: false,
    );

    when(
      () => mockRemoteDataSource.createPost(any()),
    ).thenAnswer((_) async => Future.value());

    await repository.createPost(entity);
    verify(() => mockRemoteDataSource.createPost(any())).called(1);
  });
}

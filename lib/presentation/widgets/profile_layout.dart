import 'package:flutter/material.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/presentation/widgets/profile_images.dart';

import '../../domain/entity/app_user.dart';

class ProfileLayout extends StatelessWidget {
  final AppUser user;

  const ProfileLayout({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileImages(
                    profileImageUrl: user.profileImage,
                    geoPoint: user.location,
                    isEditable: false,
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              '${user.age}세',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              user.nativeLanguage!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.sync_alt, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              user.targetLanguage!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user.bio!,
                          style: const TextStyle(fontSize: 16.2, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  Divider(
                    height: 1,
                    color: AppColors.borderGrey,
                    thickness: 0.5,
                  ),
                ],
              ),
            ),
            const SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(),
            ),
          ];
        },
        body: const TabBarView(children: [ProfileDetailsTab(), PostListView()]),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      height: 48.0,
      child: const TabBar(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        indicatorColor: Colors.black,
        indicatorWeight: 2,
        tabs: [Tab(text: '프로필'), Tab(text: '게시물')],
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Post #$index'),
          subtitle: Text('This is a sample post in the list.'),
        );
      },
    );
  }
}

class ProfileDetailsTab extends StatelessWidget {
  const ProfileDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // SizedBox(height: 24),
          Text(
            '제 언어 학습 목표는',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '저는 외국인 친구들과 자연스럽게 대화할 수 있을 정도로 유창한 영어 실력을 갖추고 싶습니다. 특히 여행이나 일상적인 상황에서도 막힘없이 말할 수 있도록 회화 능력을 키우는 것이 목표입니다.',
          ),

          SizedBox(height: 24),
          Text(
            '제 취미는',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('제 취미는 여행과 사진 촬영, 그리고 외국 드라마 감상입니다.'),
        ],
      ),
    );
  }
}

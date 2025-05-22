import 'package:flutter/material.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/presentation/widgets/profile_images.dart';

import '../../domain/entity/app_user.dart';
import '../pages/home/tabs/feed/posts_feed_tab.dart';

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
        body: TabBarView(
          children: [
            ProfileDetailsTab(
              languageLearningGoal: user.languageLearningGoal,
              hobbies: user.hobbies,
            ),
            FeedTab(uid: user.id),
          ],
        ),
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

class ProfileDetailsTab extends StatelessWidget {
  final String? languageLearningGoal;
  final String? hobbies;

  const ProfileDetailsTab({
    super.key,
    required this.languageLearningGoal,
    required this.hobbies,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (languageLearningGoal != null &&
              languageLearningGoal!.trim().isNotEmpty) ...[
            const Text(
              '제 언어 학습 목표는',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(languageLearningGoal!),
            const SizedBox(height: 24),
          ],
          if (hobbies != null && hobbies!.trim().isNotEmpty) ...[
            const Text(
              '제 취미는',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(hobbies!),
          ],
        ],
      ),
    );
  }
}

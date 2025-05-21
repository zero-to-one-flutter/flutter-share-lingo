import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/core/utils/format_time_ago.dart';
import 'package:share_lingo/core/utils/general_utils.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/widgets/expandable_text.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_menu_button.dart';
import 'package:share_lingo/presentation/widgets/app_cached_image.dart';

import '../../../../domain/entity/app_user.dart';
import '../../profile/profile_page.dart';

class PostItem extends StatefulWidget {
  final PostEntity post;
  final DateTime now;
  final bool displayComments;

  const PostItem({
    super.key,
    required this.post,
    required this.now,
    required this.displayComments,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    final List<String> images =
        widget.post.imageUrl
            .where((url) => url.trim().isNotEmpty)
            .take(3)
            .toList();

    return InkWell(
      highlightColor: AppColors.lightGrey,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            _topBar(),
            SizedBox(height: 10),
            ExpandableText(widget.post.content, trimLines: 4),
            if (images.isNotEmpty) SizedBox(height: 10),
            _imageBox(images),
            _tagBar(),
            // comment 개수 표시
            // detail 페이지에서는 표시 X
            !widget.displayComments
                ? SizedBox.shrink()
                : Column(
                  children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_outlined,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${widget.post.commentCount}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProfilePage(
                user: AppUser(
                  id: 'u92837465',
                  name: '박민수',
                  createdAt: DateTime(2023, 8, 15),
                  email: 'minsoo.park91@example.com',
                  profileImage: 'https://picsum.photos/200/200?random=1',
                  nativeLanguage: '한국어',
                  targetLanguage: '스페인어',
                  bio:
                      '스페인어를 배우고 있는 직장인입니다. 언어뿐만 아니라 라틴 문화에도 관심이 많아요. 편하게 언어 교환하실 분 환영합니다!',
                  birthdate: DateTime(1991, 11, 8),
                  partnerPreference: '언어 교환에 진지한 분',
                  languageLearningGoal: '남미 여행을 위해 자연스러운 스페인어 회화를 배우고 싶어요.',
                  district: null,
                  location: GeoPoint(37.4979, 127.0276),
                ),
              );
            },
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: AppCachedImage(
              imageUrl: widget.post.userProfileImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.userName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Text(
                    FormatTimeAgo.formatTimeAgo(
                      now: widget.now,
                      createdAt: widget.post.createdAt,
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    // 'KR',
                    GeneralUtils.getLanguageCodeByName(
                      widget.post.userNativeLanguage,
                    )!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Icon(
                      Icons.sync_alt_outlined,
                      size: 16,
                      color: Colors.black26,
                    ),
                  ),
                  Text(
                    // 'EN',
                    GeneralUtils.getLanguageCodeByName(
                      widget.post.userTargetLanguage,
                    )!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          PostMenuButton(post: widget.post),
        ],
      ),
    );
  }

  Widget _imageBox(List<String> images) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    double sizedBoxHeight = 8;
    double sizedBoxWidth = 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;

        switch (images.length) {
          case 1:
            content = Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            );
            break;

          case 2:
            content = Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
            break;

          case 3:
            content = Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[2]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
            break;
          default:
            content = const SizedBox.shrink();
        }

        return Column(
          children: [AspectRatio(aspectRatio: 9 / 5, child: content)],
        );
      },
    );
  }

  Widget _tagBar() {
    final tags = widget.post.tags;
    return Column(
      children: [
        tags.isEmpty ? SizedBox.shrink() : SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              tags.map((text) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.widgetBackgroundBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '# $text',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/core/utils/format_time_ago.dart';
import 'package:share_lingo/core/utils/general_utils.dart';
import 'package:share_lingo/data/dto/post_dto.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/widgets/expandable_text.dart';
import 'package:share_lingo/presentation/pages/home/widgets/post_menu_button.dart';
import 'package:share_lingo/presentation/widgets/app_cached_image.dart';

import '../../../../domain/entity/app_user.dart';
import '../../post/post_detail_page.dart';
import '../../profile/profile_page.dart';

class PostItem extends ConsumerStatefulWidget {
  final PostEntity post;
  // final DateTime now;
  final bool displayComments;
  // final List<ImageProvider> cachedImages;

  const PostItem({
    super.key,
    required this.post,
    // required this.now,
    required this.displayComments,
    // required this.cachedImages,
  });

  @override
  ConsumerState<PostItem> createState() => _PostItemState();

  // @override
  // State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<PostItem> {
  // ignore: unused_field
  final bool _showEmojiPicker = false;

  @override
  Widget build(BuildContext context) {
    final List<ImageProvider> cachedImages = ref
        .read(feedNotifierProvider(null).notifier)
        .getCachedImageProviders(widget.post);

    final DateTime now = ref.watch(timeAgoNotifierProvider);
    return GestureDetector(
      onTap: () async {
        if (PostDetailPage.currentPostId != widget.post.id) {
          // ✅ Firestore에서 최신 데이터 가져오기
          final doc =
              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post.id)
                  .get();

          if (!doc.exists) return; // 예외 처리

          final dto = PostDto.fromMap(doc.id, doc.data()!);
          final freshPost = dto.toEntity();

          if (!context.mounted) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(post: freshPost),
            ),
          ).then((value) {
            PostDetailPage.currentPostId = null;
          });
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            _topBar(now),
            SizedBox(height: 10),
            ExpandableText(widget.post.content, trimLines: 4),
            if (cachedImages.isNotEmpty) SizedBox(height: 10),
            _imageBox(cachedImages),
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

  Widget _topBar(DateTime now) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProfilePage(
                user: AppUser(
                  id: widget.post.uid,
                  name: widget.post.userName,
                  profileImage: widget.post.userProfileImage,
                  nativeLanguage: widget.post.userNativeLanguage,
                  targetLanguage: widget.post.userTargetLanguage,
                  bio: widget.post.userBio,
                  birthdate: widget.post.userBirthdate,
                  hobbies: widget.post.userHobbies,
                  languageLearningGoal: widget.post.userLanguageLearningGoal,
                  district: widget.post.userDistrict,
                  location: widget.post.userLocation,
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
                      now: now,
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

  Widget _imageBox(List<ImageProvider> cachedImages) {
    if (cachedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    double sizedBoxHeight = 8;
    double sizedBoxWidth = 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;

        switch (cachedImages.length) {
          case 1:
            content = GestureDetector(
              onTap:
                  () => showImageViewer(
                    context,
                    cachedImages[0],
                    swipeDismissible: true,
                    doubleTapZoomable: true,
                  ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: cachedImages[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
            break;

          case 2:
            List<ImageProvider> case2Images = [
              cachedImages[0],
              cachedImages[1],
            ];
            content = Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      MultiImageProvider multiImageProvider =
                          MultiImageProvider(case2Images, initialIndex: 0);
                      showImageViewerPager(
                        context,
                        multiImageProvider,
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: cachedImages[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      MultiImageProvider multiImageProvider =
                          MultiImageProvider(case2Images, initialIndex: 1);
                      showImageViewerPager(
                        context,
                        multiImageProvider,
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: cachedImages[1],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
            break;

          case 3:
            List<ImageProvider> case3Images = [
              cachedImages[0],
              cachedImages[1],
              cachedImages[2],
            ];
            content = Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: GestureDetector(
                    onTap: () {
                      MultiImageProvider multiImageProvider =
                          MultiImageProvider(case3Images, initialIndex: 0);
                      showImageViewerPager(
                        context,
                        multiImageProvider,
                        swipeDismissible: true,
                        doubleTapZoomable: true,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: cachedImages[0],
                          fit: BoxFit.cover,
                        ),
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
                        child: GestureDetector(
                          onTap: () {
                            MultiImageProvider multiImageProvider =
                                MultiImageProvider(
                                  case3Images,
                                  initialIndex: 1,
                                );
                            showImageViewerPager(
                              context,
                              multiImageProvider,
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: cachedImages[1],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            MultiImageProvider multiImageProvider =
                                MultiImageProvider(
                                  case3Images,
                                  initialIndex: 2,
                                );
                            showImageViewerPager(
                              context,
                              multiImageProvider,
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: cachedImages[2],
                                fit: BoxFit.cover,
                              ),
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

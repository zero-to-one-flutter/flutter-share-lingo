import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/widgets/profile_images.dart';
import 'package:share_lingo/presentation/widgets/profile_section_card.dart';

import '../../domain/entity/app_user.dart';
import '../user_global_view_model.dart';

class ProfileLayout extends StatelessWidget {
  final AppUser user;

  const ProfileLayout({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover and Profile Image
          ProfileImages(
            profileImageUrl: user.profileImage,
            geoPoint: user.location,
            isEditable: false,
          ),
          const SizedBox(height: 50),
          // Name + Age
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
                    SizedBox(width: 7),
                    Text(
                      '${user.age}세',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                // Language Info
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

                SizedBox(height: 14),
                Text(
                  user.bio!,
                  style: const TextStyle(fontSize: 16.2, height: 1.4),
                ),
              ],
            ),
          ),

          Divider(height: 40, color: Colors.grey[300]),

          // if (user.languageLearningGoal != null &&
          //     user.languageLearningGoal!.isNotEmpty)
          //   ProfileSectionCard('제 언어 학습 목표는', user.languageLearningGoal!),
          ProfileSectionCard('제 언어 학습 목표는', '저는 많은 것들을 배우고 싶고 빨리 영어 배우소 싶습니다'),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

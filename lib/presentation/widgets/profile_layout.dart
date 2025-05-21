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
        children: [
          // Cover and Profile Image
          ProfileImages(
            profileImageUrl: user.profileImage,
            geoPoint: user.location,
            isEditable: false,
          ),
          const SizedBox(height: 60),
          // Name + Age
          Text(
            user.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          if (user.age != null) ...[
            const SizedBox(height: 6),
            Text(
              '${user.age}세',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],

          // Language Info
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO: Remove hardcoded language after setting OnBoarding flow
              Text(
                user.nativeLanguage ?? '한국어',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.sync_alt, size: 20),
              const SizedBox(width: 8),
              Text(
                user.targetLanguage ?? '영어',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),

          // Location Card
          if (user.district != null) ...[
            const SizedBox(height: 20),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final distance = ref
                    .read(userGlobalViewModelProvider.notifier)
                    .calculateDistanceFrom(user.location);
                return _infoTile(
                  icon: Icons.location_on_outlined,
                  title:
                      '${user.district}${user.id != ref.read(userGlobalViewModelProvider)?.id ? '  |  $distance' : ''}',
                );
              },
            ),
          ],

          Divider(height: 40, color: Colors.grey[300]),

          // Bio Section
          if (user.bio != null && user.bio!.isNotEmpty)
            ProfileSectionCard('자기 소개', user.bio!),

          if (user.partnerPreference != null &&
              user.partnerPreference!.isNotEmpty)
            ProfileSectionCard('제게 완벽한 언어 교환 파트너는', user.partnerPreference!),

          if (user.languageLearningGoal != null &&
              user.languageLearningGoal!.isNotEmpty)
            ProfileSectionCard('제 언어 학습 목표는', user.languageLearningGoal!),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _infoTile({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 8),
          Flexible(child: Text(title, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

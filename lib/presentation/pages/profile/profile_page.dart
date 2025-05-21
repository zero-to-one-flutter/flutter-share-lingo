import 'package:flutter/material.dart';

import '../../../domain/entity/app_user.dart';
import '../../widgets/profile_layout.dart';


class ProfilePage extends StatelessWidget {
  final AppUser user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('사용자 프로필')),
      body: ProfileLayout(user: user),
      // bottomNavigationBar: FollowButton(user: user),
    );
  }
}

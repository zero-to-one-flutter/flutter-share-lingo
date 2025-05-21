import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/settings/settings_page.dart';

import '../../../../user_global_view_model.dart';
import '../../../../widgets/profile_layout.dart';

class MyProfileTab extends ConsumerWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userGlobalViewModelProvider);
    if (user == null) {
      return const Center(child: Text('로그인 정보가 없습니다.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '설정',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: ProfileLayout(user: user),
    );
  }
}

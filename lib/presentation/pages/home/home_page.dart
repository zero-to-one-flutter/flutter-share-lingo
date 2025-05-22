import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_tab.dart';
import 'package:share_lingo/presentation/pages/home/tabs/profile/my_profile_tab.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_tab.dart';
import 'package:share_lingo/presentation/pages/home/widgets/home_bottom_navigation_bar.dart';
import 'package:share_lingo/presentation/pages/profile_edit/edit_profile_page.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

import 'home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeViewModelProvider);

    return Scaffold(
      bottomNavigationBar: const HomeBottomNavigationBar(),
      body: IndexedStack(
        index: currentIndex == 1 ? 0 : currentIndex,
        children: const [FeedTab(), PostWriteTab(), MyProfileTab()],
      ),
      floatingActionButton:
          currentIndex == 2
              ? FloatingActionButton(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => EditProfilePage(
                            user: ref.read(userGlobalViewModelProvider)!,
                          ),
                    ),
                  );
                },
                tooltip: '프로필 수정',
                child: const Icon(Icons.edit_note, size: 28),
              )
              : null,
    );
  }
}

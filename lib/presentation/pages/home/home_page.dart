import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_tab.dart';
import 'package:share_lingo/presentation/pages/home/tabs/profile/my_profile_tab.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_tab.dart';
import 'package:share_lingo/presentation/pages/home/widgets/home_bottom_navigation_bar.dart';

import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HomeBottomNavigationBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final currentIndex = ref.watch(homeViewModelProvider);
          return IndexedStack(
            index: currentIndex,
            children: [
              FeedTab(),
              PostWriteTab(),
              MyProfileTab(),
            ],
          );
        },
      ),
    );
  }
}

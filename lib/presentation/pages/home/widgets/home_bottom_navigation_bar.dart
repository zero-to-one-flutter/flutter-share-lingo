import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_view_model.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(homeViewModelProvider);
        final viewModel = ref.read(homeViewModelProvider.notifier);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 19,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            onTap: viewModel.onIndexChanged,
            iconSize: 28,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/hut.png',
                  width: 24,
                  height: 24,
                ),
                activeIcon: Image.asset(
                  'assets/icons/home.png',
                  width: 28,
                  height: 28,
                ),
                label: '',
                tooltip: '홈',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/add_square_icon.png',
                  width: 28,
                  height: 28,
                ),
                activeIcon: Image.asset(
                  'assets/icons/add_square_icon.png',
                  width: 28,
                  height: 28,
                ),
                label: '',
                tooltip: '글쓰기',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_circle),
                activeIcon: Icon(CupertinoIcons.person_circle_fill),
                label: '',
                tooltip: '프로필',
              ),
            ],
          ),
        );
      },
    );
  }
}

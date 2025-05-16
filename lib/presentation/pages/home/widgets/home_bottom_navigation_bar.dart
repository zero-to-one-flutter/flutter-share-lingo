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
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            selectedItemColor: Colors.blueAccent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: '교류',
                tooltip: '교류',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: '글쓰기',
                tooltip: '글쓰기',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_circle),
                activeIcon: Icon(CupertinoIcons.person_circle_fill),
                label: '프로필',
                tooltip: '프로필',
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/presentation/pages/settings/settings_page.dart';

import '../../../../user_global_view_model.dart';
import '../../../../widgets/profile_layout.dart';

class MyProfileTab extends StatelessWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final user = ref.watch(userGlobalViewModelProvider)!;
        return ListView(
          children: [
            AppBar(
              title: Text('나의 프로필'),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: '설정',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SettingsPage();
                        },
                      ),
                    );
                  },
                )
              ],
              // actions: [
              //   InkWell(
              //     onTap: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(
              //           builder: (context) => ProfileEditPage(user: user),
              //         ),
              //       );
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.only(right: 4),
              //       child: SvgPicture.asset(
              //         'assets/icons/edit_square.svg',
              //         width: 24,
              //         height: 24,
              //         color: const Color(0xFF504347),
              //       ),
              //     ),
              //   ),
              // ],
            ),
            ProfileLayout(user: user),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../user_global_view_model.dart';
import 'feed_tab.dart';

class FeedTab extends ConsumerStatefulWidget {
  final String? uid;

  const FeedTab({super.key, this.uid});

  @override
  ConsumerState<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends ConsumerState<FeedTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userGlobalViewModelProvider)!;

    return Column(
      children: [
        if (widget.uid == null) // Only show on main feed
          Column(
            children: [
              AppBar(
                title: Text(
                  'ShareLingo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  indicatorColor: Colors.black,
                  indicatorWeight: 2,
                  tabs: const [
                    Tab(text: '전체'),
                    Tab(text: '추천'),
                    Tab(text: '동급생'),
                    Tab(text: '근처'),
                  ],
                ),
              ),
            ],
          ),
        Expanded(
          child:
              widget.uid != null
                  ? PostListContent(uid: widget.uid!)
                  : TabBarView(
                    controller: _tabController,
                    children: [
                      PostListContent(),
                      PostListContent(filter: 'recommended', user: user),
                      PostListContent(filter: 'peers', user: user),
                      PostListContent(filter: 'nearby', user: user),
                    ],
                  ),
        ),
      ],
    );
  }
}

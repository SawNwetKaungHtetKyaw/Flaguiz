import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/friends/widgets/friend_appbar_widget.dart';
import 'package:flaguiz/pages/friends/widgets/friend_list_widget.dart';
import 'package:flaguiz/pages/friends/widgets/friend_request_widget.dart';
import 'package:flaguiz/pages/friends/widgets/friend_search_widget.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: friendAppBar(),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: const AssetImage(AssetsImages.aboutBg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          )),
          child: Column(
            children: [
              Material(
                color: Colors.grey.shade900,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.grey.shade800,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    AudioService.instance.playSound('tap');
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease,
                    );
                  },
                  tabs: const [
                    Tab(
                        child: CcShadowedTextWidget(
                            text: CcConstants.kFriends, letterSpacing: 1)),
                    Tab(
                        child: CcShadowedTextWidget(
                            text: CcConstants.kRequests, letterSpacing: 1)),
                    Tab(
                        child: CcShadowedTextWidget(
                            text: CcConstants.kSearch, letterSpacing: 1)),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _tabController.animateTo(index);
                  },
                  children: const [
                    FriendListWidget(),
                    FriendRequestWidget(),
                    FriendSearchWidget()
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

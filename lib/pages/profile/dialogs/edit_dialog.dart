import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/profile/dialogs/dialog_widgets/dialog_avatar_widget.dart';
import 'package:flaguiz/pages/profile/dialogs/dialog_widgets/dialog_background_widget.dart';
import 'package:flaguiz/pages/profile/dialogs/dialog_widgets/dialog_banner_widget.dart';
import 'package:flaguiz/pages/profile/dialogs/dialog_widgets/dialog_border_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    return Consumer2<CountryProvider, UserProvider>(
      builder: (context, provider, userProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.editDialog),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    AudioService.instance.playSound('back');
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 59),
                      width: 50,
                      height: 50,
                      color: Colors.transparent),
                ),
              ),
              Material(
                color: editUnSelectedColor,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: const BoxDecoration(
                    color: editSelectedColor,
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
                    TabWidget(title: 'AVT', text: CcConstants.kAvatar),
                    TabWidget(title: 'BD', text: CcConstants.kBorder),
                    TabWidget(title: 'BG', text: CcConstants.kBackground),
                    TabWidget(title: 'BN', text: CcConstants.kBanner),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _tabController.animateTo(index);
                  },
                  children: const [
                    DialogAvatarWidget(),
                    DialogBorderWidget(),
                    DialogBackgroundWidget(),
                    DialogBannerWidget(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({super.key, required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CcShadowedTextWidget(text: title, fontSize: 14),
        const SizedBox(height: 5),
        CcShadowedTextWidget(
            fontSize: 5,
            dx: 1,
            dy: 1,
            maxLines: 1,
            text: text,
            letterSpacing: 0.5),
      ],
    ));
  }
}

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
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: 600,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.only(
                    top: 70, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: TabBar(
                        controller: _tabController,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        labelColor: primaryLightColor,
                        unselectedLabelColor: Colors.white,
                        indicatorColor: primaryLightColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (index) {
                          AudioService.instance.playSound('tap');
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.ease,
                          );
                        },
                        tabs: [
                          /// Avatar Icon
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              AssetsImages.avatarIcon,
                              height: 30,
                              color: _tabController.index == 0
                                  ? primaryLightColor
                                  : Colors.white,
                            ),
                          ),

                          /// Border Icon
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              AssetsImages.borderIcon,
                              height: 30,
                              color: _tabController.index == 1
                                  ? primaryLightColor
                                  : Colors.white,
                            ),
                          ),

                          /// Background Icon
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              AssetsImages.backgroundIcon,
                              height: 30,
                              color: _tabController.index == 2
                                  ? primaryLightColor
                                  : Colors.white,
                            ),
                          ),

                          /// Banner Icon
                          Image.asset(
                            AssetsImages.bannerIcon,
                            height: 40,
                            color: _tabController.index == 3
                                ? primaryLightColor
                                : Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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
              ),

              /// HEADER
              Container(
                width: double.maxFinite,
                height: 70,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  boxShadow: [BoxShadow(offset: Offset(0, 5))],
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: CcShadowedTextWidget(
                        text: CcConstants.kEdit,
                        fontSize: 20,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        onPressed: () {
                          AudioService.instance.playSound('back');
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
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

import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/country_detail/widgets/detail_card_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_ads_banner_widget.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryDetail extends StatefulWidget {
  const CountryDetail({super.key, required this.index});
  final int index;

  @override
  State<CountryDetail> createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CountryProvider, UserProvider>(
          builder: (context, provider, userProvider, child) {
        List<String> keenEyeList = provider.keenEyeList;
        bool hasKeenEyeAchv =
            userProvider.user?.achievements!.contains('ACHV_007') ?? false;
        return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetsImages.libraryBg),
                    fit: BoxFit.cover)),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CcBackWidget(image: AssetsImages.libraryBackKey),
                ),
                Expanded(
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: provider.countryList.length,
                        dragStartBehavior: DragStartBehavior.down,
                        onPageChanged: (int index) async {
                          if (!keenEyeList.contains(index.toString()) &&
                              !hasKeenEyeAchv) {
                            keenEyeList.add(index.toString());
                            provider.addKeenKye();
                            if (keenEyeList.length == 233) {
                              userProvider.updateUserDataForAchievement(
                                  "ACHV_007", CcConfig.ACHIEVEMENT_COIN);
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const CcAchievementDialog(
                                          achievementId: 'ACHV_007'));
                            }
                          }
                        },
                        itemBuilder: (BuildContext context, int index) {
                          if (!keenEyeList.contains(widget.index.toString()) &&
                              !hasKeenEyeAchv) {
                            keenEyeList.add(widget.index.toString());
                            provider.addKeenKye();
                            if (keenEyeList.length == 233) {
                              userProvider.updateUserDataForAchievement(
                                  "ACHV_007", CcConfig.ACHIEVEMENT_COIN);
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const CcAchievementDialog(
                                          achievementId: 'ACHV_007'));
                            }
                          }

                          CountryModel country = provider.countryList[index];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                /// Country Flag
                                CcShadowedImageBoxWidget(
                                    width: 240,
                                    height: 160,
                                    image:
                                        "${CcConfig.image_base_url}${country.flagUrl}"),

                                /// Country Name
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CcShadowedTextWidget(
                                    text: country.name ?? '',
                                    textAlign: TextAlign.center,
                                    fontSize: 22,
                                  ),
                                ),

                                /// Cards
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(children: [
                                    /// Region
                                    DetailCardWidget(
                                      icon: AssetsImages.regionIcon,
                                      text: country.region ?? '',
                                    ),

                                    /// Currency
                                    DetailCardWidget(
                                      icon: AssetsImages.currencyIcon,
                                      text: country.currency ?? '',
                                    ),

                                    /// Capital
                                    DetailCardWidget(
                                      icon: AssetsImages.capitalIcon,
                                      text: country.capital ?? '',
                                    ),
                                  ]),
                                ),

                                /// Country Detail
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 8),
                                  // child: InlineSeeMoreText(
                                  //     text: CcConstants.lorem),
                                ),

                                /// Country Map
                                CcShadowedImageBoxWidget(
                                    width: double.maxFinite,
                                    height: 240,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    image:
                                        "${CcConfig.image_base_url}${country.mapUrl}")

                                /// Popular Places
                              ],
                            ),
                          );
                        })),

                      const CcAdsBannerWidget(adKey: CcAdsKey.bannerCountryDetail)
              ],
            )));
      }),
    );
  }
}

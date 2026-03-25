import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/about/widgets/about_contact_us_widget.dart';
import 'package:flaguiz/pages/about/widgets/about_title_widget.dart';
import 'package:flaguiz/pages/about/widgets/social_icon_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class About extends StatelessWidget {
  const About({super.key});

  showSupporterAchvDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      UserModel? user = userProvider.user;
      List<String> achvList = user?.achievements ?? [];

      if (!achvList.contains('ACHV_008')) {
        userProvider.updateUserDataForAchievement(
            "ACHV_008", CcConfig.ACHIEVEMENT_COIN);
        showDialog(
            context: context,
            builder: (context) => const CcAchievementDialog(
                achievementId: 'ACHV_008', showDescription: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const AssetImage(AssetsImages.aboutBg),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        )),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Flaguiz Iconic
                    const CcShadowedImageBoxWidget(
                      width: 150,
                      height: 150,
                      image: AssetsImages.appIcon,
                      margin: EdgeInsets.only(bottom: 20, top: 80),
                    ),

                    /// Flaguiz App Name
                    CcShadowedTextWidget(
                      text: CcConfig.appName,
                      fontSize: 20,
                    ),

                    const SizedBox(height: 5),

                    /// Version
                    CcShadowedTextWidget(
                      text: "${CcConstants.kVersion} : ${CcConfig.version}",
                      textColor: Colors.grey.shade200,
                      dx: 1.5,
                      dy: 1.5,
                    ),

                    /// App Description
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: CcShadowedTextWidget(
                        text: CcConstants.aboutDescription,
                        fontSize: 10,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    /// Social Section

                    CcGlassWidget(
                      height: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const AboutTitleWidget(title: CcConstants.kSocial),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// You Tube
                                SocialIconWidget(
                                    icon: AssetsImages.youTubeIcon,
                                    onTap: () async {
                                      await Utils.openLink(
                                          CcConfig.YOUTUBE_URL, context);
                                      if (context.mounted) showSupporterAchvDialog(context);
                                    }),

                                /// Tiktok
                                SocialIconWidget(
                                    icon: AssetsImages.tiktokIcon,
                                    onTap: () async {
                                      await Utils.openLink(
                                          CcConfig.TIKTOK_URL, context);
                                      if (context.mounted) showSupporterAchvDialog(context);
                                    }),

                                /// Facebook
                                SocialIconWidget(
                                    icon: AssetsImages.facebookIcon,
                                    onTap: () async {
                                      await Utils.openLink(
                                          CcConfig.FACEBOOK_URL, context);
                                      if (context.mounted) showSupporterAchvDialog(context);
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const AboutContactUsWidget(),

                    const SizedBox(height: 50),

                    CcShadowedTextWidget(
                        text:
                            "${CcConstants.kDevelopedBy} ${CcConfig.companyName}"),

                    const SizedBox(height: 50),
                  ],
                ),
              ),

              /// Back Key
              const Positioned(
                  top: 8,
                  left: 8,
                  child: CcBackWidget(image: AssetsImages.defaultBackKey))
            ],
          ),
        )),
      ),
    );
  }
}

import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_achievement_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_adventure_status_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_challenge_status_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_status_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_banner_widget.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_country_widget.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flaguiz/widgets/cc_title_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendProfileDialog extends StatelessWidget {
  const FriendProfileDialog({
    super.key,
    required this.player,
    required this.page,
  });
  final UserModel? player;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider,BackgroundProvider>(
      builder: (context, provider,backgroundProvider, child) {
        UserModel? user = provider.user;
        
        backgroundProvider.getById(player?.backgrounds?[0] ?? "BG_001");
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              height: 600,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: Utils.checkImageType(backgroundProvider.background?.localPath ??
                        "${backgroundProvider.background?.imageUrl}"),fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        /// Profile Title
                        Center(
                          child: CcShadowedTextWidget(
                            letterSpacing: 1,
                            fontSize: 18,
                            text: "${player?.username ?? 'Player'}'s\nProfile",
                            textColor: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Player Banner
                        ProfileBannerWidget(
                          padding: EdgeInsets.zero,
                          height: 155,
                          id: player?.banners?[0] ?? 'BN_001',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              /// Player Image
                              CcProfileImageWidget(
                                avatar: player?.avatars?[0] ?? 'AVT_001',
                                border: player?.borders?[0] ?? 'BD_001',
                              ),

                              const SizedBox(width: 5),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Player Name
                                  CcShadowedTextWidget(
                                    text: player?.username ?? "Player",
                                    fontSize: 14,
                                  ),

                                  Row(
                                    children: [
                                      Image.asset(
                                        AssetsImages.trophy,
                                        width: 35,
                                      ),
                                      const SizedBox(width: 10),
                                      CcTitleTextWidget(
                                        text: player?.trophy.toString() ?? '0',
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),

                                  /// Friend
                                  Visibility(
                                    visible: player?.id != user?.id,
                                    child: FriendProfileStatusWidget(
                                      friend: player,
                                    ),
                                  ),

                                  /// Add Friend
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// Country
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AssetsImages.pieceLeft, width: 30),
                            CcCountryWidget(
                              width: 55,
                              height: 36,
                              radius: 2,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              countryId: player?.country ?? '0',
                            ),
                            Image.asset(AssetsImages.pieceRight, width: 30),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// Adventure Status
                        FriendProfileAdventureStatusWidget(
                          list: player?.adventureCompletedList ?? [],
                        ),

                        const SizedBox(height: 10),

                        /// Challenge Status
                        FriendProfileChallengeStatusWidget(
                          list: player?.challengeCompletedList ?? [],
                        ),

                        const SizedBox(height: 30),

                        /// Achievements
                        FriendProfileAchievementWidget(
                          playerAchievements: player?.achievements ?? [],
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: CcOutlinedButton(
                      margin: const EdgeInsets.only(top: 5, right: 5),
                      width: 30,
                      height: 30,
                      radius: 3,
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                        shadows: [BoxShadow(offset: Offset(1, 1))],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

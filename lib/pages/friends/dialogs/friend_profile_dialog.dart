import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_achievement_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_adventure_status_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_challenge_status_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_country_widget.dart';
import 'package:flaguiz/pages/friends/dialogs/widgets/friend_profile_status_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_banner_widget.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_profile_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flaguiz/widgets/cc_title_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class FriendProfileDialog extends StatelessWidget {
  const FriendProfileDialog(
      {super.key,
      required this.player,
      required this.playerCountry,
      required this.page});
  final UserModel? player;
  final CountryModel? playerCountry;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.maxFinite,
          height: 550,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: const AssetImage(AssetsImages.profileBg),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: CcOutlinedButton(
                        margin: const EdgeInsets.only(top: 10, right: 10),
                        width: 35,
                        height: 35,
                        radius: 3,
                        onTap: () {
                          AudioService.instance.playSound('tap');
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                          shadows: [BoxShadow(offset: Offset(1, 1))],
                        ))),

                /// Profile Title
                Center(
                    child: CcShadowedTextWidget(
                  letterSpacing: 1,
                  fontSize: 14,
                  text: "${player?.username ?? 'Player'}'s Profile",
                  textColor: Colors.white,
                )),

                /// Player Banner
                ProfileBannerWidget(
                    padding: EdgeInsets.zero,
                    height: 155,
                    id: player?.banners?[0] ?? 'BN_001'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    children: [
                      /// Player Image
                      CcProfileImageWidget(
                          avatar: player?.avatars?[0] ?? 'AVT_001',
                          border: player?.borders?[0] ?? 'BD_001'),

                      const SizedBox(width: 5),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Player Name
                          CcShadowedTextWidget(
                              text: player?.username ?? "Player", fontSize: 14),

                          Row(
                            children: [
                              Image.asset(AssetsImages.trophy, width: 35),
                              const SizedBox(width: 10),
                              CcTitleTextWidget(
                                text: player?.trophy.toString() ?? '0',
                                fontSize: 12,
                              )
                            ],
                          ),

                          /// UnFriend
                          FriendProfileStatusWidget(
                            isVisible: page == CcConstants.K_FRIENDS,
                            text: CcConstants.STATUS_FRIEND,
                            color: successColor,
                            icon: Remix.user_follow_fill,
                            onTap: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                /// Country
                FriendProfileCountryWidget(playerCountry: playerCountry),

                const SizedBox(height: 10),

                /// Adventure Status
                FriendProfileAdventureStatusWidget(
                    list: player?.adventureCompletedList ?? []),

                const SizedBox(height: 10),

                /// Challenge Status
                FriendProfileChallengeStatusWidget(
                    list: player?.challengeCompletedList ?? []),

                const SizedBox(height: 30),

                /// Achievements
                FriendProfileAchievementWidget(
                    playerAchievements: player?.achievements ?? [])
              ],
            ),
          ),
        ),
      ],
    );
  }
}

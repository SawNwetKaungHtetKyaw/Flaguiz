import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/dialogs/friend_profile_dialog.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_country_widget.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class LeaderboardCardWidget extends StatelessWidget {
  const LeaderboardCardWidget({
    super.key,
    required this.index,
    required this.user,
  });
  final int index;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    Widget showBadges(int index) {
      switch (index) {
        case 0:
          return Image.asset(AssetsImages.badges1, width: 40);
        case 1:
          return Image.asset(AssetsImages.badges2, width: 40);
        case 2:
          return Image.asset(AssetsImages.badges3, width: 40);
        default:
          return Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: CcShadowedTextWidget(text: "${index + 1}.", fontSize: 14),
          );
      }
    }

    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () {
            AudioService.instance.playSound('tap');
            if (provider.isLoggedIn) {
              showDialog(
                context: context,
                builder:
                    (context) => FriendProfileDialog(
                      player: user,
                      page: CcConstants.K_LEADERBOARD,
                    ),
              );
            } else {
              Utils.showWelcomToast(
                context,
                "Please Login.\nTo See Other Profile.",
              );
            }
          },
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(5),
              border:
                  (user.hasPremium ?? false)
                      ? Border.all(color: leaderboardColor, width: 2)
                      : null,
            ),
            child: Row(
              children: [
                showBadges(index),
                const SizedBox(width: 5),
                Stack(
                  children: [
                    CcProfileImageWidget(
                      size: 50,
                      avatar: user.avatars?[0] ?? "AVT_001",
                      border: user.borders?[0] ?? 'BD_001',
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CcCountryWidget(countryId: user.country ?? '0'),
                    ),
                  ],
                ),
                const SizedBox(width: 5),

                /// Player Name
                Expanded(
                  child: Row(
                    children: [
                      CcShadowedTextWidget(
                        text: user.username ?? 'Player',
                        letterSpacing: 1,
                        padding: EdgeInsetsGeometry.only(right: 5),
                      ),

                      Visibility(
                        visible: user.hasPremium ?? false,
                        child: Icon(
                          RemixIcons.vip_crown_2_fill,
                          color: leaderboardColor,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Player Trophy
                Image.asset(AssetsImages.trophy, width: 30),
                CcShadowedTextWidget(
                  text: Utils.formatNumber(user.trophy ?? 0),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}

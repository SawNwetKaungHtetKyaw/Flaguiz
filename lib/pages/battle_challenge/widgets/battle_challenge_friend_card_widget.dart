import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_online_status_widget.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallengeFriendCardWidget extends StatelessWidget {
  const BattleChallengeFriendCardWidget({super.key, required this.player});
  final UserModel player;

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () async {
            AudioService.instance.playSound('tap');

            // if (!context.mounted) return;
            // showDialog(
            //   context: context,
            //   builder:
            //       (context) => FriendProfileDialog(player: player, page: page),
            // );
          },
          child: Container(
            width: double.maxFinite,
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                CcProfileImageWidget(
                  avatar: player.avatars?[0] ?? '',
                  border: player.borders?[0] ?? '',
                  size: 60,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CcShadowedTextWidget(text: player.username ?? ''),

                    CcOnlineStatusWidget(
                      isOnline: player.isOnline ?? false,
                      dateTime: player.lastSeen,
                    ),
                  ],
                ),
                const Spacer(),

                CcOutlinedButton(
                  width: 35,
                  height: 35,
                  color: (player.isOnline ?? false) ? successColor : Colors.grey,
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(right: 8),
                  child: Image.asset(AssetsImages.battle, color: Colors.white),
                  onTap: () {
                    if(!(player.isOnline ?? false)) return;
                    AudioService.instance.playSound('tap');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

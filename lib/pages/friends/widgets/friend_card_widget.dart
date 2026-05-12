import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/friend_request_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/dialogs/friend_profile_dialog.dart';
import 'package:flaguiz/pages/friends/widgets/friend_action_button_widget.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendCardWidget extends StatelessWidget {
  const FriendCardWidget({
    super.key,
    required this.player,
    required this.page,
    this.requestModel,
  });
  final UserModel player;
  final String page;
  final FriendRequestModel? requestModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () async {
            AudioService.instance.playSound('tap');

            if (!context.mounted) return;
            showDialog(
              context: context,
              builder:
                  (context) => FriendProfileDialog(player: player, page: page),
            );
          },
          child: Container(
            width: double.maxFinite,
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              boxShadow: const [BoxShadow(offset: Offset(4, 4))],
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

                    Visibility(
                      visible: page == CcConstants.K_FRIENDS,
                      child: CcOnlineStatus(isOnline: player.isOnline ?? false,dateTime: player.lastSeen)),
                  ],
                ),
                const Spacer(),
                FriendActionButtonWidget(
                  friend: player,
                  requestModel: requestModel,
                  page: page,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CcOnlineStatus extends StatelessWidget {
  const CcOnlineStatus({
    super.key,
    required this.isOnline,
    required this.dateTime
  });
  final bool isOnline;
  final DateTime? dateTime;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: isOnline ? successColor : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
    
        Text(
          Utils.getLastSeen(dateTime),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

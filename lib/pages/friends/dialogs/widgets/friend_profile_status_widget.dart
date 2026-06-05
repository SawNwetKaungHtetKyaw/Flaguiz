import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/dialogs/unfriend_dialog.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/enum/friend_status.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class FriendProfileStatusWidget extends StatelessWidget {
  const FriendProfileStatusWidget({
    super.key,
    required this.friend
  });
  final UserModel? friend;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendsProvider, UserProvider>(
      builder: (context, provider, userProvider, child) {
        final UserModel? user = userProvider.user;

        return StreamBuilder<FriendStatus>(
          stream: provider.getFriendStatus(user?.id ?? '', friend?.id ?? ''),
          builder: (context, snapshot) {
            final status = snapshot.data ?? FriendStatus.none;

            switch (status) {
              case FriendStatus.none:

                /// Add Friend
                return ActionButton(
                  color: successColor,
                  text: CcConstants.STATUS_ADD_FRIEND,
                  icon: Remix.user_add_fill,
                  width: 100,
                  onTap: () async {
                    if (user == null || friend == null) return;
                    Utils.showLoadingDialog(context);
                    await provider.sendRequest(user, friend!);
                    if (!context.mounted) return;
                    Utils.hideLoadingDialog(context);
                  },
                );

              case FriendStatus.pending:

                /// Cancel Request
                return ActionButton(
                  color: primaryColor,
                  text: CcConstants.STATUS_PENDING,
                  icon: Remix.hourglass_2_fill,
                  width: 100,
                  onTap: () async {
                    if (user == null) return;
                    Utils.showLoadingDialog(context);
                    await provider.cancelRequest(user.id!, friend?.id ?? '');
                    if (!context.mounted) return;
                    Utils.hideLoadingDialog(context);
                  },
                );

              case FriendStatus.received:

                /// Accept Request
                return ActionButton(
                  color: Colors.orange,
                  text: "Reqested",
                  icon: Remix.user_received_fill,
                  width: 100,
                  onTap: () {
                    Utils.showWelcomToast(
                      context,
                      "Accept from Requests Page!",
                    );
                  },
                );

              case FriendStatus.friend:

                /// Friend
                return ActionButton(
                  color: Colors.grey.shade600,
                  text: CcConstants.STATUS_FRIEND,
                  icon: Remix.user_follow_fill,
                  width: 100,
                  onTap: () async {
                    if (user == null) return;
              showDialog(
                context: context,
                builder:
                    (context) => UnfriendDialog(
                      userId: user.id ?? '',
                      playerId: friend?.id ?? '',
                    ),
              );
                  },
                );
            }
          },
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.width,
  });
  final Color color;
  final IconData icon;
  final String text;
  final Function onTap;
  final double width;
  @override
  Widget build(BuildContext context) {
    return CcOutlinedButton(
      color: color,
      width: width,
      height: 28,
      radius: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
            shadows: const [BoxShadow(offset: Offset(1, 1))],
          ),

          const SizedBox(width: 5),

          CcShadowedTextWidget(
            text: text,
            fontSize: 8,
            letterSpacing: 0.1,
            dx: 1,
            dy: 1,
          ),
        ],
      ),
      onTap: () async {
        AudioService.instance.playSound('tap');
        onTap();
      },
    );
  }
}

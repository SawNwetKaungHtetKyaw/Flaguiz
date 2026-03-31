import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/friend_request_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/enum/friend_status.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class FriendActionButtonWidget extends StatelessWidget {
  const FriendActionButtonWidget(
      {super.key,
      required this.playerId,
      this.requestModel,
      this.page = CcConstants.K_FRIENDS,
      this.margin = const EdgeInsets.only(right: 10)});
  final EdgeInsets margin;
  final String playerId;
  final String page;
  final FriendRequestModel? requestModel;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendsProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      final UserModel? user = userProvider.user;
      ///////////////////////////////////////
      /// FRIEND LIST SECTION
      ///////////////////////////////////////
      if (page == CcConstants.K_FRIENDS) {
        return ActionButtonFrame(
            color: errorColor,
            margin: margin,
            iconData: Remix.user_minus_fill,
            onTap: () async {
              if (user == null) return;
              Utils.showLoadingDialog(context);
              await provider.unfriend(
                  userId: user.id ?? '', playerId: playerId);
              provider.listenFriends(user.id ?? '');

              if (!context.mounted) return;
              Utils.hideLoadingDialog(context);
            });
      }

      ///////////////////////////////////////
      /// REQUEST FRIEND SECTION
      ///////////////////////////////////////
      if (page == CcConstants.K_REQUEST) {
        return Row(
          children: [
            ActionButtonFrame(
                color: errorColor,
                margin: margin,
                iconData: Remix.close_fill,
                onTap: () async {
                  if (requestModel == null) return;
                  await provider.declineRequest(requestModel?.id ?? '');
                }),
            ActionButtonFrame(
                margin: margin,
                iconData: Remix.check_fill,
                onTap: () async {
                  if (user == null) return;
                  await provider.acceptRequest(requestModel!, user.id ?? '');
                })
          ],
        );
      }

      ///////////////////////////////////////
      /// SEARCH FRIEND SECTION
      ///////////////////////////////////////

      if (page == CcConstants.K_SEARCH) {
        return StreamBuilder<FriendStatus>(
          stream: provider.getFriendStatus(user?.id ?? '', playerId),
          builder: (context, snapshot) {
            final status = snapshot.data ?? FriendStatus.none;

            switch (status) {
              case FriendStatus.none:

                /// Add Friend
                return ActionButtonFrame(
                  margin: margin,
                  iconData: Remix.user_add_fill,
                  onTap: () async {
                    if (user == null) return;
                    Utils.showLoadingDialog(context);
                    await provider.sendRequest(user, playerId);
                    if (!context.mounted) return;
                    Utils.hideLoadingDialog(context);
                  },
                );

              case FriendStatus.pending:

                /// Cancel Request
                return ActionButtonFrame(
                  color: primaryColor,
                  margin: margin,
                  iconData: Remix.hourglass_2_fill,
                  onTap: () async {
                    if (user == null) return;
                    Utils.showLoadingDialog(context);
                    await provider.cancelRequest(user.id!, playerId);
                    if (!context.mounted) return;
                    Utils.hideLoadingDialog(context);
                  },
                );

              case FriendStatus.received:

                /// Accept Request
                return ActionButtonFrame(
                  color: Colors.orange,
                  margin: margin,
                  iconData: Remix.user_received_fill,
                  onTap: () {
                    Utils.showToastMessage(
                        context, "Accept from Requests Page!");
                  },
                );

              case FriendStatus.friend:

                /// Unfriend
                return ActionButtonFrame(
                  color: errorColor,
                  margin: margin,
                  iconData: Remix.user_minus_fill,
                  onTap: () async {
                    if (user == null) return;
                    Utils.showLoadingDialog(context);
                    await provider.unfriend(
                        userId: user.id ?? '', playerId: playerId);
                    provider.listenFriends(user.id ?? '');

                    if (!context.mounted) return;
                    Utils.hideLoadingDialog(context);
                  },
                );
            }
          },
        );
      }
      return const SizedBox();
    });
  }
}

class ActionButtonFrame extends StatelessWidget {
  const ActionButtonFrame(
      {super.key,
      this.size = 35,
      this.margin,
      required this.onTap,
      this.color = successColor,
      required this.iconData});
  final double size;
  final EdgeInsets? margin;
  final Function onTap;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return CcOutlinedButton(
      color: color,
      width: size,
      height: size,
      margin: margin,
      radius: 3,
      child: Icon(iconData,
          color: Colors.white,
          size: 24,
          shadows: const [BoxShadow(offset: Offset(1, 1))]),
      onTap: () async {
        AudioService.instance.playSound('tap');
        onTap();
      },
    );
  }
}

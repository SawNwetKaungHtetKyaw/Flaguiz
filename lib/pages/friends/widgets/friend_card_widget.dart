import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/friend_request_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/dialogs/friend_profile_dialog.dart';
import 'package:flaguiz/pages/friends/widgets/friend_action_button_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_profile_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendCardWidget extends StatelessWidget {
  const FriendCardWidget(
      {super.key, required this.player, required this.page, this.requestModel});
  final UserModel? player;
  final String page;
  final FriendRequestModel? requestModel;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendsProvider, CountryProvider>(
        builder: (context, provider, countryProvider, child) {
      return GestureDetector(
        onTap: () async {
          AudioService.instance.playSound('tap');
          CountryModel? country =
              await countryProvider.countryById(player?.country ?? '');

          if (!context.mounted) return;
          showDialog(
              context: context,
              builder: (context) => FriendProfileDialog(
                  player: player, playerCountry: country, page: page));
        },
        child: Container(
          width: double.maxFinite,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade800,
              boxShadow: const [BoxShadow(offset: Offset(4, 4))]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 5),
              CcProfileImageWidget(
                  avatar: player?.avatars?[0] ?? '',
                  border: player?.borders?[0] ?? '',
                  size: 60),
              const SizedBox(width: 10),
              CcShadowedTextWidget(text: player?.username ?? ''),
              const Spacer(),
              FriendActionButtonWidget(
                playerId: player?.id ?? '',
                requestModel: requestModel,
                page: page,
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/pages/friends/widgets/friend_card_widget.dart';
import 'package:flutter/material.dart';

class FriendListWidget extends StatelessWidget {
  const FriendListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FriendCardWidget(user: CcConfig.DEFAULT_USER),
      ],
    );
  }
}

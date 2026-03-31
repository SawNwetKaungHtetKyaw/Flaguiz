import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/widgets/friend_card_widget.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendListWidget extends StatelessWidget {
  const FriendListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendsProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      UserModel? user = userProvider.user;
      return StreamBuilder<List<UserModel>>(
        stream: provider.listenFriends(user?.id ?? ''),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final friends = snapshot.data!;

          if (friends.isEmpty) {
            return const Center(
              child: CcShadowedTextWidget(
                  text: 'No Friends'),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendCardWidget(player:friend, page: CcConstants.K_FRIENDS);
            },
          );
        },
      );
    });
  }
}

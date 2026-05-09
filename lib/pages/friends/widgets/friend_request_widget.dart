import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/friends/widgets/friend_card_widget.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendRequestWidget extends StatelessWidget {
  const FriendRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendsProvider, UserProvider>(
      builder: (context, provider, userProvider, child) {
        return provider.getRequests.isEmpty && provider.sendRequests.isEmpty
            ? const Center(
                child: CcShadowedTextWidget(
                    text: 'There is no Friends Request Yet...',
                    textAlign: TextAlign.center))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.getRequests.length,
                        itemBuilder: (context, index) {
                          final req = provider.getRequests[index];

                          return FriendCardWidget(
                              player: req.user,
                              page: CcConstants.K_REQUEST,
                              requestModel: req);
                        }),

                    const CcShadowedTextWidget(text: "Your Requests",padding: EdgeInsets.symmetric(vertical: 10)),

                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.sendRequests.length,
                        itemBuilder: (context, index) {
                          final req = provider.sendRequests[index];

                          return FriendCardWidget(
                              player: req.friend,
                              page: CcConstants.K_SEARCH,
                              requestModel: req);
                        }),
                  ],
                ),
              );
      },
    );
  }
}

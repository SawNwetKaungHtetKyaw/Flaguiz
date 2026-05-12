import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/leaderboard/widgets/leaderboard_card_widget.dart';
import 'package:flaguiz/providers/leaderboard_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardGlobalWidget extends StatelessWidget {
  const LeaderboardGlobalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaderboardProvider>(builder: (context, provider, child) {
      return FutureBuilder(
        future: provider.getGlobalLeaderBoard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: CcShadowedTextWidget(text : "No Global Player Data"));
          }

          final List<UserModel> users = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel? user = users[index];
              return LeaderboardCardWidget(index: index, user: user);
            },
          );
        },
      );
    });
  }
}

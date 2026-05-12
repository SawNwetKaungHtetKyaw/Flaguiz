import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/battle_challenge/widgets/battle_challenge_friend_card_widget.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallenge extends StatelessWidget {
  const BattleChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, FriendsProvider>(
      builder: (context, userProvider, friendProvider, child) {
        UserModel? user = userProvider.user;
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsImages.battleBg),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: CcBackWidget(
                      image: AssetsImages.battleBackKey,
                      margin: EdgeInsets.all(8),
                    ),
                  ),

                  const SizedBox(height: 10),

                  CcProfileImageWidget(
                    size: 130,
                    avatar: user?.avatars?[0] ?? "AVT_001",
                    border: user?.borders?[0] ?? "BD_001",
                  ),

                  CcShadowedTextWidget(
                    text: user?.username ?? "Player",
                    fontSize: 14,
                    padding: EdgeInsetsGeometry.only(top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetsImages.trophy, width: 50),
                      const SizedBox(width: 5),
                      CcShadowedTextWidget(
                        text: (user?.trophy ?? 0).toString(),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(),
                  ),

                  CcShadowedTextWidget(
                    text: CcConstants.kChallengeFriends,
                    fontSize: 16,
                    padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                  ),

                  Expanded(
                    child: StreamBuilder<List<UserModel>>(
                      stream: friendProvider.listenFriends(user?.id ?? ''),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                    
                        final friends = snapshot.data!;
                    
                        if (friends.isEmpty) {
                          return const Center(
                            child: CcShadowedTextWidget(text: 'No Friends'),
                          );
                        }

                        List<UserModel> sortFriends = Utils.sortFriends(friends);
                    
                        return ListView.builder(
                          itemCount: sortFriends.length,
                          itemBuilder: (context, index) {
                            final friend = sortFriends[index];
                            return BattleChallengeFriendCardWidget(
                              player: friend,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

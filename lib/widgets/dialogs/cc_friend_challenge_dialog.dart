import 'dart:async';

import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/providers/battle_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_profile_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CcFriendChallengeDialog extends StatelessWidget {
  const CcFriendChallengeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BattleProvider, UserProvider>(
      builder: (context, provider, userProvider, child) {
        UserModel? user = userProvider.user;
        return StreamBuilder(
          stream: provider.incomingChallenge(user?.id ?? ''),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const SizedBox();
            }

            final data = docs.first.data() as Map<String, dynamic>;

            final roomId = data['room_id'];

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,

                builder: (_) {
                  return Dialog(
                    // insetPadding: EdgeInsets.symmetric(horizontal: 0),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      width: 300,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetsImages.friendChallengeBox),
                          fit: BoxFit.fill,
                        ),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          CcProfileImageWidget(
                            size: 80,
                            avatar: data['host']['avatar'] ?? 'AVT_001',
                            border: data['host']['border'] ?? 'BD_001',
                          ),

                          const SizedBox(height: 10),

                          CcShadowedTextWidget(
                            text: '"${data['host']['username'] ?? "Player"}"',
                            letterSpacing: 1,
                            fontSize: 16,
                            dx: 1,
                            dy: 1,
                          ),

                          const SizedBox(height: 8),

                          CcShadowedTextWidget(
                            text: CcConstants.kChallengeYou,
                            letterSpacing: 1,
                            fontSize: 12,
                            dx: 1,
                            dy: 1,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: CcOutlinedButton(
                                  height: 40,
                                  color: errorColor,
                                  margin: EdgeInsets.only(left: 20),
                                  onTap: () async {
                                    await provider.declineBattle(roomId);
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  },
                                  child: CcShadowedTextWidget(
                                    text: CcConstants.kDecline,
                                    fontSize: 12,
                                    dx: 1,
                                    dy: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CcOutlinedButton(
                                  height: 40,
                                  color: successColor,
                                  margin: const EdgeInsets.only(right: 20),
                                  onTap: () async {
                                    Utils.showLoadingDialog(context);

                                    try {
                                      final String targetRoomId = roomId;

                                      bool isRoomExist = await provider
                                          .acceptBattle(targetRoomId);

                                      if (!isRoomExist) {
                                        if (!context.mounted) return;

                                        Utils.hideLoadingDialog(context);

                                        Navigator.of(context).pop();

                                        Utils.showToastMessage(context, "Timeout!");

                                        return;
                                      }

                                      StreamSubscription? friendSub;
                                      friendSub = provider
                                          .roomStream(targetRoomId)
                                          .listen((event) async {
                                            print("====>${event.exists}");
                                            if (!event.exists) return;

                                            final roomData =
                                                event.data()
                                                    as Map<String, dynamic>;

                                            if (roomData['status'] ==
                                                "playing") {
                                              await friendSub?.cancel();

                                              if (!context.mounted) return;

                                              Utils.hideLoadingDialog(context);

                                              Navigator.of(context).pop();

                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamed(
                                                      RoutePaths
                                                          .battleChallengeIntro,
                                                      arguments: [
                                                        targetRoomId,
                                                        MiniProfileModel.fromMap(
                                                          roomData['friend'],
                                                        ),
                                                        MiniProfileModel.fromMap(
                                                          roomData['host'],
                                                        ),
                                                        roomData['questions'],
                                                        false,
                                                      ],
                                                    );
                                                  });
                                            }
                                          });
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      Utils.hideLoadingDialog(context);
                                      Utils.showToastMessage(context, "Error Joining Room!");
                                    }
                                  },
                                  child: CcShadowedTextWidget(
                                    text: CcConstants.kAccept,
                                    fontSize: 12,
                                    dx: 1,
                                    dy: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });

            return const SizedBox();
          },
        );
      },
    );
  }
}

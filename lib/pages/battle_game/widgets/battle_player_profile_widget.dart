import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/bot/bot_model.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/service/cached_image_manager_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattlePlayerProfileWidget extends StatelessWidget {
  const BattlePlayerProfileWidget(
      {super.key,
      required this.isYou,
      required this.player});
  final bool isYou;
  final BotModel player;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<BattleGameProvider>(
      builder: (context, provider, child) => Expanded(
          child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(isYou ? 1.0 : -1.0, 1.0),
              child: Container(
                height: screenSize.width / 4.7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            cacheManager: CachedImageManagerService(),
                            "${CcConfig.image_base_url}${player.banner}"),
                        fit: BoxFit.fill)),
              ),
            ),
            Positioned(
              top: 70,
              right: isYou ? null : 0,
              child: Row(
                children: [
                  Visibility(
                      visible: !isYou,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 100,
                            child: CcShadowedTextWidget(
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                padding: const EdgeInsets.only(right: 3),
                                dx: 1,
                                dy: 1.5,
                                text: player.username ?? "Player",
                                fontSize: 10,
                                letterSpacing: 1),
                          ),
                          Row(children: [
                            Image.asset(AssetsImages.trophy, width: 20),
                            CcShadowedTextWidget(
                                text: player.trophy.toString(), fontSize: 10),
                            const SizedBox(width: 3)
                          ])
                        ],
                      )),
                  Stack(
                    children: [
                      CcNetworkImageWidget(
                          width: 65,
                          height: 65,
                          imageUrl:
                              "${CcConfig.image_base_url}${player.avatar}"),
                      CcNetworkImageWidget(
                          width: 65,
                          height: 65,
                          imageUrl:
                              "${CcConfig.image_base_url}${player.border}"),
                      Positioned(
                        bottom: 0,
                        right: isYou ? 0 : null,
                        left: isYou ? null : 0,
                        child: CcShadowedImageBoxWidget(
                            width: 20,
                            height: 20,
                            radius: 20,
                            dx: 1,
                            dy: 1,
                            image:(player.country == null)
                              ? AssetsImages.regionIcon
                              :  (player.country?.localFlagPath == null)
                                ? "${CcConfig.image_base_url}${player.country?.flagUrl}"
                                : player.country?.localFlagPath ?? ''),
                      )
                    ],
                  ),
                  Visibility(
                      visible: isYou,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 100,
                            child: CcShadowedTextWidget(
                                padding: const EdgeInsets.only(left: 3),
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                dx: 1,
                                dy: 1.5,
                                text: player.username ?? "Player",
                                fontSize: 10,
                                letterSpacing: 1),
                          ),
                          Row(children: [
                            Image.asset(AssetsImages.trophy, width: 20),
                            CcShadowedTextWidget(
                                text: player.trophy.toString(), fontSize: 10)
                          ])
                        ],
                      ))
                ],
              ),
            ),

            /// Tarck Your Guess
            Visibility(
              visible: isYou,
              child: Positioned(
                  bottom: 5,
                  right: 25,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: provider.trackPlayerGuess == 0
                            ? Colors.grey.shade500
                            : provider.trackPlayerGuess == 1
                                ? successColor
                                : errorColor,
                        boxShadow: const [BoxShadow(offset: Offset(0.8, 0.8))]),
                  )),
            ),

            /// Tarck Player Guess
            Visibility(
              visible: !isYou,
              child: Positioned(
                  bottom: 5,
                  left: 25,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: provider.trackBotGuess == 0
                            ? Colors.grey.shade500
                            : provider.trackBotGuess == 1
                                ? successColor
                                : errorColor,
                        boxShadow: const [BoxShadow(offset: Offset(0.8, 0.8))]),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}

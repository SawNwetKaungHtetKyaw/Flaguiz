import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/battle/widgets/find_battle_button_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Battle extends StatefulWidget {
  const Battle({super.key});

  @override
  State<Battle> createState() => _BattleState();
}

class _BattleState extends State<Battle> {
  @override
  void initState() {
    super.initState();
    AudioService.instance.playMusic(MusicType.battle);
  }

  @override
  void dispose() {
    AudioService.instance.playMusic(MusicType.home);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      // final UserModel? user = userProvider.user;
      return Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: CcConstants.kH_GAME_MODE,
              child: SizedBox.expand(
                child: Image.asset(
                  AssetsImages.battleBg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: CcBackWidget(
                        image: AssetsImages.defaultBackKey,
                        margin: EdgeInsets.all(8)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      /// Battle Iconic
                      Container(
                          alignment: Alignment.center,
                          child: Image.asset(AssetsImages.battle, width: 200)),

                      const SizedBox(height: 10),

                      const CcShadowedTextWidget(
                        text: CcConstants.kBattle,
                        fontSize: 28,
                      ),

                      const FindBattleButtonWidget()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

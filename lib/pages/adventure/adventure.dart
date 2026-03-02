import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/adventure/widgets/adventure_game_type_widget.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class Adventure extends StatefulWidget {
  const Adventure({super.key});

  @override
  State<Adventure> createState() => _AdventureState();
}

class _AdventureState extends State<Adventure> {

  @override
  void initState() {
    super.initState();
    AudioService.instance.playMusic(MusicType.adventure);
  }

  @override
  void dispose() {
    AudioService.instance.playMusic(MusicType.home);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: CcConstants.kH_GAME_MODE,
            child: SizedBox.expand(
              child: Image.asset(
                AssetsImages.adventureBg,
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
                      image: AssetsImages.adventureBackKey,
                      margin: EdgeInsets.all(8)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    /// Adventure Iconic
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset(AssetsImages.adventure, width: 250)),

                    /// Adventure Title
                    const Center(
                        child: CcShadowedTextWidget(
                      text: CcConstants.kAdventure,
                      fontSize: 28,
                    )),

                    /// Game Type ListView
                    const AdventureGameTypeWidget(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

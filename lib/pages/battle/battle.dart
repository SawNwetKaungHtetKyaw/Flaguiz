import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class Battle extends StatefulWidget {
  const Battle({super.key});

  @override
  State<Battle> createState() => _BattleState();
}

class _BattleState extends State<Battle> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AssetsImages.battleBg),fit: BoxFit.cover)
        ),
        child: SafeArea(
          child: Stack(
            children: [

             const Align(
                alignment: Alignment.topLeft,
                child: CcBackWidget(image: AssetsImages.adventureBackKey),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  /// Battle Iconic
                  Container(
                      alignment: Alignment.center,
                      child: Image.asset(AssetsImages.battle, width: 250)),
              
                  /// Battle Title    
                  const Center(
                      child: CcShadowedTextWidget(
                          text: CcConstants.kBattle, fontSize: 28,strokeWidth: 3)),
              
                  /// Game Type ListView   
                  // const BattleGameTypeWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

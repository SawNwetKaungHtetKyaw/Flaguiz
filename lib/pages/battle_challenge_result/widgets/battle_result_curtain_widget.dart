import 'package:flaguiz/animations/slide_animation.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';

class BattleResultCurtainWidget extends StatefulWidget {
  const BattleResultCurtainWidget({super.key, required this.result});
  final String result;

  @override
  State<BattleResultCurtainWidget> createState() =>
      _BattleResultCurtainWidgetState();
}

class _BattleResultCurtainWidgetState extends State<BattleResultCurtainWidget>{

  @override
  Widget build(BuildContext context) {
  double height = MediaQuery.of(context).size.height;

    return SlideAnimation(
      begin: const Offset(0, -1),
      child: SizedBox(
        height: height -10,
        child: Image.asset((widget.result == CcConstants.BATTLE_DRAW)
            ? AssetsImages.battlePurpleCurtain
            : AssetsImages.battleRedCurtain, fit: BoxFit.cover),
      ),
    );
  }
}

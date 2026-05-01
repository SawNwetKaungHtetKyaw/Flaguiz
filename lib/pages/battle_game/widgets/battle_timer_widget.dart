import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_icon_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleTimerWidget extends StatelessWidget {
  const BattleTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BattleGameProvider,int>(
      selector: (p0, p1) => p1.timerCount,
      builder: (context, value, child) =>  Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10)

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CcShadowedIconWidget(
                color: Colors.white, icon: Icons.timer_outlined, size: 30),
            Container(
              width: 30,
              alignment: Alignment.center,
              child: CcShadowedTextWidget(
                text: value.toString(),
                fontSize: 14,
                textColor: value <= 5 ? Colors.red : Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

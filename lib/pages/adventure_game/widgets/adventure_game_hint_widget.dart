import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/pages/adventure_game/provider/adventure_game_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureGameHintWidget extends StatelessWidget {
  const AdventureGameHintWidget(
      {super.key, required this.adventureCompletedList, required this.coin});
  final int coin;
  final List<AdventureCompletedModel> adventureCompletedList;

  @override
  Widget build(BuildContext context) {
    return CcImageButton(
        width: double.maxFinite,
        height: 50,
        image: AssetsImages.adventureButton,
        onTap: () {
          if (coin >= 10) {
            context
                .read<AdventureGameProvider>()
                .hint(context, adventureCompletedList, coin);
            context.read<UserProvider>().reduceUserCoin(10);
          }
        },
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        widget: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CcShadowedTextWidget(
            text: CcConstants.kHint,
          ),
          CcShadowedTextWidget(
            text: ' 10 ',
            textColor: (coin < 10) ? Colors.red : Colors.white,
          ),
          const CcShadowedTextWidget(
            text: "coins",
          ),
        ]));
  }
}

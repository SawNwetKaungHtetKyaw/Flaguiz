import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/challenge_game/provider/challenge_game_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameHintWidget extends StatelessWidget {
  const ChallengeGameHintWidget(
      {super.key, required this.coin});
  final int coin;

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider,UserModel?>(
      selector: (p0, provider) => provider.user,
      builder: (context, user, child) => CcImageButton(
          width: double.maxFinite,
          height: 50,
          image: AssetsImages.challengeButton,
          onTap: () {
            if (coin >= 10) {
              context
                  .read<ChallengeGameProvider>()
                  .hint(context, coin,user?.challengeCompletedList ?? []);
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
          ])),
    );
  }
}

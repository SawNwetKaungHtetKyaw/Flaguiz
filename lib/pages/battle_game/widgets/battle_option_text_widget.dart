import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/enum/question_type.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleOptionTextWidget extends StatelessWidget {
  const BattleOptionTextWidget(
      {super.key,
      required this.country,
      required this.answerId,
      required this.type});
  final CountryModel country;
  final String answerId;
  final QuestionType type;
  @override
  Widget build(BuildContext context) {
    return Consumer<BattleGameProvider>(
        builder: (context, provider, child) => GestureDetector(
              onTap: () {
                provider.playerAnswer(country.id ?? '0');
              },
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(offset: Offset(2, 2))],
                        image: DecorationImage(
                            image: Utils.checkImageType(
                                AssetsImages.challengeButton),
                            fit: BoxFit.fill,
                            colorFilter: (provider.trackPlayerGuess != 0 &&
                                    (provider.playerAnswerId != country.id))
                                ? ColorFilter.mode(
                                    Colors.black.withValues(alpha: 0.4),
                                    BlendMode.darken,
                                  )
                                : null),
                        border: (provider.trackPlayerGuess == 0 ||
                                (provider.playerAnswerId != country.id))
                            ? null
                            : Border.all(
                                color: (provider.trackPlayerGuess == 1)
                                    ? successColor
                                    : errorColor,
                                width: 5)),
                    child: Center(
                      child: CcShadowedTextWidget(
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          wordSpacing: 0.5,
                          fontSize: 18,
                          dx: 1.5,
                          dy: 2,
                          text: type == QuestionType.capital
                              ? country.capital ?? ''
                              : country.name ?? ''),
                    ),
                  )),
            )

        // CcImageButton(
        //   onTap: () {
        //     provider.playerAnswer(country.id ?? '0');
        //   },
        //   margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
        //   width: double.maxFinite,
        //   height: 65,
        //   widget: Center(
        //     child: CcShadowedTextWidget(
        //         fontFamily: 'Roboto',
        //         letterSpacing: 0.5,
        //         wordSpacing: 0.5,
        //         fontSize: 18,
        //         dx: 1.5,
        //         dy: 2,
        //         text: type == QuestionType.capital
        //             ? country.capital ?? ''
        //             : country.name ?? ''),
        //   ),
        //   image: AssetsImages.challengeButton,
        // ),
        );
  }
}

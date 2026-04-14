import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/enum/question_type.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
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
      builder: (context, provider, child) => CcImageButton(
        onTap: () {
          provider.playerAnswer(country.id ?? '0');
        },
        margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
        width: double.maxFinite,
        height: 65,
        widget: Center(
          child: CcShadowedTextWidget(
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              wordSpacing: 0.5,
              fontSize: 18,
              dx: 1.5,
              dy: 2,
              text: type == QuestionType.country
                  ? country.name ?? ''
                  : country.capital ?? ''),
        ),
        image: AssetsImages.challengeButton,
      ),
    );
  }
}

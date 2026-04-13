import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleOptionBoxWidget extends StatelessWidget {
  const BattleOptionBoxWidget(
      {super.key, required this.country, required this.answerId});
  final CountryModel country;
  final String answerId;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<BattleGameProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: () {
          provider.playerAnswer(country.id ?? '0');
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CcShadowedImageBoxWidget(
              width: screenWidth / 2 - 13,
              height: 120,
              image: (country.localFlagPath == null)
                  ? "${CcConfig.image_base_url}${country.flagUrl}"
                  : country.localFlagPath!),
        ),
      ),
    );
  }
}

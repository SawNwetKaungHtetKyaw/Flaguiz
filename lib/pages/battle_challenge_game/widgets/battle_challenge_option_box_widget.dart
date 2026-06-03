import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/battle_challenge_game/provider/battle_challenge_game_provider.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallengeOptionBoxWidget extends StatelessWidget {
  const BattleChallengeOptionBoxWidget({
    super.key,
    required this.country,
    required this.answerId,
  });
  final CountryModel country;
  final String answerId;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<BattleChallengeGameProvider>(
      builder:
          (context, provider, child) => GestureDetector(
            onTap: () {
              provider.playerAnswer(country.id ?? '0');
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: screenWidth / 2 - 13,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(offset: Offset(2, 2))],
                  image: DecorationImage(
                    image: Utils.checkImageType(
                      (country.localFlagPath == null)
                          ? "${CcConfig.image_base_url}${country.flagUrl}"
                          : country.localFlagPath!,
                    ),
                    fit: BoxFit.fill,
                    colorFilter:
                        (provider.trackGuess != 0 &&
                                (provider.playerAnswerId != country.id))
                            ? ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.4),
                              BlendMode.darken,
                            )
                            : null,
                  ),
                  border:
                      (provider.trackGuess == 0 ||
                              (provider.playerAnswerId != country.id))
                          ? null
                          : Border.all(
                            color:
                                (provider.trackGuess == 1)
                                    ? successColor
                                    : errorColor,
                            width: 5,
                          ),
                ),
              ),
            ),
          ),
    );
  }
}

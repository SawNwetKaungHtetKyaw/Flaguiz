import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/challenge_game/provider/challenge_game_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameGuessBoxWidget extends StatefulWidget {
  const ChallengeGameGuessBoxWidget(
      {super.key,
      required this.country,
      required this.answerId,
      required this.index});
  final CountryModel country;
  final String answerId;
  final int index;

  @override
  State<ChallengeGameGuessBoxWidget> createState() =>
      _ChallengeGameGuessBoxWidgetState();
}

class _ChallengeGameGuessBoxWidgetState
    extends State<ChallengeGameGuessBoxWidget> {
  bool guessWrong = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<ChallengeGameProvider, UserProvider>(
      builder: (context, provider, userProvider, child) => Stack(
        children: [
          GestureDetector(
            onTap: () async {
              if (widget.answerId == widget.country.id) {
                AudioService.instance.playSound('correct');
                provider.goToNext(
                    context,
                    widget.answerId,
                    widget.country.id ?? '0',
                    userProvider.user?.challengeCompletedList ?? []);
              } else {
                if (mounted) {
                  await VibrationService.instance.medium();
                  provider.decreaseLife();
                  provider.addUserWrongGuesses(widget.index);
                  setState(() {
                    guessWrong = true;
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CcShadowedImageBoxWidget(
                  width: screenWidth / 2 - 13,
                  height: 120,
                  image: "${CcConfig.image_base_url}${widget.country.flagUrl}"),
            ),
          ),

          /// If user guess wrong, will show this widget
          Visibility(
            visible:
                guessWrong || provider.userWrongGuesses.contains(widget.index),
            child: Container(
              width: screenWidth / 2 - 13,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }
}

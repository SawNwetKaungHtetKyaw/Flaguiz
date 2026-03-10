import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/challenge_game/provider/challenge_game_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameGuessTextWidget extends StatefulWidget {
  const ChallengeGameGuessTextWidget(
      {super.key,
      required this.country,
      required this.answerId,
      required this.index,
      required this.mode});
  final CountryModel country;
  final String answerId;
  final int index;
  final String mode;

  @override
  State<ChallengeGameGuessTextWidget> createState() =>
      _ChallengeGameGuessTextWidgetState();
}

class _ChallengeGameGuessTextWidgetState
    extends State<ChallengeGameGuessTextWidget> {
  bool guessWrong = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChallengeGameProvider, UserProvider>(
      builder: (context, provider, userProvider, child) => Stack(
        children: [
          CcImageButton(
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
            margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
            width: double.maxFinite,
            height: 65,
            text: widget.mode == CcConfig.GAME_MODE__COUNTRY
                ? widget.country.name ?? ''
                : widget.country.capital ?? '',
            image: AssetsImages.challengeButton,
          ),

          /// If user guess wrong, will show this widget
          Visibility(
            visible:
                guessWrong || provider.userWrongGuesses.contains(widget.index),
            child: Container(
              width: double.maxFinite,
              height: 65,
              margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
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

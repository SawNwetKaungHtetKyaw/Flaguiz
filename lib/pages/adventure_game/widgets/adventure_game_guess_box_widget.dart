import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/adventure_completed_model.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/adventure_game/provider/adventure_game_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureGameGuessBoxWidget extends StatefulWidget {
  const AdventureGameGuessBoxWidget(
      {super.key,
      required this.country,
      required this.answerId,
      required this.adventureCompletedList,
      required this.index,
      required this.currentIndex});
  final CountryModel country;
  final String answerId;
  final List<AdventureCompletedModel> adventureCompletedList;
  final int index, currentIndex;

  @override
  State<AdventureGameGuessBoxWidget> createState() =>
      _AdventureGameGuessBoxWidgetState();
}

class _AdventureGameGuessBoxWidgetState
    extends State<AdventureGameGuessBoxWidget> {
  bool guessWrong = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AdventureGameProvider>(
      builder: (context, provider, child) => Stack(
        children: [
          GestureDetector(
            onTap: () async {
              if (widget.answerId == widget.country.id) {
                if (!(widget.currentIndex == provider.guessList.length - 1)) {
                  AudioService.instance.playSound('correct');
                }
                provider.goToNext(context, widget.answerId,
                    widget.country.id ?? '0', widget.adventureCompletedList);
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

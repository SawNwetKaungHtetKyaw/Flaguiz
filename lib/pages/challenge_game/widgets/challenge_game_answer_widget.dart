import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ChallengeGameAnswerWidget extends StatelessWidget {
  const ChallengeGameAnswerWidget(
      {super.key, required this.guess, required this.mode});
  final GuessModel? guess;
  final String mode;

  @override
  Widget build(BuildContext context) {
    Widget returnWidget() {
      if (mode == CcConfig.GAME_MODE__FLAG) {
        return CcShadowedTextWidget(
            fontFamily: 'Roboto',
            letterSpacing: 1,
            text: guess?.answer?.name ?? "",
            fontSize: 28,
            textAlign: TextAlign.center);
      } else if (mode == CcConfig.GAME_MODE__MAP) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CcShadowedImageBoxWidget(
            width: double.maxFinite,
            height: 250,
            image: (guess?.answer?.localMapPath == null)
                ? "${CcConfig.image_base_url}${guess?.answer?.mapUrl}"
                : guess?.answer?.localMapPath ?? '',
            boxFit: BoxFit.fill,
          ),
        );
      } else {
        return CcShadowedImageBoxWidget(
            width: 270,
            height: 180,
            image: (guess?.answer?.localFlagPath == null)
                ? "${CcConfig.image_base_url}${guess?.answer?.flagUrl}"
                : guess?.answer?.localFlagPath ?? '',
            boxFit: BoxFit.fill);
      }
    }

    return Expanded(
      child: Center(child: returnWidget()),
    );
  }
}

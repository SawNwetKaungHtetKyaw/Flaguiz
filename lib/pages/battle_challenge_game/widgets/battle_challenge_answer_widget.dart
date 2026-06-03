import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class BattleChallengeAnswerWidget extends StatelessWidget {
  const BattleChallengeAnswerWidget({super.key, required this.question});
  final BattleQuestionModel question;

  @override
  Widget build(BuildContext context) {
    // Widget returnWidget() {
    //   if (question.type == QuestionType.flag) {
    //     return CcShadowedTextWidget(
    //         fontFamily: 'Roboto',
    //         letterSpacing: 1,
    //         text: question.answer?.name ?? "",
    //         fontSize: 28,
    //         textAlign: TextAlign.center);
    //   } else if (question.type == QuestionType.map) {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 4),
    //       child: CcShadowedImageBoxWidget(
    //         width: double.maxFinite,
    //         height: 250,
    //         image: (question.answer?.localMapPath == null)
    //             ? "${CcConfig.image_base_url}${question.answer?.mapUrl}"
    //             : question.answer?.localMapPath ?? '',
    //         boxFit: BoxFit.fill,
    //       ),
    //     );
    //   } else {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 4),
    //       child: CcShadowedImageBoxWidget(
    //         width: 270,
    //         height: 180,
    //         image: (question.answer?.localFlagPath == null)
    //             ? "${CcConfig.image_base_url}${question.answer?.flagUrl}"
    //             : question.answer?.localFlagPath ?? '',
    //         boxFit: BoxFit.fill,
    //       ),
    //     );
    //   }
    // }

    return Expanded(child: Center(child: CcShadowedTextWidget(
            fontFamily: 'Roboto',
            letterSpacing: 1,
            text: question.answer?.name ?? "",
            fontSize: 28,
            textAlign: TextAlign.center)));
  }
}

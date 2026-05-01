import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/pages/battle_game/widgets/battle_answer_widget.dart';
import 'package:flaguiz/pages/battle_game/widgets/battle_option_box_widget.dart';
import 'package:flaguiz/pages/battle_game/widgets/battle_option_text_widget.dart';
import 'package:flaguiz/utils/enum/question_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BatttleGamePageviewWidget extends StatefulWidget {
  const BatttleGamePageviewWidget(
      {super.key, required this.questions, required this.controller});
  final List<BattleQuestionModel> questions;
  final PageController controller;

  @override
  State<BatttleGamePageviewWidget> createState() =>
      _BatttleGamePageviewWidgetState();
}

class _BatttleGamePageviewWidgetState extends State<BatttleGamePageviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BattleGameProvider>(
      builder: (context, provider, child) => Expanded(
        child: PageView.builder(
          controller: widget.controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.questions.length,
          itemBuilder: (context, index) {
            final question = widget.questions[index];

            return Column(
              children: [
                BattleAnswerWidget(question: question),

                /// Guess 4 Options For Flag
                Visibility(
                  visible: question.type == QuestionType.flag,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BattleOptionBoxWidget(
                              country: question.options[0],
                              answerId: question.answer.id ?? '0'),
                          const SizedBox(width: 10),
                          BattleOptionBoxWidget(
                              country: question.options[1],
                              answerId: question.answer.id ?? '0'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BattleOptionBoxWidget(
                              country: question.options[2],
                              answerId: question.answer.id ?? '0'),
                          const SizedBox(width: 10),
                          BattleOptionBoxWidget(
                              country: question.options[3],
                              answerId: question.answer.id ?? '0'),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Guess 4 Options For Country , Capital & Map
                Visibility(
                  visible: question.type == QuestionType.country ||
                      question.type == QuestionType.capital ||
                      question.type == QuestionType.map,
                  child: Column(
                    children: [
                      BattleOptionTextWidget(
                          country: question.options[0],
                          answerId: question.answer.id ?? '0',
                          type: question.type),
                      BattleOptionTextWidget(
                          country: question.options[1],
                          answerId: question.answer.id ?? '0',
                          type: question.type),
                      BattleOptionTextWidget(
                          country: question.options[2],
                          answerId: question.answer.id ?? '0',
                          type: question.type),
                      BattleOptionTextWidget(
                          country: question.options[3],
                          answerId: question.answer.id ?? '0',
                          type: question.type),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

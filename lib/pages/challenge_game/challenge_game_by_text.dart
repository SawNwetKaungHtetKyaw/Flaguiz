import 'package:flaguiz/models/guess_model.dart';
import 'package:flaguiz/pages/challenge_game/provider/challenge_game_provider.dart';
import 'package:flaguiz/pages/challenge_game/widgets/challenge_game_answer_widget.dart';
import 'package:flaguiz/pages/challenge_game/widgets/challenge_game_guess_text_widget.dart';
import 'package:flaguiz/pages/challenge_game/widgets/challenge_game_hint_widget.dart';
import 'package:flaguiz/pages/challenge_game/widgets/challenge_game_life_widget.dart';
import 'package:flaguiz/pages/challenge_game/widgets/challenge_game_you_lose_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_icon_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeGameByText extends StatefulWidget {
  const ChallengeGameByText(
      {super.key, required this.guessList, required this.mode});
  final List<GuessModel> guessList;
  final String mode;

  @override
  State<ChallengeGameByText> createState() => _ChallengeGameByTextState();
}

class _ChallengeGameByTextState extends State<ChallengeGameByText> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    AudioService.instance.pause();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChallengeGameProvider>(
      create: (context) => ChallengeGameProvider(
          buildContext: context,
          pageController: _pageController,
          guessList: widget.guessList,
          mode: widget.mode),
      builder: (context, child) =>
          Consumer2<ChallengeGameProvider, UserProvider>(
        builder: (context, provider, userProvider, child) => Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AssetsImages.challengeBg),
                    fit: BoxFit.cover)),
            child: Stack(
              children: [
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CcBackWidget(
                            image: AssetsImages.challengeBackKey,
                            onTap: () {
                              Navigator.pop(context);
                              AudioService.instance.resume();
                            },
                          ),

                          /// Adventure Life Widget
                          const ChallengeGameLifeWidget()
                        ],
                      ),

                      /// Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CcShadowedIconWidget(
                              color: Colors.white,
                              icon: Icons.timer_outlined,
                              size: 40),
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: CcShadowedTextWidget(
                              text: provider.timerCount.toString(),
                              fontSize: 14,
                              textColor: (provider.timerCount) <= 3
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          )
                        ],
                      ),

                      /// Completed Guess
                      CcShadowedTextWidget(
                          text:
                              "${provider.currentComplete + 1}/${provider.guessList.length}"),

                      Expanded(
                          child: PageView.builder(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.guessList.length,
                              itemBuilder: (context, index) {
                                GuessModel guess = provider.guessList[index];

                                /// Correct Answer for Each Guess
                                provider.setCorrectAnswerIndex =
                                    guess.countryList?.indexWhere(
                                            (u) => u.id == guess.answer!.id) ??
                                        0;
                                return Column(
                                  children: [
                                    /// Answer
                                    ChallengeGameAnswerWidget(
                                        guess: guess, mode: widget.mode),

                                    /// Guess
                                    ChallengeGameGuessTextWidget(
                                        country: guess.countryList![0],
                                        answerId: guess.answer?.id ?? "0",
                                        index: 0,
                                        mode: widget.mode),
                                    ChallengeGameGuessTextWidget(
                                        country: guess.countryList![1],
                                        answerId: guess.answer?.id ?? "0",
                                        index: 1,
                                        mode: widget.mode),
                                    ChallengeGameGuessTextWidget(
                                        country: guess.countryList![2],
                                        answerId: guess.answer?.id ?? "0",
                                        index: 2,
                                        mode: widget.mode),
                                    ChallengeGameGuessTextWidget(
                                        country: guess.countryList![3],
                                        answerId: guess.answer?.id ?? "0",
                                        index: 3,
                                        mode: widget.mode),
                                  ],
                                );
                              })),

                      /// Hint Button
                      ChallengeGameHintWidget(
                          coin: userProvider.user?.coin ?? 0)
                    ],
                  ),
                )),

                /// This Widget will show when your remaining life is over
                ChallengeGameYouLoseWidget(
                    guessList: provider.guessList,
                    currentIndex: provider.currentComplete,
                    mode: provider.mode),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

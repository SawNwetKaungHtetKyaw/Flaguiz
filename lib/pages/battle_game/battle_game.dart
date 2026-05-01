import 'package:flaguiz/bot/bot_difficulty.dart';
import 'package:flaguiz/bot/bot_model.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/pages/battle_game/provider/battle_game_provider.dart';
import 'package:flaguiz/pages/battle_game/widgets/battle_player_profile_widget.dart';
import 'package:flaguiz/pages/battle_game/widgets/battle_timer_widget.dart';
import 'package:flaguiz/pages/battle_game/widgets/batttle_game_pageview_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleGame extends StatefulWidget {
  const BattleGame(
      {super.key,
      required this.questions,
      required this.user,
      required this.bot,
      required this.botDifficulty});
  final List<BattleQuestionModel> questions;
  final BotModel user;
  final BotModel bot;
  final BotDifficulty botDifficulty;

  @override
  State<BattleGame> createState() => _BattleGameState();
}

class _BattleGameState extends State<BattleGame> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BattleGameProvider>(
      create: (context) => BattleGameProvider(
          buildContext: context,
          pageController: _controller,
          questionList: widget.questions,
          botDifficulty: BotDifficulty.medium),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Consumer2<BattleGameProvider, UserProvider>(
              builder: (context, provider, userProvider, child) {
            // UserModel? user = userProvider.user;
            if (provider.isGameEnded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.microtask(() {
                  /// Navigate
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(
                      context, RoutePaths.battleGameResult, arguments: [
                    provider.battleResult,
                    widget.user,
                    widget.bot
                  ]);
                });
              });
            }
            
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AssetsImages.battleBg),
                      fit: BoxFit.cover)),
              child: SafeArea(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Row(
                          children: [
                            /// Your Profile
                            BattlePlayerProfileWidget(
                                isYou: true,
                                player: widget.user),

                            /// Enemy Profile
                            BattlePlayerProfileWidget(
                                isYou: false,
                                player: widget.bot),
                          ],
                        ),

                        /// VS
                        const Align(
                            alignment: Alignment.bottomCenter,
                            child: CcShadowedTextWidget(
                                padding: EdgeInsets.only(top: 70),
                                text: "VS",
                                fontSize: 30))
                      ],
                    ),

                    /// Timer
                    const BattleTimerWidget(),

                    BatttleGamePageviewWidget(
                        questions: widget.questions, controller: _controller)
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

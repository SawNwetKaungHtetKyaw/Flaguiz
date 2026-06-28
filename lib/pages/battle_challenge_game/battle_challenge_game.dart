import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/models/battle_question_model.dart';
import 'package:flaguiz/pages/battle_challenge_game/provider/battle_challenge_game_provider.dart';
import 'package:flaguiz/pages/battle_challenge_game/widgets/battle_challenge_pageview_widget.dart';
import 'package:flaguiz/pages/battle_challenge_game/widgets/battle_challenge_profile_widget.dart';
import 'package:flaguiz/pages/battle_challenge_game/widgets/battle_challenge_timer_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallengeGame extends StatefulWidget {
  const BattleChallengeGame({
    super.key,
    required this.roomId,
    required this.questions,
    required this.host,
    required this.friend,
    required this.isHost,
  });
  final String roomId;
  final bool isHost;
  final List<BattleQuestionModel> questions;
  final MiniProfileModel host;
  final MiniProfileModel friend;

  @override
  State<BattleChallengeGame> createState() => _BattleChallengeGameState();
}

class _BattleChallengeGameState extends State<BattleChallengeGame> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final bool hasPremium =
        context.watch<UserProvider>().user?.hasPremium ?? false;

    return ChangeNotifierProvider<BattleChallengeGameProvider>(
      create:
          (context) => BattleChallengeGameProvider(
            buildContext: context,
            isHost: widget.isHost,
            roomId: widget.roomId,
            pageController: _controller,
            questionList: widget.questions,
            hasPremium: hasPremium
          ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Consumer2<BattleChallengeGameProvider, UserProvider>(
            builder: (context, provider, userProvider, child) {
              final room = provider.room;

              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetsImages.battleBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child:
                      (room == null)
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      /// Your Profile
                                      BattleChallengeProfileWidget(
                                        isYou: true,
                                        player: widget.host,
                                        trackProgress:
                                            widget.isHost
                                                ? room.hostProgress
                                                : room.friendProgress,
                                      ),

                                      /// Friend Profile
                                      BattleChallengeProfileWidget(
                                        isYou: false,
                                        player: widget.friend,
                                        trackProgress:
                                            widget.isHost
                                                ? room.friendProgress
                                                : room.hostProgress,
                                      ),
                                    ],
                                  ),

                                  /// VS
                                  const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CcShadowedTextWidget(
                                      padding: EdgeInsets.only(top: 70),
                                      text: "VS",
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),

                              /// Timer
                              const BattleChallengeTimerWidget(),

                              BattleChallengePageviewWidget(
                                questions: widget.questions,
                                controller: _controller,
                              ),
                            ],
                          ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

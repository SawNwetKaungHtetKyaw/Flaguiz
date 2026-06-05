import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaguiz/bot/bot_factory.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/mini_profile_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/providers/battle_provider.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/repositories/battle_repository.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BattleChallengeButtonWidget extends StatefulWidget {
  const BattleChallengeButtonWidget({
    super.key,
    required this.player,
    required this.user,
  });

  final UserModel player;
  final UserModel? user;

  @override
  State<BattleChallengeButtonWidget> createState() =>
      _BattleChallengeButtonWidgetState();
}

class _BattleChallengeButtonWidgetState
    extends State<BattleChallengeButtonWidget> {
  final BattleRepository repository = BattleRepository();

  StreamSubscription<DocumentSnapshot>? roomSubscription;

  bool isLoading = false;

  @override
  void dispose() {
    roomSubscription?.cancel();
    super.dispose();
  }

  Future<void> createBattleRoom(
    List<int> questions,
    MiniProfileModel host,
    MiniProfileModel friend,
  ) async {
    if (isLoading) return;

    isLoading = true;
    Utils.showLoadingDialog(context);

    try {
      final roomId = await repository.createChallenge(
        questions: questions,
        host: host,
        friend: friend,
      );

      bool alreadyHandled = false;

      roomSubscription = repository.roomStream(roomId).listen((event) async {
        if (!event.exists) return;

        final data = event.data() as Map<String, dynamic>;
        final status = data['status'];

        /// 1. FRIEND ACCEPTS
        if (status == "playing") {
          if (alreadyHandled) return;
          alreadyHandled = true;

          await roomSubscription?.cancel();

          if (!mounted) return;

          // Dismiss the loading dialog safely
          Utils.hideLoadingDialog(context);

          // Schedule navigation cleanly after dialog is dismissed
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed(
              RoutePaths.battleChallengeIntro,
              arguments: [roomId, host, friend,questions,true],
            );
          });
        }
        /// 2. FRIEND DECLINES
        else if (status == "declined") {
          if (alreadyHandled) return;
          alreadyHandled = true;

          await roomSubscription?.cancel();

          if (!mounted) return;

          Utils.hideLoadingDialog(context);

          Utils.showWelcomToast(context, "Friend declined!");

          await repository.deleteBattleRoom(roomId);
        }
      });

      /// 3. TIMEOUT LOGIC
      Future.delayed(const Duration(seconds: 20), () async {
        if (alreadyHandled) return;

        final doc =
            await FirebaseFirestore.instance
                .collection("battle_rooms")
                .doc(roomId)
                .get();

        if (!doc.exists) return;
        final data = doc.data() as Map<String, dynamic>;

        if (data['status'] == "pending") {
          alreadyHandled = true;
          await roomSubscription?.cancel();

          await repository.timeoutBattle(roomId);

          if (!mounted) return;
          Utils.hideLoadingDialog(context);

          Utils.showToastMessage(context, "Time Out!");

          await repository.deleteBattleRoom(roomId);
        }
      });
    } catch (e) {
      if (mounted) {
        Utils.hideLoadingDialog(context);
        Utils.showToastMessage(context, "Error!");
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BattleProvider, CountryProvider>(
      builder: (context, provider, countryProvider, child) {
        return CcOutlinedButton(
          width: 35,
          height: 35,
          color: (widget.player.isOnline ?? false) ? successColor : Colors.grey,
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.only(right: 8),
          child: Image.asset(AssetsImages.battle, color: Colors.white),
          onTap: () async {
            if (!(widget.player.isOnline ?? false)) return;
            AudioService.instance.playSound('tap');

            MiniProfileModel host = await BotFactory().createMiniProfile(
              widget.user,
            );
            MiniProfileModel friend = await BotFactory().createMiniProfile(
              widget.player,
            );

            List<int> allNumbers = List.generate(233, (i) => i + 1);
            allNumbers.shuffle();
            List<int> temp = allNumbers.sublist(0, 20);
            
            await createBattleRoom(temp, host, friend);
          },
        );
      },
    );
  }
}

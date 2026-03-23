import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flutter/material.dart';

class AdventureGameTypeWidget extends StatefulWidget {
  const AdventureGameTypeWidget({super.key});

  @override
  State<AdventureGameTypeWidget> createState() =>
      _AdventureGameTypeWidgetState();
}

class _AdventureGameTypeWidgetState extends State<AdventureGameTypeWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _offsetAnimations;
  late List<Animation<double>> _opacityAnimations;

  final int itemCount = 4;
  final List<String> gameType = [
    CcConstants.kFLAG,
    CcConstants.kCOUNTRY,
    CcConstants.kMAP,
    CcConstants.kCAPITAL
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      itemCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _offsetAnimations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(-1.5, 0), // from left side
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeOut,
            )))
        .toList();

    _opacityAnimations = _controllers
        .map((controller) => Tween<double>(
              begin: 0,
              end: 1,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeIn,
            )))
        .toList();

    // Start animations one by one
    _startSequentialAnimations();
  }

  Future<void> _startSequentialAnimations() async {
    for (int i = 0; i < itemCount; i++) {
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _offsetAnimations[index],
            child: FadeTransition(
                opacity: _opacityAnimations[index],
                child: CcImageButton(
                  image: AssetsImages.adventureButton,
                  text: gameType[index],
                  onTap: () {
                    AudioService.instance.playSound('tap');
                    Navigator.pushNamed(context, RoutePaths.adventureLevel,
                        arguments: Utils.retureGameMode(index));
                  },
                )),
          );
        },
      ),
    );
  }
}

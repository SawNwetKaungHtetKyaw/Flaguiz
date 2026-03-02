import 'package:carousel_slider/carousel_slider.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class HomeGameModeWidget extends StatefulWidget {
  final CarouselSliderController controller;

  const HomeGameModeWidget({super.key, required this.controller});

  @override
  State<HomeGameModeWidget> createState() => _HomeGameModeWidgetState();
}

class _HomeGameModeWidgetState extends State<HomeGameModeWidget> {
  final List<String> gameMode = [
    CcConstants.kAdventure,
    CcConstants.kChallenge,
    CcConstants.kBattle
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: CarouselSlider(
        carouselController: widget.controller,
        options: CarouselOptions(
          scrollPhysics: const NeverScrollableScrollPhysics(),
          height: 100,
          enlargeCenterPage: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 2),
        ),
        items: gameMode.map((mode) {
          return Center(
              child: CcShadowedTextWidget(
                  text: mode, fontSize: 20, strokeWidth: 4));
        }).toList(),
      ),
    );
  }
}

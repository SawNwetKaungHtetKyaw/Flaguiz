import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AssetsImages.battleBg),fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            Image.asset(AssetsImages.leaderboard),
            
          ],
        ),
      ),
    );
  }
}
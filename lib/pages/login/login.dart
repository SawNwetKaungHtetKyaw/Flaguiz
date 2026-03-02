import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          RiveAnimation.asset(
            'assets/animation/test.riv',
            fit: BoxFit.cover,
          ),
          SafeArea(
              child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CcBackWidget(
                  image: AssetsImages.adventureBackKey,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
              ),

              Center(child: CcShadowedTextWidget(text: CcConstants.kLogin,fontSize: 40))
            ],
          ))
        ],
      ),
    );
  }
}

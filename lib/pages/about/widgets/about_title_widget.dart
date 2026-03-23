import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class AboutTitleWidget extends StatelessWidget {
  const AboutTitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsImages.pieceLeft, width: 50),
        CcShadowedTextWidget(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            text: title,
            fontSize: 18),
        Image.asset(AssetsImages.pieceRight, width: 50),
      ],
    );
  }
}

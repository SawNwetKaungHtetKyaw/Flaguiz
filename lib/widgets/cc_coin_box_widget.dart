import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class CcCoinBoxWidget extends StatelessWidget {
  const CcCoinBoxWidget({super.key, required this.coin,this.height = 45});
  final String coin;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: height,
      padding: const EdgeInsets.only(bottom: 6,right: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetsImages.coinBox), fit: BoxFit.fill)),
      alignment: Alignment.centerRight,
      child: CcShadowedTextWidget(text: coin, textAlign: TextAlign.right,textColor: primaryColor,dx: 0,dy: 0,letterSpacing: 1),
    );
  }
}

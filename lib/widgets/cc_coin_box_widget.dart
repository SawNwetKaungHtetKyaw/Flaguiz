import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class CcCoinBoxWidget extends StatelessWidget {
  const CcCoinBoxWidget({super.key, required this.coin});
  final String coin;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 45,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.only(bottom: 2, right: 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.coinBox), fit: BoxFit.fill)),
        alignment: Alignment.centerRight,
        child: CcShadowedTextWidget(text: coin, textAlign: TextAlign.right),
      ),
    );
  }
}

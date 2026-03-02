import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class CcEnergyBoxWidget extends StatelessWidget {
  const CcEnergyBoxWidget({super.key,required this.energy});
  final String energy;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.only(bottom: 2, right: 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.energyBox), fit: BoxFit.fill)),
        alignment: Alignment.centerRight,
        child: CcShadowedTextWidget(text: energy, textAlign: TextAlign.right),
      ),
    );
  }
}

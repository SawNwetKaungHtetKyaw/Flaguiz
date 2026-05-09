import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PremiumDialog extends StatefulWidget {
  const PremiumDialog({super.key});

  @override
  State<PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends State<PremiumDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AssetsImages.premiumBox),fit: BoxFit.cover)),
        child: const  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CcShadowedTextWidget(text: 'Comming soon')
          ],
        ),
      ),
    );
  }
}

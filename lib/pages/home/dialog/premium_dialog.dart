import 'dart:io';

import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class PremiumDialog extends StatefulWidget {
  const PremiumDialog({super.key});

  @override
  State<PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends State<PremiumDialog> {
  @override
  void initState() {
    super.initState();
    _initBilling();
  }

  Future<void> _initBilling() async {
    if (Platform.isAndroid) {
      final available = await InAppPurchase.instance.isAvailable();
      print('Billing available: $available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder:
          (context, userProvider, child) => Stack(
            children: [
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetsImages.premiumBox),
                    fit: BoxFit.fill,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CcShadowedTextWidget(text: 'Coming soon')],
                ),
              ),

              /// Back Key
              Positioned(
                top: 10,
                right: 40,
                child: GestureDetector(
                  onTap: () {
                    AudioService.instance.playSound('back');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

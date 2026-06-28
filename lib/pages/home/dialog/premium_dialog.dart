import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/billing_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';

class PremiumDialog extends StatefulWidget {
  const PremiumDialog({super.key});

  @override
  State<PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends State<PremiumDialog> {
  final BillingService _billingService = BillingService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      _billingService.initialize(userProvider,context);
    });
  }

  @override
  void dispose() {
    _billingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final bool isPremiumUser = userProvider.user?.hasPremium ?? false;

        return Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Container(
              width: 300,
              height: 530,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.premiumBox),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200),

                  // Listen to Google Play Store fetching states
                  ValueListenableBuilder<bool>(
                    valueListenable: _billingService.isLoadingProduct,
                    builder: (context, isLoading, child) {
                      if (isLoading) {
                        return const CircularProgressIndicator(
                          color: Colors.amber,
                        );
                      }

                      final product = _billingService.premiumProduct;
                      if (product == null) {
                        return const CcShadowedTextWidget(
                          text: "Store unavailable. Try again later.",
                          textAlign: TextAlign.center,
                        );
                      }

                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              CcShadowedTextWidget(
                                text: "- Remove Annoying Ads",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                              CcShadowedTextWidget(
                                text: "- Unique Style on \n   leaderboard",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                              CcShadowedTextWidget(
                                text: "- Exclusive Avatar",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                              CcShadowedTextWidget(
                                text: "- Exclusive Border",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                              CcShadowedTextWidget(
                                text: "- Exclusive Background",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                              CcShadowedTextWidget(
                                text: "- Exclusive Banner",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                              CcShadowedTextWidget(
                                text: "- 2000 coins",
                                letterSpacing: 1,
                                dx: 2,
                                dy: 2,
                                fontSize: 10,
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          CcShadowedTextWidget(
                            text:
                                (isPremiumUser)
                                    ? Utils.getPremiumTimeLeft(userProvider.user?.premium?.expireDate)
                                    : "(For 30 days)",
                            letterSpacing: 1,
                          ),

                          const SizedBox(height: 15),

                          CcOutlinedButton(
                            color: Colors.amber,
                            borderColor: Colors.black,
                            child: CcShadowedTextWidget(
                              text:
                                  (isPremiumUser)
                                      ? "Premium Active"
                                      : product.price,
                              textColor: Colors.black,
                              letterSpacing: 0.5,
                              dx: 0,
                              dy: 0,
                            ),
                            onTap: () async {
                              AudioService.instance.playSound('tap');
                              if(!userProvider.isLoggedIn){
                                Utils.showToastMessage(context, "Please Login!");
                              }
                              if (isPremiumUser) return;
                              await _billingService.purchasePrepaidPlan();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
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
        );
      },
    );
  }
}

import 'dart:async';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flaguiz/providers/user_provider.dart';
import '../models/premium_model.dart';

class BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String prepaidPlanId = 'premium_monthly';

  ProductDetails? premiumProduct;

  // UI listening state to show a loading indicator while fetching store prices
  final ValueNotifier<bool> isLoadingProduct = ValueNotifier<bool>(true);

  void initialize(UserProvider userProvider, BuildContext context) {
    if (!userProvider.isLoggedIn) return;
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseList) {
      if (!context.mounted) return;
      _onPurchaseUpdate(purchaseList, userProvider, context);
    }, onError: (error) => debugPrint("Purchase Stream Error: $error"));

    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      isLoadingProduct.value = true;
      final bool available = await _iap.isAvailable();
      if (!available) {
        isLoadingProduct.value = false;
        return;
      }

      final ProductDetailsResponse response = await _iap.queryProductDetails({
        prepaidPlanId,
      });
      if (response.productDetails.isNotEmpty) {
        premiumProduct = response.productDetails.first;
      }
    } catch (e) {
      debugPrint("Error loading store product: $e");
    } finally {
      isLoadingProduct.value = false;
    }
  }

  Future<void> purchasePrepaidPlan() async {
    if (premiumProduct == null) return;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: premiumProduct!,
    );
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
    UserProvider userProvider,
    BuildContext context,
  ) async {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _handleSuccessfulPurchase(purchase, userProvider, context);
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(
    PurchaseDetails purchase,
    UserProvider userProvider,
    BuildContext context,
  ) async {
    final currentUser = userProvider.user;

    if (!userProvider.isLoggedIn) return;
    if (currentUser == null || currentUser.id == null) return;

    final DateTime dynamicExpiration = DateTime.now().add(
      const Duration(days: 30),
    );

    final PremiumModel newPremiumState = PremiumModel(
      isPremium: true,
      expireDate: dynamicExpiration,
      purchaseToken: purchase.purchaseID,
    );

    try {
      await userProvider.updateUserDataForBuyPremium(
        premium: newPremiumState,
        avatar: 'AVT_008',
        border: "BD_009",
        background: "BG_008",
        banner: "BN_007",
        coin: 2000,
      );

      List<String> temp = userProvider.user?.achievements ?? [];

      if (!temp.contains("ACHV_009")) {
        userProvider.updateUserDataForAchievement(
          "ACHV_009",
          CcConfig.ACHIEVEMENT_COIN,
        );
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder:
              (context) => const CcAchievementDialog(
                achievementId: 'ACHV_009',
                showDescription: false,
              ),
        );
      }
    } catch (e) {
      debugPrint("DB Sync Error: $e");
    }
  }

  Future<void> checkAndExpirePremium(UserProvider userProvider) async {
    final currentUser = userProvider.user;
    if (currentUser == null) return;

    if (!userProvider.isLoggedIn) return;

    if (currentUser.hasPremium == false || currentUser.premium == null) return;

    if (currentUser.premium?.expireDate == null){
      try {
          await userProvider.updateUserPremiumDataWhenExpire(
            premium: null,
          );
        } catch (e) {
          print("Failed to automatically expire premium status locally: $e");
        }
        return;
    }

    final premiumInfo = currentUser.premium!;

    if (premiumInfo.isPremium && premiumInfo.expireDate != null) {
      final DateTime now = DateTime.now();

      if (now.isAfter(premiumInfo.expireDate!)) {
        print("Subscription validity expired. Downgrading profile access...");

        final PremiumModel newPremiumState = PremiumModel(isPremium: false);

        try {
          await userProvider.updateUserPremiumDataWhenExpire(
            premium: newPremiumState,
          );
        } catch (e) {
          print("Failed to automatically expire premium status locally: $e");
        }
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    isLoadingProduct.dispose();
  }
}

import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/providers/ads_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/ads_service.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopItemDetailDialog extends StatefulWidget {
  const ShopItemDetailDialog(
      {super.key,
      required this.item,
      required this.ownList,
      required this.category});
  final ShopModel item;
  final List<String> ownList;
  final String category;

  @override
  State<ShopItemDetailDialog> createState() => _ShopItemDetailDialogState();
}

class _ShopItemDetailDialogState extends State<ShopItemDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Consumer2<UserProvider, AdsProvider>(
          builder: (context, provider, adsProvider, child) {
        UserModel? user = provider.user;
        int userCoin = user?.coin ?? 0;
        int itemPrice = widget.item.price ?? 0;
        List<String> avatars = user?.avatars ?? [];
        List<String> borders = user?.borders ?? [];
        List<String> backgrounds = user?.backgrounds ?? [];
        List<String> banners = user?.banners ?? [];

        bool hasAvatarAchv = user?.achievements!.contains('ACHV_003') ?? false;
        bool hasBackgroundAchv =
            user?.achievements!.contains('ACHV_004') ?? false;
        bool hasBorderAchv = user?.achievements!.contains('ACHV_005') ?? false;
        bool hasBannerAchv = user?.achievements!.contains('ACHV_006') ?? false;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// For Avatar
            Visibility(
              visible: widget.category == CcConstants.FIRESTORE_AVATAR,
              child: CcShadowedImageBoxWidget(
                width: 280,
                height: 280,
                radius: 100,
                image: "${CcConfig.image_base_url}${widget.item.imageUrl}",
                dx: 0,
                dy: 0,
                shadowColor: Colors.transparent,
              ),
            ),

            /// For Border
            Visibility(
              visible: widget.category == CcConstants.FIRESTORE_BORDER,
              child: CcShadowedImageBoxWidget(
                width: 280,
                height: 280,
                image: "${CcConfig.image_base_url}${widget.item.imageUrl}",
                dx: 0,
                dy: 0,
                shadowColor: Colors.transparent,
              ),
            ),

            /// For Background
            Visibility(
              visible: widget.category == CcConstants.FIRESTORE_BACKGROUND,
              child: CcShadowedImageBoxWidget(
                width: 250,
                height: 500,
                margin: const EdgeInsets.only(bottom: 10),
                image: "${CcConfig.image_base_url}${widget.item.imageUrl}",
                dx: 2,
                dy: 2,
                shadowColor: Colors.transparent,
              ),
            ),

            /// For Banner
            Visibility(
              visible: widget.category == CcConstants.FIRESTORE_BANNER,
              child: CcShadowedImageBoxWidget(
                width: double.maxFinite,
                height: 140,
                boxFit: BoxFit.cover,
                margin: const EdgeInsets.only(bottom: 20),
                image: "${CcConfig.image_base_url}${widget.item.imageUrl}",
                dx: 2,
                dy: 2,
                shadowColor: Colors.transparent,
              ),
            ),

            CcShadowedTextWidget(text: widget.item.name ?? '', fontSize: 20,textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            CcShadowedTextWidget(
                text: widget.item.subName ?? '',
                fontSize: 14,
                textColor: Colors.grey.shade300),
            CcOutlinedButton(
              onTap: () async {
                if (!widget.ownList.contains(widget.item.id)) {
                  if (itemPrice == -1) {
                    if (AdsService.instance
                        .isReady(CcAdsKey.rewardItemProgress)) {
                      AdsService.instance
                          .show(CcAdsKey.rewardItemProgress, context, () async {
                        int itemProgress = adsProvider.adsBorderProgressCount;
                        itemProgress++;
                        adsProvider.setAdsBorderProgressCount = itemProgress;
                        if (itemProgress == 5) {
                          await provider
                              .updateUserDataForBuyItem(widget.item.id ?? '');
                        }
                      });
                    } else {
                      Utils.showToastMessage(context, CcConstants.kUnavailableNow);
                    }
                  } else {
                    if (userCoin >= itemPrice) {
                      AudioService.instance.playSound('claim');
                      await provider.reduceUserCoin(itemPrice);
                      await provider
                          .updateUserDataForBuyItem(widget.item.id ?? '');
                      if (context.mounted) {
                        Navigator.of(context).pop();

                        // Start Show Achivement Dialog Section ----------------------
                        if (widget.category == CcConstants.FIRESTORE_AVATAR &&
                            avatars.length == 6 &&
                            !hasAvatarAchv) {
                          provider.updateUserDataForAchievement(
                              "ACHV_003", CcConfig.ACHIEVEMENT_COIN);
                          showDialog(
                              context: context,
                              builder: (context) => const CcAchievementDialog(
                                  achievementId: 'ACHV_003',
                                  showDescription: false));
                        } else if (widget.category ==
                                CcConstants.FIRESTORE_BORDER &&
                            borders.length == 6 &&
                            !hasBorderAchv) {
                          provider.updateUserDataForAchievement(
                              "ACHV_005", CcConfig.ACHIEVEMENT_COIN);
                          showDialog(
                              context: context,
                              builder: (context) => const CcAchievementDialog(
                                  achievementId: 'ACHV_005',
                                  showDescription: false));
                        } else if (widget.category ==
                                CcConstants.FIRESTORE_BACKGROUND &&
                            backgrounds.length == 6 &&
                            !hasBackgroundAchv) {
                          provider.updateUserDataForAchievement(
                              "ACHV_004", CcConfig.ACHIEVEMENT_COIN);
                          showDialog(
                              context: context,
                              builder: (context) => const CcAchievementDialog(
                                  achievementId: 'ACHV_004',
                                  showDescription: false));
                        } else if (widget.category ==
                                CcConstants.FIRESTORE_BANNER &&
                            banners.length == 6 &&
                            !hasBannerAchv) {
                          provider.updateUserDataForAchievement(
                              "ACHV_006", CcConfig.ACHIEVEMENT_COIN);
                          showDialog(
                              context: context,
                              builder: (context) => const CcAchievementDialog(
                                  achievementId: 'ACHV_006',
                                  showDescription: false));
                        }

                        // End Show Achivement Dialog Section ----------------------
                      }
                    } else {
                      Utils.showToastMessage(context, "Enough Coin");
                      VibrationService.instance.light();
                    }
                  }
                } else {
                  AudioService.instance.playSound('back');
                  Navigator.of(context).pop();
                }
              },
              width: double.maxFinite,
              margin: const EdgeInsets.only(top: 15, bottom: 10),
              radius: 8,
              child: (widget.ownList.contains(widget.item.id))
                  ? const CcShadowedTextWidget(text: CcConstants.kOwned)
                  : (itemPrice == -1)
                      ? CcShadowedTextWidget(
                          text: (adsProvider.adsBorderProgressCount < 5)
                              ? "${CcConstants.kAds} ${adsProvider.adsBorderProgressCount}/5"
                              : CcConstants.kClaim)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: Image.asset(AssetsImages.coin),
                            ),
                            const SizedBox(width: 3),
                            CcShadowedTextWidget(
                              text: widget.item.price.toString(),
                              textColor: (userCoin < itemPrice)
                                  ? Colors.red
                                  : Colors.white,
                            )
                          ],
                        ),
            ),
            CcOutlinedButton(
              onTap: () {
                AudioService.instance.playSound('back');
                Navigator.of(context).pop();
              },
              color: Colors.transparent,
              shadowColor: Colors.black.withOpacity(0.3),
              borderColor: primaryColor,
              child: const CcShadowedTextWidget(text: CcConstants.kClose),
            ),
          ],
        );
      }),
    );
  }
}

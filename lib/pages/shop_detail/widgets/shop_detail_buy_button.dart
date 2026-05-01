import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ShopDetailBuyButton extends StatelessWidget {
  const ShopDetailBuyButton(
      {super.key,
      required this.item,
      required this.ownList,
      required this.userCoin,
      this.color = primaryColor,
      this.disableBoxShadow = true,
      this.isBanner = false,
      this.width = 90,
      this.height = 40});
  final ShopModel item;
  final List<String> ownList;
  final int userCoin;
  final double width, height;
  final Color color;
  final bool disableBoxShadow;
  final bool isBanner;

  @override
  Widget build(BuildContext context) {
    int itemPrice = item.price ?? 0;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular( isBanner ? 5 : 8),
          color: color,
          border:Border.all(color: Colors.white),
          boxShadow: (disableBoxShadow)
              ? [const BoxShadow(offset: Offset(2, 2))]
              : null),
      alignment: Alignment.center,
      child: (ownList.contains(item.id))

          /// Owned
          ? const CcShadowedTextWidget(text: CcConstants.kOwned, fontSize: 10)
          : (itemPrice == -1)
              ? const CcShadowedTextWidget(text: CcConstants.kAds)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: isBanner ? 20 : 25,
                      width: isBanner ? 20 : 25,
                      child: Image.asset(AssetsImages.coin),
                    ),
                    const SizedBox(width: 3),
                    CcShadowedTextWidget(
                      text: item.price.toString(),
                      fontSize: isBanner ? 10 : 12,
                      textColor:
                          (userCoin < itemPrice) ? Colors.red : Colors.white,
                    )
                  ],
                ),
    );
  }
}

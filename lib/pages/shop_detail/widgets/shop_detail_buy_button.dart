import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/dialogs/shop_item_detail_dialog.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ShopDetailBuyButton extends StatelessWidget {
  const ShopDetailBuyButton(
      {super.key,
      required this.item,
      required this.ownList,
      required this.userCoin,
      required this.category,
      this.color = primaryColor,
      this.disableBoxShadow = true,
      this.width =90 , this.height = 40});
  final ShopModel item;
  final List<String> ownList;
  final int userCoin;
  final String category;
  final double width,height;
  final Color color;
  final bool disableBoxShadow;

  @override
  Widget build(BuildContext context) {
    int itemPrice = item.price ?? 0;

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.85),
            builder: (BuildContext context) => ShopItemDetailDialog(
                item: item, ownList: ownList, category: category));
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
            border: Border.all(color: Colors.white),
            boxShadow: (disableBoxShadow) ? [ const BoxShadow(offset: Offset(2, 2))] : null),
        alignment: Alignment.center,
        child: (ownList.contains(item.id))
            ? const CcShadowedTextWidget(text: CcConstants.kOwned, fontSize: 10)
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
                    text: item.price.toString(),
                    fontSize: 12,
                    textColor:
                        (userCoin < itemPrice) ? Colors.red : Colors.white,
                  )
                ],
              ),
      ),
    );
  }
}

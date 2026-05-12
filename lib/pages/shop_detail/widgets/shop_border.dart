import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/dialogs/shop_item_detail_dialog.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_detail_buy_button.dart';
import 'package:flaguiz/providers/border_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ShopBorder extends StatelessWidget {
  const ShopBorder(
      {super.key,
      required this.ownList,
      required this.category,
      required this.userCoin});
  final List<String> ownList;
  final String category;
  final int userCoin;

  @override
  Widget build(BuildContext context) {
    return Consumer<BorderProvider>(
      builder: (context, provider, child) => ValueListenableBuilder(
        valueListenable: provider.listenable(),
        builder: (context, Box<ShopModel> box, _) {
          final borders = box.values.toList();

          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: borders.length,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                final ShopModel item = borders[index];
                return GestureDetector(
                  onTap: () {
                    AudioService.instance.playSound('tap');
                    showDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.85),
                        builder: (BuildContext context) => ShopItemDetailDialog(
                            item: item, ownList: ownList, category: category));
                  },
                  child: Stack(
                    children: [
                      CcGlassWidget(
                        width: double.maxFinite,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.only(left: 4, right: 12),
                        height: 110,
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Utils.checkImageType(item
                                              .localPath ??
                                          "${CcConfig.image_base_url}${item.imageUrl}"))),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child:
                                  CcShadowedTextWidget(text: item.name ?? ''),
                            ),
                            ShopDetailBuyButton(
                                item: item,
                                ownList: ownList,
                                userCoin: userCoin)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

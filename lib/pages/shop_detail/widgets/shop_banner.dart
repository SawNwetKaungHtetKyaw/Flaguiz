import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/dialogs/shop_item_detail_dialog.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_detail_buy_button.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ShopBanner extends StatelessWidget {
  const ShopBanner(
      {super.key,
      required this.ownList,
      required this.category,
      required this.userCoin});
  final List<String> ownList;
  final String category;
  final int userCoin;

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (context, provider, child) => ValueListenableBuilder(
        valueListenable: provider.listenable(),
        builder: (context, Box<ShopModel> box, _) {
          final avatars = box.values.toList();

          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: avatars.length,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                final ShopModel item = avatars[index];
                return GestureDetector(
                  onTap: () {
                    AudioService.instance.playSound('tap');
                    showDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.85),
                        builder: (BuildContext context) => ShopItemDetailDialog(
                            item: item, ownList: ownList, category: category));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 300,
                          height: 130,
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: Utils.checkImageType(item.localPath ?? "${CcConfig.image_base_url}${item.imageUrl}"),
                                  fit: BoxFit.fill)),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ShopDetailBuyButton(
                                    width: 80,
                                    height: 30,
                                    item: item,
                                    color: Colors.black.withValues(alpha: 0.7),
                                    disableBoxShadow: false,
                                    ownList: ownList,
                                    isBanner: true,
                                    userCoin: userCoin),
                              ),
                            ],
                          )),
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

import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/dialogs/shop_item_detail_dialog.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_detail_buy_button.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ShopBackground extends StatelessWidget {
  const ShopBackground({
    super.key,
    required this.ownList,
    required this.category,
    required this.userCoin,
  });
  final List<String> ownList;
  final String category;
  final int userCoin;

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundProvider>(
      builder:
          (context, provider, child) => ValueListenableBuilder(
            valueListenable: provider.listenable(),
            builder: (context, Box<ShopModel> box, _) {
              final backgrounds = box.values.toList();

              return Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 360,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: backgrounds.length,
                  itemBuilder: (context, index) {
                    final ShopModel item = backgrounds[index];

                    return GestureDetector(
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withValues(alpha: 0.85),
                          builder:
                              (BuildContext context) => ShopItemDetailDialog(
                                item: item,
                                ownList: ownList,
                                category: category,
                              ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 260,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Utils.checkImageType(
                                  item.localPath ?? "${item.imageUrl}",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CcShadowedTextWidget(
                                text: item.name ?? '',
                                textAlign: TextAlign.center,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          ShopDetailBuyButton(
                            width: double.maxFinite,
                            item: item,
                            ownList: ownList,
                            userCoin: userCoin,
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

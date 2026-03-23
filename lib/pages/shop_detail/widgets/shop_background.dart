import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_detail_buy_button.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ShopBackground extends StatelessWidget {
  const ShopBackground(
      {super.key,
      required this.ownList,
      required this.category,
      required this.userCoin});
  final List<String> ownList;
  final String category;
  final int userCoin;

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundProvider>(
      builder: (context, provider, child) => ValueListenableBuilder(
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
                mainAxisExtent: 360),
            primary: false,
            shrinkWrap: true,
            itemCount: backgrounds.length,
            itemBuilder: (context, index) {
              final ShopModel item = backgrounds[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CcNetworkImageWidget(
                        imageUrl: "${CcConfig.image_base_url}${item.imageUrl}",
                        width: 140,
                        height: 260),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CcShadowedTextWidget(text: item.name ?? '',textAlign: TextAlign.center,letterSpacing: 1,)),
                  ),
                  ShopDetailBuyButton(
                      width: double.maxFinite,
                      item: item,
                      ownList: ownList,
                      userCoin: userCoin,
                      category: category)
                ],
              );
            },
          ));
        },
      ),
    );
  }
}

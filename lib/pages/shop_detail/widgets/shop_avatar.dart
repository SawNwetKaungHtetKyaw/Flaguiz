import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_detail_buy_button.dart';
import 'package:flaguiz/providers/avatar_provider.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ShopAvatar extends StatelessWidget {
  const ShopAvatar(
      {super.key,
      required this.ownList,
      required this.category,
      required this.userCoin});
  final List<String> ownList;
  final String category;
  final int userCoin;

  @override
  Widget build(BuildContext context) {
    return Consumer<AvatarProvider>(
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
                return Stack(
                  children: [
                    CcGlassWidget(
                      width: double.maxFinite,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(left: 4, right: 12),
                      height: 110,
                      child: Row(
                        children: [
                          CcNetworkImageWidget(imageUrl: "${CcConfig.image_base_url}${item.imageUrl}"),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CcShadowedTextWidget(text: item.name ?? ''),
                                const SizedBox(height: 5),
                                CcShadowedTextWidget(
                                  text: item.subName ?? '',
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  textColor: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                          ShopDetailBuyButton(
                              item: item,
                              ownList: ownList,
                              userCoin: userCoin,
                              category: category)
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

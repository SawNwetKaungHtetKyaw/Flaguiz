import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_detail_buy_button.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
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
                return Column(
                  children: [
                    Stack(
                      children: [
                        CcNetworkImageWidget(
                          imageUrl:
                              "${CcConfig.image_base_url}${item.imageUrl}",
                          width: double.maxFinite,
                          height: 160,
                          boxFit: BoxFit.fill,
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: ShopDetailBuyButton(
                              item: item,
                              color: Colors.black.withOpacity(0.7),
                              disableBoxShadow: false,
                              ownList: ownList,
                              userCoin: userCoin,
                              category: category),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(),
                    )
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

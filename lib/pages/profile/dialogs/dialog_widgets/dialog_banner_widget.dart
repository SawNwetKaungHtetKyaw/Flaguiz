import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogBannerWidget extends StatelessWidget {
  const DialogBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BannerProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      List<ShopModel> temp = provider.getAll();
      List<String> ownList = userProvider.user?.banners ?? [];
      final ownedSet = ownList.toSet();

      List<ShopModel> ownedItems =
          temp.where((item) => ownedSet.contains(item.id)).toList();
      return ListView.builder(
        itemCount: ownedItems.length,
        itemBuilder: (context, index) {
          ShopModel? banner = ownedItems[index];
          return GestureDetector(
            onTap: () async {
              String id = banner.id ?? '';
              ownList
                ..remove(id)
                ..insert(0, id);
              await userProvider.updatedUserBanner(ownList);
              if (context.mounted) Navigator.pop(context);
            },
            child: CcShadowedImageBoxWidget(
                width: 0,
                height: 150,
                margin: const EdgeInsets.only(bottom: 10),
                shadowColor: Colors.transparent,
                image: "${CcConfig.image_base_url}${banner.imageUrl}"),
          );
        },
      );
    });
  }
}

import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
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
          String id = banner.id ?? '';

          return GestureDetector(
            onTap: () async {
              AudioService.instance.playSound('tap');
              ownList
                ..remove(id)
                ..insert(0, id);
              await userProvider.updatedUserBanner(ownList);
              if (context.mounted) Navigator.pop(context);
            },
            child: Stack(
              children: [
                CcShadowedImageBoxWidget(
                    width: double.maxFinite,
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 10),
                    shadowColor: Colors.transparent,
                    image: "${CcConfig.image_base_url}${banner.imageUrl}"),
                Visibility(
                  visible: ownList[0] == id,
                  child: Container(
                    width: double.maxFinite,
                    height: 150,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.green.shade700, width: 3)),
                    child: Icon(Icons.check_circle,
                        color: Colors.green.shade700, size: 30),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}

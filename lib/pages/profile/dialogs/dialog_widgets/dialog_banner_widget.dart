import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GridView.builder(
          itemCount: ownedItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 70,
              crossAxisCount: 2),
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
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: ownList[0] == id ? 0.0 : 0.6),
                  BlendMode.srcATop,
                ),
                child: Image(
                  image: Utils.checkImageType(
                    banner.localPath ??
                        "${CcConfig.image_base_url}${banner.imageUrl}",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

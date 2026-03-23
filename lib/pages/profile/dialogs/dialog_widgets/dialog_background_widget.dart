import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogBackgroundWidget extends StatelessWidget {
  const DialogBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BackgroundProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      List<ShopModel> temp = provider.getAll();
      List<String> ownList = userProvider.user?.backgrounds ?? [];
      final ownedSet = ownList.toSet();

      List<ShopModel> ownedItems =
          temp.where((item) => ownedSet.contains(item.id)).toList();

      return GridView.builder(
        itemCount: ownedItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: 300,
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          ShopModel? background = ownedItems[index];
          String id = background.id ?? '';

          return GestureDetector(
            onTap: () async {
              AudioService.instance.playSound('tap');
              ownList
                ..remove(id)
                ..insert(0, id);
              await userProvider.updatedUserBackground(ownList);
              provider.getById(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: Stack(
              children: [
                CcShadowedImageBoxWidget(
                    width: 300,
                    height: 300,
                    shadowColor: Colors.transparent,
                    boxFit: BoxFit.cover,
                    image: "${CcConfig.image_base_url}${background.imageUrl}"),
                Visibility(
                  visible: ownList[0] == id,
                  child: Container(
                    width: 300,
                    height: 300,
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

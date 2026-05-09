import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/background_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
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

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GridView.builder(
          itemCount: ownedItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              mainAxisExtent: 200,
              crossAxisCount: 3),
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
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(radius),
                    image: DecorationImage(
                        image: Utils.checkImageType(background.localPath ??
                            "${CcConfig.image_base_url}${background.imageUrl}"),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: (ownList[0] == id)
                            ? Colors.transparent
                            : Colors.black54,
                        border: (ownList[0] == id)
                            ? Border.all(color: Colors.white, width: 2)
                            : Border.all(color: Colors.black, width: 2)),
                    // child: Visibility(
                    //   visible: ownList[0] == id,
                    //   child: const Icon(
                    //     Icons.check,
                    //     color: Colors.white,
                    //     size: 30,
                    //     shadows: [BoxShadow(offset: Offset(1, 1))],
                    //   ),
                    // ),
                  ),
                ));
          },
        ),
      );
    });
  }
}

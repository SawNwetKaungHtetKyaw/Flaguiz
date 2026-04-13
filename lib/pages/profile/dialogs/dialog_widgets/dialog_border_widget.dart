import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/border_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogBorderWidget extends StatelessWidget {
  const DialogBorderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BorderProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      List<ShopModel> temp = provider.getAll();
      List<String> ownList = userProvider.user?.borders ?? [];
      final ownedSet = ownList.toSet();

      List<ShopModel> ownedItems =
          temp.where((item) => ownedSet.contains(item.id)).toList();
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GridView.builder(
          itemCount: ownedItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10, crossAxisSpacing: 10, crossAxisCount: 3),
          itemBuilder: (context, index) {
            ShopModel? border = ownedItems[index];
            String id = border.id ?? '';

            return GestureDetector(
                onTap: () async {
                  AudioService.instance.playSound('tap');
                  ownList
                    ..remove(id)
                    ..insert(0, id);
                  await userProvider.updatedUserBorder(ownList);
                  if (context.mounted) Navigator.pop(context);
                },
                child: Stack(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(ownList[0] == id ? 0.0 : 0.7),
                        BlendMode.srcATop,
                      ),
                      child: Image(
                        image: Utils.checkImageType(
                          "${CcConfig.image_base_url}${border.imageUrl}",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Visibility(
                      visible: ownList[0] == id,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                          shadows: [BoxShadow(offset: Offset(1, 1))],
                        ),
                      ),
                    )
                  ],
                ));
          },
        ),
      );
    });
  }
}

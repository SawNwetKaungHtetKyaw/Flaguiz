import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/avatar_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogAvatarWidget extends StatelessWidget {
  const DialogAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AvatarProvider, UserProvider>(
        builder: (context, provider, userProvider, child) {
      List<ShopModel> temp = provider.getAll();
      List<String> ownList = userProvider.user?.avatars ?? [];
      final ownedSet = ownList.toSet();

      List<ShopModel> ownedItems =
          temp.where((item) => ownedSet.contains(item.id)).toList();
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GridView.builder(
          itemCount: ownedItems.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            ShopModel? avatar = ownedItems[index];
            String id = avatar.id ?? '';
            return GestureDetector(
                onTap: () async {
                  AudioService.instance.playSound('tap');
                  ownList
                    ..remove(id)
                    ..insert(0, id);
                  await userProvider.updatedUserAvatar(ownList);
                  if (context.mounted) Navigator.pop(context);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Utils.checkImageType(avatar.localPath ??
                          "${CcConfig.image_base_url}${avatar.imageUrl}"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: ownList[0] == id ? 0.0 : 0.7),
                        BlendMode.srcATop,
                      ),
                    ),
                  ),
                  child: Visibility(
                    visible: ownList[0] == id,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3)),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                        shadows: [BoxShadow(offset: Offset(1, 1))],
                      ),
                    ),
                  ),
                ));
          },
        ),
      );
    });
  }
}

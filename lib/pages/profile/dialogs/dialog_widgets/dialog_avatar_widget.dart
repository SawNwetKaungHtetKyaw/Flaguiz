import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/avatar_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
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
      return GridView.builder(
        itemCount: ownedItems.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          ShopModel? avatar = ownedItems[index];
          return GestureDetector(
            onTap: () async {
              String id = avatar.id ?? '';
              ownList
                ..remove(id)
                ..insert(0, id);
              await userProvider.updatedUserAvatar(ownList);
              if (context.mounted) Navigator.pop(context);
            },
            child: CcShadowedImageBoxWidget(
                width: 100,
                height: 100,
                radius: 100,
                shadowColor: Colors.transparent,
                image: "${CcConfig.image_base_url}${avatar.imageUrl}"),
          );
        },
      );
    });
  }
}

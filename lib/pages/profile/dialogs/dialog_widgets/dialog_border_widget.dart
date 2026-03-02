import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/shop_model.dart';
import 'package:flaguiz/providers/border_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
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
      return GridView.builder(
        itemCount: ownedItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10, crossAxisSpacing: 10, crossAxisCount: 3),
        itemBuilder: (context, index) {
          ShopModel? border = ownedItems[index];
          return GestureDetector(
            onTap: () async {
              String id = border.id ?? '';
              ownList
                ..remove(id)
                ..insert(0, id);
              await userProvider.updatedUserBorder(ownList);
              if (context.mounted) Navigator.pop(context);
            },
            child: CcShadowedImageBoxWidget(
                width: 100,
                height: 100,
                shadowColor: Colors.transparent,
                image: "${CcConfig.image_base_url}${border.imageUrl}"),
          );
        },
      );
    });
  }
}

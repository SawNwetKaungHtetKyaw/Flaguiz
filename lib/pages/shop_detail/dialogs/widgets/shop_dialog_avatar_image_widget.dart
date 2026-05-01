import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class ShopDialogAvatarImageWidget extends StatelessWidget {
  const ShopDialogAvatarImageWidget({super.key,required this.category, required this.imageUrl});
  final String imageUrl,category;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: category == CcConstants.FIRESTORE_AVATAR,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Utils.checkImageType(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(14),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.white, width: 5)),
        ),
      ),
    );
  }
}

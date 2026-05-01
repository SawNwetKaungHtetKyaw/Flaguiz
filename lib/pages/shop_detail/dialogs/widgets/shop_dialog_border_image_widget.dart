import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class ShopDialogBorderImageWidget extends StatelessWidget {
  const ShopDialogBorderImageWidget(
      {super.key, required this.category, required this.imageUrl});
  final String imageUrl, category;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: category == CcConstants.FIRESTORE_BORDER,
      child: Container(
        width: 200,
        height: 200,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Utils.checkImageType(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

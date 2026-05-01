import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class ShopDialogBackgroundImageWidget extends StatelessWidget {
  const ShopDialogBackgroundImageWidget(
      {super.key, required this.category, required this.imageUrl});
  final String imageUrl, category;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: category == CcConstants.FIRESTORE_BACKGROUND,
      child: Container(
                width: 250,
                height: 500,
                margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Utils.checkImageType(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.white, width: 3)),
        ),
      ),
    );
  }
}

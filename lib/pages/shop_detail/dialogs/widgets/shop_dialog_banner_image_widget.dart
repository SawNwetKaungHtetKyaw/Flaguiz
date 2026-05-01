import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class ShopDialogBannerImageWidget extends StatelessWidget {
  const ShopDialogBannerImageWidget(
      {super.key, required this.category, required this.imageUrl});
  final String imageUrl, category;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: category == CcConstants.FIRESTORE_BANNER,
      child: Container(
        width: double.maxFinite,
        height: 135,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Utils.checkImageType(imageUrl),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

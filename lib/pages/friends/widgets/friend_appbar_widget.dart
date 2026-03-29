import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSizeWidget friendAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.3),
      ),
      backgroundColor: primaryColor,
      leading: const SizedBox(),
      flexibleSpace: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CcBackWidget(image: AssetsImages.defaultBackKey),
                  CcShadowedTextWidget(
                      text: CcConstants.kFriends, fontSize: 16),
                  SizedBox(width: 60)
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
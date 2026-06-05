import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flutter/material.dart';

class FriendProfileCountryWidget extends StatelessWidget {
  const FriendProfileCountryWidget({super.key, required this.playerCountry});
  final CountryModel? playerCountry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsImages.pieceLeft, width: 30),
        CcShadowedImageBoxWidget(
            width: 55,
            height: 36,
            radius: 2,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            image: (playerCountry == null)
                ? AssetsImages.defaultCountry
                : (playerCountry?.localFlagPath == null)
                    ? "${CcConfig.image_base_url}${playerCountry?.flagUrl}"
                    : playerCountry?.localFlagPath ?? ''),
        Image.asset(AssetsImages.pieceRight, width: 30),
      ],
    );
  }
}

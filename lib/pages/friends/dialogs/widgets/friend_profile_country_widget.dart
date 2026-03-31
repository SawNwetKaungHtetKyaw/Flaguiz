import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/utils/asset_images.dart';
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
        Container(
          width: 54,
          height: 35,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: (playerCountry == null)
              ? BoxDecoration(color: Colors.grey.shade600)
              : BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          "${CcConfig.image_base_url}${playerCountry?.flagUrl}"),
                      fit: BoxFit.fill),
                  boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(2, 3))
                    ]),
          child: (playerCountry == null)
              ? const Icon(Icons.question_mark, color: Colors.white)
              : const SizedBox(),
        ),
        Image.asset(AssetsImages.pieceRight, width: 30),
      ],
    );
  }
}

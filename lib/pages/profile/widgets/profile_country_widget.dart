import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/profile/dialogs/choose_country_dialog.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileCountryWidget extends StatelessWidget {
  const ProfileCountryWidget({super.key, required this.countryId});
  final String countryId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsImages.pieceLeft, width: 50),
        GestureDetector(
          onTap: () {
            AudioService.instance.playSound('tap');
            showDialog(
                context: context,
                builder: (BuildContext context) => const ChooseCountryDialog());
          },
          child: Selector<UserProvider, CountryModel?>(
            selector: (context, provider) => provider.country,
            builder: (context, country, child) => Container(
              width: 69,
              height: 46,
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: (country == null || countryId == '')
                  ? BoxDecoration(color: Colors.grey.shade600)
                  : BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "${CcConfig.image_base_url}${country.flagUrl}"),
                          fit: BoxFit.fill),
                      boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(2, 3))
                        ]),
              child: (country == null || countryId == '')
                  ? const Icon(Icons.question_mark, color: Colors.white)
                  : const SizedBox(),
            ),
          ),
        ),
        Image.asset(AssetsImages.pieceRight, width: 50),
      ],
    );
  }
}

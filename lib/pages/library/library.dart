import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/library/widgets/library_card_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
      List<CountryModel> countryList = countryProvider.countryList;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.libraryBg),
                  fit: BoxFit.cover)),
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CcBackWidget(image: AssetsImages.libraryBackKey),
                    CcShadowedTextWidget(text: CcConstants.kLibrary,fontSize: 16),
                    SizedBox(width: 50)
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                    child: ListView.builder(
                        itemCount: countryList.length,
                        itemBuilder: (context, index) {
                          CountryModel country = countryList[index];
                          return LibraryCardWidget(
                              country: country,
                              onTap: () {
                                AudioService.instance
                                    .startSound(AssetAudios.tapSound);
                                Navigator.of(context).pushNamed(
                                    RoutePaths.countryDetail,
                                    arguments: index);
                              });
                        })),
              ],
            ),
          )),
        ),
      );
    });
  }
}

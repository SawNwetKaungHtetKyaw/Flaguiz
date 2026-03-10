import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseCountryDialog extends StatelessWidget {
  const ChooseCountryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CountryProvider, UserProvider>(
        builder: (context, provider,userProvider, child) {
      List<CountryModel> countryList = provider.countryList;
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              width: double.maxFinite,
              height: 600,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.only(
                  top: 80, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: Colors.white, width: 3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 40,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                crossAxisCount: 4),
                        itemCount: countryList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              AudioService.instance.playSound('tap');
                              userProvider.updateUserDataForCountry(countryList[index].id ?? '',countryList);
                              Navigator.of(context).pop();
                            },
                            child: CcShadowedImageBoxWidget(
                                width: 80,
                                height: 50,
                                radius: 3,
                                image:
                                    "${CcConfig.image_base_url}${countryList[index].flagUrl}"),
                          );
                        }),
                  )
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 80,
              decoration: const BoxDecoration(
                  color: primaryColor,
                  boxShadow: [BoxShadow(offset: Offset(0, 5))]),
              child: Stack(
                children: [
                  const Center(
                      child: CcShadowedTextWidget(
                          text: CcConstants.kChooseCountry, fontSize: 16)),
                  Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                          onPressed: () {
                            AudioService.instance.playSound('back');
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 30)))
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

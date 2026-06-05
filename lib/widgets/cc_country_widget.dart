import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CcCountryWidget extends StatelessWidget {
  const CcCountryWidget({
    super.key,
    required this.countryId,
    this.width = 15,
    this.height = 15,
    this.radius = 15,
    this.boxFit = BoxFit.cover,
    this.showCountryName = false,
    this.margin
  });
  final String countryId;
  final double width, height;
  final BoxFit boxFit;
  final double radius;
  final bool showCountryName;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.countryById(countryId),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.hasError) {
              return Container(
                width: width,
                height: height,
                margin: margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  image: DecorationImage(
                    image: Utils.checkImageType(AssetsImages.defaultCountry),
                    fit: boxFit,
                  ),
                ),
              );
            }

            final CountryModel country = snapshot.data!;
            return Row(
              children: [
                Container(
                  width: width,
                  height: height,
                margin: margin,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    image: DecorationImage(
                      image: Utils.checkImageType(
                        country.localFlagPath ?? country.flagUrl ?? '',
                      ),
                      fit: boxFit,
                    ),
                  ),
                ),

                Visibility(
                  visible: showCountryName,
                  child: Expanded(
                    child: CcShadowedTextWidget(
                      text: country.name ?? '',
                      letterSpacing: 1,
                      padding: EdgeInsetsGeometry.only(left: 5),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

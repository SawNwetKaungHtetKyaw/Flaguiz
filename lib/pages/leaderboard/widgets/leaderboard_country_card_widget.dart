import 'package:flaguiz/models/country_leaderboard_model.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_country_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class LeaderboardCountryCardWidget extends StatelessWidget {
  const LeaderboardCountryCardWidget({
    super.key,
    required this.index,
    required this.country,
  });
  final int index;
  final CountryLeaderboardModel country;

  @override
  Widget build(BuildContext context) {
    Widget showBadges(int index) {
      switch (index) {
        case 0:
          return Image.asset(AssetsImages.badges1, width: 40);
        case 1:
          return Image.asset(AssetsImages.badges2, width: 40);
        case 2:
          return Image.asset(AssetsImages.badges3, width: 40);
        default:
          return Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: CcShadowedTextWidget(text: "${index + 1}.", fontSize: 14),
          );
      }
    }

    return GestureDetector(
      onTap: () {
        AudioService.instance.playSound('tap');
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
        color: Colors.black45,
        child: Row(
          children: [
            showBadges(index),
            const SizedBox(width: 5),
            Expanded(
              child: CcCountryWidget(
                width: 60,
                height: 40,
                radius: 3,
                countryId: country.country,
                showCountryName: true,
              ),
            ),
            const SizedBox(width: 5),

            /// Player Trophy
            Image.asset(AssetsImages.trophy, width: 30),
            CcShadowedTextWidget(text: Utils.formatNumber(country.totalTrophy)),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

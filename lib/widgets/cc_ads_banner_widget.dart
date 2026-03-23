import 'package:flaguiz/service/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CcAdsBannerWidget extends StatelessWidget {
  final String adKey;
  final AdSize size;

  const CcAdsBannerWidget({
    super.key,
    required this.adKey,
    this.size = AdSize.fullBanner,
  });

  @override
  Widget build(BuildContext context) {
    final banner = AdsService.instance.get(adKey);

    if (!AdsService.instance.isLoaded(adKey) || banner == null) {
      return const SizedBox();
    }

    return SafeArea(
      child: SizedBox(
        width: size.width.toDouble(),
        height: size.height.toDouble(),
        child: AdWidget(ad: banner),
      ),
    );
  }
}
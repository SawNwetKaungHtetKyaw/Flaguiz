import 'package:flaguiz/service/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CcAdsBannerWidget extends StatelessWidget {
  final String adKey;
  final AdSize size;
  final bool hasPremium;

  const CcAdsBannerWidget({
    super.key,
    required this.adKey,
    required this.hasPremium,
    this.size = AdSize.fluid,
  });

  @override
  Widget build(BuildContext context) {
    final banner = AdsService.instance.get(adKey);

    if (!AdsService.instance.isLoaded(adKey) || banner == null) {
      return const SizedBox();
    }

    return Visibility(
      visible: !hasPremium,
      child: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: size == AdSize.largeBanner ? size.height.toDouble(): 50,
          child: AdWidget(ad: banner),
        ),
      ),
    );
  }
}
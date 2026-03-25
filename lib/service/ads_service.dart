import 'package:flaguiz/config/cc_ads_key.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {

  AdsService._internal();

  static final AdsService instance = AdsService._internal();

  Future<void> init() async {
    loadBannerAds(CcAdsKey.bannerAdventure);
    loadBannerAds(CcAdsKey.bannerChallenge);
    loadBannerAds(CcAdsKey.bannerCountryDetail);
    loadBannerAds(CcAdsKey.bannerShop,size: AdSize.largeBanner);
    loadBannerAds(CcAdsKey.bannerLibrary);
  }

  final Map<String, BannerAd?> _banners = {};
  final Map<String, bool> _loaded = {};
  final Map<String, RewardedAd?> _rewarded = {};
  final Map<String, bool> _isReady = {};

  /// Rewarded Ads Section
  void loadRewardedAds(String key) {
    if (_rewarded[key] != null) return; // already loaded

    RewardedAd.load(
      adUnitId: Utils.getRewardedAdUnitId(key),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewarded[key] = ad;
          _isReady[key] = true;
          print("RewardedAd loaded: $key");
        },
        onAdFailedToLoad: (error) {
          _rewarded[key] = null;
          _isReady[key] = false;
          print("RewardedAd failed to load: $key -> $error");
        },
      ),
    );
  }


  // Check if ad is ready
 bool isReady(String key) => _isReady[key] ?? false;

  // Show the ad
   void show(String key,BuildContext context, Function() onRewardEarned) {
    final ad = _rewarded[key];

    if (ad == null || _isReady[key] != true) {
      print("RewardedAd not ready:=== $key");
      return;
    }

    // Set callbacks
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print("Ad showed: $key"),
      onAdDismissedFullScreenContent: (ad) {
        print("Ad dismissed:=== $key");
        ad.dispose();
        _rewarded[key] = null;
        _isReady[key] = false;

        loadRewardedAds(key);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print("Ad failed to show:=== $key -> $error");
        Utils.showToastMessage(context, CcConstants.kUnavailableNow);
        ad.dispose();
        _rewarded[key] = null;
        _isReady[key] = false;
        loadRewardedAds(key);
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) {
        print("User earned reward: ${reward.amount}");
        onRewardEarned();
      },
    );

    // Mark ad as used immediately
    _rewarded[key] = null;
    _isReady[key] = false;
  }

  /// Banner Ads Section
  void loadBannerAds(String key, {AdSize size = AdSize.fullBanner}) {
    if (_banners[key] != null) return;

    final adUnitId = Utils.getBannerAdUnitId(key);

    final banner = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _loaded[key] = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _banners[key] = null;
          _loaded[key] = false;
        },
      ),
    );

    _banners[key] = banner;
    _loaded[key] = false;

    banner.load();
  }

  BannerAd? get(String key) => _banners[key];

  bool isLoaded(String key) => _loaded[key] ?? false;

  void dispose(String key) {
    _banners[key]?.dispose();
    _banners[key] = null;
    _loaded[key] = false;
    _rewarded[key]?.dispose();
    _rewarded[key] = null;
    _isReady[key] = false;
  }
}
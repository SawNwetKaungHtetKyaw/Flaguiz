import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/databases/country_dao.dart';
import 'package:flaguiz/service/cached_image_manager_service.dart';
import 'package:flaguiz/service/image_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import '../models/country_model.dart';

class CountryService {
  final CountryDao dao = CountryDao();
  final ImageService imageService = ImageService();

  CountryService();

  ////////////////////////////////////
  //// Download Country Images Section
  ////////////////////////////////////
  Future<List<CountryModel>> syncCountries(
    List<CountryModel> countryList,
  ) async {
    final localList = await dao.getCountries();

    final Map<String, CountryModel> localMap = {
      for (var c in localList) c.id!: c
    };

    List<CountryModel> result = [];

    const int batchSize = 5;

    for (int i = 0; i < countryList.length; i += batchSize) {
      final batch = countryList.skip(i).take(batchSize).toList();

      final futures = batch.map((country) async {
        try {
          final id = country.id;
          if (id == null) return country;

          final local = localMap[id];

          final bool needFlag = country.flagUrl != null &&
              (local?.localFlagPath == null || local!.localFlagPath!.isEmpty);

          final bool needMap = country.mapUrl != null &&
              (local?.localMapPath == null || local!.localMapPath!.isEmpty);

          final results = await Future.wait([
            if (needFlag)
              _safeDownload(
                imageService.downloadImage(
                  url: "${CcConfig.image_base_url}${country.flagUrl!}",
                  countryId: id,
                  type: "flag",
                ),
              )
            else
              Future.value(local?.localFlagPath),
            if (needMap)
              _safeDownload(
                imageService.downloadImage(
                  url: "${CcConfig.image_base_url}${country.mapUrl!}",
                  countryId: id,
                  type: "map",
                ),
              )
            else
              Future.value(local?.localMapPath),
          ]);

          country.localFlagPath = results[0];
          country.localMapPath = results[1];

          if (needFlag || needMap) {
            debugPrint("✅ ${country.name} processed");
          }

          return country;
        } catch (e) {
          /// NEVER BREAK BATCH
          debugPrint("❌ Country failed: ${country.name}");
          return country;
        }
      }).toList();

      /// Even if one fails → others continue
      final batchResult = await Future.wait(futures);
      result.addAll(batchResult);
    }

    await dao.saveCountries(result);

    return result;
  }

  Future<String?> _safeDownload(Future<String?> future) async {
    try {
      return await future;
    } catch (_) {
      return null;
    }
  }

  ////////////////////////////////////
  //// Cached Country Image Section
  ////////////////////////////////////

  Future<void> preloadImages({
    required BuildContext context,
    required List<CountryModel> countryList,
    required Function(double progress) onProgress,
  }) async {
    final urls = countryList
        .map((e) => "${CcConfig.image_base_url}${e.flagUrl}")
        .toSet()
        .toList();

    int total = urls.length;
    int completed = 0;

    const int batchSize = 6;

    for (int i = 0; i < urls.length; i += batchSize) {
      final batch = urls.skip(i).take(batchSize);

      await Future.wait(
        batch.map((url) async {
          await retryWithLimit(context, url);

          completed++;
          onProgress((completed / total).clamp(0.0, 1.0));
        }),
      );
    }
  }

  Future<void> retryWithLimit(
    BuildContext context,
    String url,
  ) async {
    int attempt = 0;

    while (attempt < 1) {
      try {
        if (!context.mounted) return;
        await precacheImage(
          CachedNetworkImageProvider(
            url,
            cacheManager: CachedImageManagerService(),
          ),
          context,
        ).timeout(const Duration(seconds: 10));

        return; // success
      } catch (_) {
        attempt++;
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    Utils.printLog("Final fail after retries: $url", important: false);
  }
}

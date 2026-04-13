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

  //// Download Country Images Section

  Future<List<CountryModel>> syncCountries(
      List<CountryModel> countryList) async {
    final localList = await dao.getCountries();

    /// Convert local list to Map (FAST lookup)
    final Map<String, CountryModel> localMap = {
      for (var c in localList) c.id!: c
    };

    List<CountryModel> result = [];

    for (final country in countryList) {
      final id = country.id;
      if (id == null) continue;

      final local = localMap[id];

      bool needsUpdate =
          local?.localFlagPath == null && local?.localMapPath == null;

      if (needsUpdate) {
        final flagPath = country.flagUrl != null
            ? await imageService.downloadImage(
                url: "${CcConfig.image_base_url}${country.flagUrl!}",
                countryId: country.id!,
                type: "flag",
              )
            : null;

        final mapPath = country.mapUrl != null
            ? await imageService.downloadImage(
                url: "${CcConfig.image_base_url}${country.mapUrl!}",
                countryId: country.id!,
                type: "map",
              )
            : null;

        country.localFlagPath = flagPath;
        country.localMapPath = mapPath;

      } else {
        country.localFlagPath = local?.localFlagPath;
        country.localMapPath = local?.localMapPath;
      }

      result.add(country);
    }

    await dao.saveCountries(result);

    return result;
  }

  //// Cached Country Image Section

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

    while (attempt < 3) {
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
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    Utils.printLog("Final fail after retries: $url",important: false);
  }
}

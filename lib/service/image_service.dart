import 'package:flaguiz/service/cached_image_manager_service.dart';

class ImageService {
  final List<String> imageUrls;
  final int batchSize;

  ImageService({
    required this.imageUrls,
    this.batchSize = 10,
  });

  Future<void> preload({
    required Function(double percent) onProgress,
  }) async {
    final cacheManager = CachedImageManagerService();
    int processed = 0;

    /// Filter only missing images
    List<String> missingImages = [];

    final cacheResults = await Future.wait(
      imageUrls.map((url) => cacheManager.getFileFromCache(url)),
    );

    for (int i = 0; i < imageUrls.length; i++) {
      if (cacheResults[i] == null) {
        missingImages.add(imageUrls[i]);
      } else {
        processed++;
      }
    }

    /// If everything cached
    if (missingImages.isEmpty) {
      for (int i = 0; i <= 100; i += 5) {
        await Future.delayed(const Duration(milliseconds: 20));
        onProgress(i.toDouble());
      }
      return;
    }

    for (int i = 0; i < missingImages.length; i += batchSize) {
      final batch = missingImages.skip(i).take(batchSize);

      await Future.wait(
        batch.map((url) async {
          await cacheManager.downloadFile(url);
          processed++;
        }),
      );

      onProgress((processed / imageUrls.length) * 100);
    }
  }
}
  // Future<void> preload({
  //   required Function(double percent) onProgress,
  //   required Function() onNoInternet,
  // }) async {
  //   final cacheManager = CachedImageManagerService();
  //   int processed = 0;

  //   for (int i = 0; i < imageUrls.length; i += batchSize) {
  //     final batch = imageUrls.skip(i).take(batchSize);

  //     await Future.wait(
  //       batch.map((url) async {
  //         final fileInfo = await cacheManager.getFileFromCache(url);

  //         if (fileInfo == null) {
  //           await cacheManager.downloadFile(url);
  //         }
  //         processed++;
  //       }),
  //     );

  //     onProgress((processed / imageUrls.length) * 100);
  //   }
  // }


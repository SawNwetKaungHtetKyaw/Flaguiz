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

    for (int i = 0; i < imageUrls.length; i += batchSize) {
      final batch = imageUrls.skip(i).take(batchSize);

      await Future.wait(
        batch.map((url) async {
          final fileInfo = await cacheManager.getFileFromCache(url);

          if (fileInfo == null) {
            await cacheManager.downloadFile(url);
          }

          processed++;
        }),
      );

      onProgress((processed / imageUrls.length) * 100);
    }
  }
}
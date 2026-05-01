import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flaguiz/utils/utils.dart';

class ImageService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  /// 🔥 Retry wrapper
  Future<T?> _retry<T>(
    Future<T> Function() task, {
    int retries = 3,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await task();
      } catch (e) {
        if (i == retries - 1) return null;

        await Future.delayed(delay * (i + 1)); // exponential-ish backoff
      }
    }
    return null;
  }

  Future<String?> downloadImage({
    required String url,
    required String countryId,
    required String type,
  }) async {
    try {
      final dirPath = await Utils.getImageDir();
      final fileName = "${countryId}_${type}_${Utils.fileNameFromUrl(url)}";

      final filePath = "$dirPath/$fileName";
      final file = File(filePath);

      /// ✅ Already cached
      if (await file.exists()) {
        return filePath;
      }

      /// 🔥 Retry download
      final result = await _retry(() async {
        final response = await _dio.download(
          url,
          filePath,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
          ),
        );

        if (response.statusCode == 200) {
          return filePath;
        }

        throw Exception("Download failed");
      });

      return result;
    } catch (e) {
      Utils.printLog("❌ Download error: $url",important: true);
      return null;
    }
  }
}

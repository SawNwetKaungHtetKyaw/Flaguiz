import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<String?> downloadCountryImage({
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
        final size = await file.length();

        if (size > 1000) {
          return filePath; // ✅ valid
        } else {
          await file.delete(); // ❌ corrupted → remove
        }
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
      Utils.printLog("❌ Download error: $url", important: true);
      return null;
    }
  }

  Future<String?> downloadImage({
    required String url,
    required String fileName,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$fileName";
      final file = File(filePath);

      // already downloaded → validate it
      if (await file.exists()) {
        final size = await file.length();

        if (size > 1000) {
          return filePath; // ✅ valid
        } else {
          await file.delete(); // ❌ corrupted → remove
        }
      }

      // download
      final response = await _dio.download(
        url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (!await file.exists()) return null;

      final size = await file.length();

      if (size < 1000) {
        await file.delete();
        return null;
      }

      final bytes = await file.readAsBytes();
      if (!_isValidImage(bytes)) {
        await file.delete();
        return null;
      }

      if (response.statusCode == 200) {
        return filePath;
      }
    } catch (e) {
      print("Download error: $e");
      return null;
    }
    return null;
  }

  bool _isValidImage(List<int> bytes) {
    if (bytes.length < 4) return false;

    // PNG
    if (bytes[0] == 137 && bytes[1] == 80 && bytes[2] == 78 && bytes[3] == 71) {
      return true;
    }

    // JPG
    if (bytes[0] == 255 && bytes[1] == 216) {
      return true;
    }

    // WEBP
    if (bytes.length > 12 &&
        bytes[0] == 82 && // R
        bytes[1] == 73 && // I
        bytes[2] == 70 && // F
        bytes[3] == 70) {
      return true;
    }

    return false;
  }
}

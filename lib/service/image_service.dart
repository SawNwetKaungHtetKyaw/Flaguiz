import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flaguiz/utils/utils.dart';

class ImageService {
  final Dio _dio = Dio();

  Future<String?> downloadImage({
    required String url,
    required String countryId,
    required String type,
  }) async {
    try {
      final dirPath = await Utils.getImageDir();
      final fileName =
          "${countryId}_${type}_${Utils.fileNameFromUrl(url)}";

      final filePath = "$dirPath/$fileName";
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      final response = await _dio.download(url, filePath);

      if (response.statusCode == 200) {
        return filePath;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteIfExists(String? path) async {
    if (path == null) return false;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  }
}
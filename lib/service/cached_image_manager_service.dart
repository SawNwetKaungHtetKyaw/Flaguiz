import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImageManagerService extends CacheManager {
  static final CachedImageManagerService _instance =
      CachedImageManagerService._internal();

  factory CachedImageManagerService() => _instance;

  CachedImageManagerService._internal()
      : super(
          Config(
            'cachedImage',
            stalePeriod: const Duration(days: 365),
            maxNrOfCacheObjects: 1000,
          ),
        );
}
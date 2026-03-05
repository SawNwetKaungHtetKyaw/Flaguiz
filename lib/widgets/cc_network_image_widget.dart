import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/service/cached_image_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CcNetworkImageWidget extends StatelessWidget {
  const CcNetworkImageWidget(
      {super.key, required this.imageUrl, this.width = 100, this.height = 100,this.radius=5,this.boxFit=BoxFit.cover});
  final String imageUrl;
  final double width, height,radius;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        cacheManager: CachedImageManagerService(),
        width: width,
        height: height,
        fit: boxFit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade400,
          highlightColor: Colors.grey.shade50,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

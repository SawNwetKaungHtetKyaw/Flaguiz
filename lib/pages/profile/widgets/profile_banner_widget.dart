import 'package:cached_network_image/cached_network_image.dart';
import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProfileBannerWidget extends StatelessWidget {
  const ProfileBannerWidget({super.key,required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(builder: (context, provider, child) {
      provider.getById(id);
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: CachedNetworkImage(imageUrl: "${CcConfig.image_base_url}${provider.banner?.imageUrl}"));
    });
  }
}

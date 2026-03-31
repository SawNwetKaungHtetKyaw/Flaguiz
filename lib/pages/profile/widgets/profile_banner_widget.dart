import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/providers/banner_provider.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProfileBannerWidget extends StatelessWidget {
  const ProfileBannerWidget(
      {super.key,
      required this.id,
      this.width = double.maxFinite,
      this.height = 165,
      this.padding = const EdgeInsets.symmetric(vertical: 10)});
  final String id;
  final double width, height;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(builder: (context, provider, child) {
      provider.getById(id);
      return Padding(
        padding: padding,
        child: CcNetworkImageWidget(
            width: width,
            height: height,
            imageUrl: "${CcConfig.image_base_url}${provider.banner?.imageUrl}",
            boxFit: BoxFit.fill),
      );
    });
  }
}

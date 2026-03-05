import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/providers/avatar_provider.dart';
import 'package:flaguiz/providers/border_provider.dart';
import 'package:flaguiz/widgets/cc_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CcProfileImageWidget extends StatelessWidget {
  const CcProfileImageWidget(
      {super.key, this.size = 100, required this.avatar, required this.border});
  final double size;
  final String avatar;
  final String border;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AvatarProvider, BorderProvider>(
        builder: (context, avatarProvider, borderProvider, child) {
          avatarProvider.getById(avatar);
          borderProvider.getById(border);
      return Stack(
        children: [
          CcNetworkImageWidget(
            width: size,
            height: size,
            imageUrl: "${CcConfig.image_base_url}${avatarProvider.avatar?.imageUrl}"),
          CcNetworkImageWidget(
            width: size,
            height: size,
            imageUrl: "${CcConfig.image_base_url}${borderProvider.border?.imageUrl}"),
        ],
      );
    });
  }
}

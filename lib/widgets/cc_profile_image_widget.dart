import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/providers/avatar_provider.dart';
import 'package:flaguiz/providers/border_provider.dart';
import 'package:flaguiz/utils/utils.dart';
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
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Utils.checkImageType(avatarProvider
                                .avatar?.localPath ==
                            null
                        ? "${CcConfig.image_base_url}${avatarProvider.avatar?.imageUrl}"
                        : avatarProvider.avatar?.localPath ?? ''))),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Utils.checkImageType(borderProvider
                                .border?.localPath ==
                            null
                        ? "${CcConfig.image_base_url}${borderProvider.border?.imageUrl}"
                        : borderProvider.border?.localPath ?? ''))),
          ),
        ],
      );
    });
  }
}

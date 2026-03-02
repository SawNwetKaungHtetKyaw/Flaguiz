import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_title_text_widget.dart';
import 'package:flutter/material.dart';

class ProfileTrophyWidget extends StatelessWidget {
  const ProfileTrophyWidget({
    super.key,
    required this.trophy,
  });

  final int trophy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AssetsImages.trophy,width: 40),
        const SizedBox(width: 10),
        CcTitleTextWidget(text: trophy.toString(),fontSize: 12,)
      ],
    );
  }
}

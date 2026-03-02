import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';

class HomeGameButtonWidget extends StatelessWidget {
  final String backgroundImage;
  final Function onTap;
  final double width, height;
  final EdgeInsets? margin;
  const HomeGameButtonWidget(
      {super.key,
      required this.onTap,
      this.backgroundImage = AssetsImages.enterButton,
      this.width = 140,
      this.height = 140,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        AudioService.instance.startSound(AssetAudios.tapSound);
        onTap();
      },
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(backgroundImage))),
        alignment: Alignment.center,
      ),
    );
  }
}

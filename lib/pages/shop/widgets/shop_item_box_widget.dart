
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_audios.dart';
import 'package:flutter/material.dart';

class ShopItemBoxWidget extends StatelessWidget {
  const ShopItemBoxWidget({
    super.key,
    required this.image,
    required this.heroTag,
    required this.onTap
  });
  final String image,heroTag;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AudioService.instance.startSound(AssetAudios.tapSound);
        onTap();},
      child: Hero(
        tag: heroTag,
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(right: 15,left: 15),
            child: Image.asset(image)),
      ),
    );
  }
}

import 'package:flaguiz/service/audio_service.dart';
import 'package:flutter/material.dart';

class CcBackWidget extends StatelessWidget {
  const CcBackWidget({super.key, required this.image, this.margin,this.onTap});

  final String image;
  final EdgeInsets? margin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AudioService.instance.playSound('back');
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 50,
        height: 50,
        margin: margin,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
      ),
    );
  }
}

import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/achievement_model.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class AchievementDialog extends StatelessWidget {
  const AchievementDialog({super.key,required this.achievement});
  final AchievementModel achievement;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CcShadowedImageBoxWidget(width: 300, height: 300, image: achievement.imageUrl ?? ''),
          const SizedBox(height: 25),
          CcShadowedTextWidget(text: achievement.name ?? '',fontSize: 20,textAlign: TextAlign.center),
          const SizedBox(height: 20),
          CcShadowedTextWidget(text: achievement.message ?? '',textAlign: TextAlign.center,textColor: Colors.grey.shade300,),
          const SizedBox(height: 20),
          CcOutlinedButton(child: const CcShadowedTextWidget(text: CcConstants.kClose), onTap: (){
            Navigator.of(context).pop();
          })
        ],
      ),
    );
  }
}
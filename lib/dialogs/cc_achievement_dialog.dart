import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/achievement_model.dart';
import 'package:flaguiz/providers/achievement_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CcAchievementDialog extends StatefulWidget {
  const CcAchievementDialog(
      {super.key, required this.achievementId, this.showDescription = true});
  final String achievementId;
  final bool showDescription;

  @override
  State<CcAchievementDialog> createState() => _CcAchievementDialogState();
}

class _CcAchievementDialogState extends State<CcAchievementDialog> {
  @override
  void initState() {
    super.initState();
    AchievementProvider achievementProvider =
        Provider.of<AchievementProvider>(context, listen: false);
    achievementProvider.getAchievement(widget.achievementId);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AchievementProvider, AchievementModel?>(
      selector: (context, provider) => provider.achc,
      builder: (context, achievement, child) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CcShadowedImageBoxWidget(
                width: 300, height: 300, image: achievement?.imageUrl ?? ''),
            const SizedBox(height: 25),
            CcShadowedTextWidget(
                text: achievement?.name ?? '',
                fontSize: 20,
                textAlign: TextAlign.center),
            const SizedBox(height: 15),
            Visibility(
                visible: widget.showDescription,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CcShadowedTextWidget(
                    text: achievement?.message ?? '',
                    textAlign: TextAlign.center,
                    letterSpacing: 1,
                    fontSize: 10,
                    textColor: Colors.grey.shade300,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CcShadowedTextWidget(text: 'Reward'),
                const SizedBox(width: 5),
                Image.asset(
                  AssetsImages.coin,
                  width: 30,
                ),
                (widget.showDescription == true)
                    ? const CcShadowedTextWidget(text: '200')
                    : const CcShadowedTextWidget(text: '+200'),
              ],
            ),
            const SizedBox(height: 20),
            CcOutlinedButton(
                child: const CcShadowedTextWidget(text: CcConstants.kClose),
                onTap: () {
                  AudioService.instance.playSound('back');
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}

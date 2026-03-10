import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/dialogs/cc_achievement_dialog.dart';
import 'package:flaguiz/models/achievement_model.dart';
import 'package:flaguiz/providers/achievement_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileAchivementWidget extends StatelessWidget {
  const ProfileAchivementWidget({super.key, required this.achievements});
  final List<String> achievements;

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementProvider>(builder: (context, provider, child) {
      List<AchievementModel> achvList = provider.achvList;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetsImages.pieceLeft, width: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: CcShadowedTextWidget(
                      text: CcConstants.kAchievement, fontSize: 14),
                ),
                Image.asset(AssetsImages.pieceRight, width: 50),
              ],
            ),
            const SizedBox(height: 25),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  mainAxisExtent: 200),
              itemCount: achvList.length,
              itemBuilder: (context, index) {
                AchievementModel achv = achvList[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AudioService.instance.playSound('tap');
                        showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.8),
                            builder: (BuildContext context) =>
                                CcAchievementDialog(
                                  achievementId: achv.id ?? 'ACHV_001',
                                ));
                      },
                      child: Stack(children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image:
                                      Utils.checkImageType(achv.imageUrl ?? ''),
                                  fit: BoxFit.fill),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black, offset: Offset(2, 2))
                              ]),
                        ),
                        Visibility(
                          visible: !achievements.contains(achv.id),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.8)),
                          ),
                        )
                      ]),
                    ),
                    Expanded(
                        child: Center(
                            child: CcShadowedTextWidget(
                      text: achv.name ?? '',
                      textAlign: TextAlign.center,
                    )))
                  ],
                );
              },
            )
          ],
        ),
      );
    });
  }
}

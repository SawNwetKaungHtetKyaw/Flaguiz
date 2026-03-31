import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/achievement_model.dart';
import 'package:flaguiz/providers/achievement_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendProfileAchievementWidget extends StatelessWidget {
  const FriendProfileAchievementWidget(
      {super.key, required this.playerAchievements});
  final List<String> playerAchievements;

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementProvider>(builder: (context, provider, child) {
      List<AchievementModel> achvList = provider.achvList;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetsImages.pieceLeft, width: 30),
              const CcShadowedTextWidget(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  text: CcConstants.kAchievement,
                  fontSize: 14),
              Image.asset(AssetsImages.pieceRight, width: 30),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achvList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              AchievementModel achv = achvList[index];
              return Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: Utils.checkImageType(achv.imageUrl ?? ''),
                      fit: BoxFit.fill,
                      colorFilter:!playerAchievements.contains(achv.id) ? ColorFilter.mode(
                        Colors.black.withOpacity(0.7),
                        BlendMode.darken,
                      ) : null,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(2, 2))
                    ]),
              );
            },
          )
        ],
      );
    });
  }
}

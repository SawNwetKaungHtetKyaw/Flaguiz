import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/adventure_model.dart';
import 'package:flaguiz/pages/adventure/provider/adventure_provider.dart';
import 'package:flaguiz/pages/adventure/widgets/adventure_level_widget.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdventureLevel extends StatefulWidget {
  const AdventureLevel({super.key, required this.mode});
  final String mode;

  @override
  State<AdventureLevel> createState() => _AdventureLevelState();
}

class _AdventureLevelState extends State<AdventureLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.adventureBg),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CcBackWidget(image: AssetsImages.adventureBackKey),
                    CcShadowedTextWidget(
                        text: CcConstants.kAdventure, fontSize: 20),
                    SizedBox(width: 50)
                  ],
                ),
              ),
              Consumer<AdventureProvider>(
                  builder: (context, provider, child) {
                List<AdventureModel> levelList = provider.levelList;
    
                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: levelList.length,
                        itemBuilder: (context, index) {
                          final AdventureModel adventureModel =
                              levelList[index];
    
                          return AdventureLevelWidget(
                            mode: widget.mode,
                            adventureModel: adventureModel,
                          );
                        }));
              })
            ],
          ),
        ),
      ),
    );
  }
}

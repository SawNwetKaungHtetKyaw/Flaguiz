import 'package:flaguiz/pages/home/dialog/setting_dialog.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';

class HomeSettingWidget extends StatefulWidget {
  const HomeSettingWidget({super.key});

  @override
  State<HomeSettingWidget> createState() => _HomeSettingWidgetState();
}

class _HomeSettingWidgetState extends State<HomeSettingWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => const SettingDialog());
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(AssetsImages.settingIcon))),
        ));
  }
}

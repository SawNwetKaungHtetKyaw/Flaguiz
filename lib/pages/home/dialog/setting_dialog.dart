import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/service/vibration_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  bool isSoundOn = AudioService.instance.isSoundOn;
  bool isMusicOn = AudioService.instance.isMusicOn;
  bool isVibration = VibrationService.instance.isVibrationOn;

  void _toggleSound(bool value) async {
    setState(() {
      isSoundOn = value;
    });
    await AudioService.instance.setSound(isSoundOn);
  }

  void _toggleMusic(bool value) async {
    setState(() {
      isMusicOn = value;
    });
    await AudioService.instance.setMusic(isMusicOn);
  }

  void _toggleVibration(bool value) async {
    setState(() {
      isVibration = value;
    });
    await VibrationService.instance.setVibraion(isVibration);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: 450,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            padding: const EdgeInsets.only(
                top: 90, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(color: Colors.white, width: 3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Volume Toggle
                SettingWithSwitch(
                  text: CcConstants.kVolume,
                  toggleValue: isSoundOn,
                  onChanged: (value) => _toggleSound(value),
                ),

                /// Music Toggle
                SettingWithSwitch(
                  text: CcConstants.kMusic,
                  toggleValue: isMusicOn,
                  onChanged: (value) => _toggleMusic(value),
                ),

                /// Vibration Toggle
                SettingWithSwitch(
                  text: CcConstants.kVibration,
                  toggleValue: isVibration,
                  onChanged: (value) => _toggleVibration(value),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 30),
                  child: Divider(),
                ),

                /// Privacy & Policies
                GestureDetector(
                  onTap: (){
                    AudioService.instance.playSound('tap');
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RoutePaths.privacyPolicies);
                  },
                  child: const CcShadowedTextWidget(text: CcConstants.kPrivacyPolicies)),

                  const SizedBox(height: 20,),

                /// Term & Conditions
                GestureDetector(
                  onTap: (){
                    AudioService.instance.playSound('tap');
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RoutePaths.termsConditions);
                  },
                  child: const CcShadowedTextWidget(text: CcConstants.kTermsAndConditions)),

                const SizedBox(height: 20),

                /// About
                GestureDetector(
                    onTap: () {
                      AudioService.instance.playSound('tap');
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RoutePaths.about);
                    },
                    child: const CcShadowedTextWidget(text: CcConstants.kAbout))
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 90,
            decoration: const BoxDecoration(
                color: primaryColor,
                boxShadow: [BoxShadow(offset: Offset(0, 5))]),
            child: Stack(
              children: [
                const Center(
                    child: CcShadowedTextWidget(
                        text: CcConstants.kSetting, fontSize: 25)),
                Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                        onPressed: () {
                          AudioService.instance.playSound('back');
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 30)))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingWithSwitch extends StatelessWidget {
  const SettingWithSwitch(
      {super.key,
      required this.text,
      required this.toggleValue,
      required this.onChanged});
  final bool toggleValue;
  final String text;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CcShadowedTextWidget(text: text, fontSize: 15),
        const Spacer(),
        Switch(
          activeColor: Colors.white,
          activeTrackColor: primaryColor,
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            return Colors.white;
          }),
          value: toggleValue,
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}

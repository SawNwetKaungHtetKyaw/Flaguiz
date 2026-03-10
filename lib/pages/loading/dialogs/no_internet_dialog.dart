import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key, required this.onTap});
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: 250,
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
                const CcShadowedTextWidget(text: CcConstants.kcheckInternet,textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                CcOutlinedButton(
                    child:
                        const CcShadowedTextWidget(text: CcConstants.kTryAgain),
                    onTap: () => onTap())
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 80,
            decoration: const BoxDecoration(
                color: primaryColor,
                boxShadow: [BoxShadow(offset: Offset(0, 5))]),
            child: const Center(
                child: CcShadowedTextWidget(
                    text: CcConstants.kNoInternet, fontSize: 18)),
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

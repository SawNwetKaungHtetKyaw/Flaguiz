import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class AlreadyAccountDialog extends StatelessWidget {
  const AlreadyAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: 280,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            padding: const EdgeInsets.only(
                top: 110, left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(color: Colors.white, width: 3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CcShadowedTextWidget(
                  text: CcConstants.kAlreadyExist,
                  fontSize: 11,
                  letterSpacing: 1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const CcShadowedTextWidget(
                  text: CcConstants.kAccWarning,
                  fontSize: 10,
                  fontFamily: 'Roboto',
                  letterSpacing: 1,
                  dx: 1,
                  dy: 1,
                  textColor: warningColor,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: CcOutlinedButton(
                            color: Colors.grey.shade900,
                            child: const CcShadowedTextWidget(
                                text: CcConstants.kCancel),
                            onTap: () {
                              AudioService.instance.playSound('back');
                              Navigator.pop(context, false);
                            })),
                    const SizedBox(width: 10),
                    Expanded(
                        child: CcOutlinedButton(
                            child: const CcShadowedTextWidget(
                                text: CcConstants.kLogin),
                            onTap: () {
                              AudioService.instance.playSound('tap');
                              Navigator.pop(context, true);
                            })),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 90,
            decoration: const BoxDecoration(
                color: primaryColor,
                boxShadow: [BoxShadow(offset: Offset(0, 5))]),
            child: const Center(
                child: CcShadowedTextWidget(
                    text: CcConstants.kAccountFound, fontSize: 18)),
          )
        ],
      ),
    );
  }
}

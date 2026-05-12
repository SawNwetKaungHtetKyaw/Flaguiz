import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      content: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: 250,
            padding: const EdgeInsets.only(
              top: 110,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CcShadowedTextWidget(
                  text: CcConstants.kDoYouWantToExit,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CcOutlinedButton(
                        color: Colors.grey.shade900,
                        child: const CcShadowedTextWidget(
                          text: CcConstants.kClose,
                        ),
                        onTap: () {
                          AudioService.instance.playSound('back');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CcOutlinedButton(
                        child: const CcShadowedTextWidget(
                          text: CcConstants.kExit,
                        ),
                        onTap: () {
                          AudioService.instance.playSound('tap');
                          SystemNavigator.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 90,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              boxShadow: [BoxShadow(offset: Offset(0, 5))],
            ),
            child: Stack(
              children: [
                const Center(
                  child: CcShadowedTextWidget(
                    text: CcConstants.kExit,
                    fontSize: 25,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                    onPressed: () {
                      AudioService.instance.playSound('back');
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

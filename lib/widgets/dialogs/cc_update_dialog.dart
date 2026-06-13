import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CcUpdateDialog extends StatefulWidget {
  const CcUpdateDialog({super.key, required this.version});
  final String version;

  @override
  State<CcUpdateDialog> createState() => _CcUpdateDialogState();
}

class _CcUpdateDialogState extends State<CcUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: false,
          child: Dialog(
            child: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 280,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  padding: const EdgeInsets.only(
                    top: 80,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CcShadowedTextWidget(
                            text: "New version ",
                            letterSpacing: 1,
                          ),
                          CcShadowedTextWidget(
                            text: "(${widget.version})",
                            letterSpacing: 1,
                            textColor: primaryLightColor,
                          ),
                        ],
                      ),
                      CcShadowedTextWidget(
                        text: " is available now.",
                        letterSpacing: 1,
                        padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                      ),
                      CcShadowedTextWidget(
                        text: "Please update!",
                        letterSpacing: 1,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: CcOutlinedButton(
                              child: CcShadowedTextWidget(text: "Later"),
                              onTap: () {
                                AudioService.instance.playSound('back');
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CcOutlinedButton(
                              child: CcShadowedTextWidget(text: "Update"),
                              onTap: () {
                                AudioService.instance.playSound('tap');
                                final url =
                                    "https://play.google.com/store/apps/details?id=com.caffeinecup.flaguiz";
                                launchUrl(Uri.parse(url));
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
                  height: 80,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    boxShadow: [BoxShadow(offset: Offset(0, 5))],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: CcShadowedTextWidget(
                          text: "Update Available",
                          fontSize: 14,
                        ),
                      ),
                      Positioned(
                        right: 1,
                        child: IconButton(
                          onPressed: () {
                            AudioService.instance.playSound('back');
                            Navigator.pop(context, false);
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
          ),
        );
      },
    );
  }
}

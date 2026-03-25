import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CcDeleteAccountDialog extends StatefulWidget {
  const CcDeleteAccountDialog({super.key});

  @override
  State<CcDeleteAccountDialog> createState() => _CcDeleteAccountDialogState();
}

class _CcDeleteAccountDialogState extends State<CcDeleteAccountDialog> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final ValueNotifier<bool> isValid = ValueNotifier(false);

    return Consumer<UserProvider>(builder: (context, provider, child) {
      return PopScope(
        canPop: false,
        child: Dialog(
          child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: 400,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.only(
                    top: 80, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    border: Border.all(color: Colors.white, width: 3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: errorColor, size: 80),
                    const SizedBox(height: 10),
                    const CcShadowedTextWidget(
                      text: 'This action is permanent. Continue?',
                      fontSize: 12,
                      letterSpacing: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
        
                    /// Confirm Text
                    const CcShadowedTextWidget(
                      text: 'Type "CONFIRM" to delete your account.',
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      letterSpacing: 1,
                      dx: 1,
                      dy: 1,
                      textColor: errorColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
        
                    /// Text Field
                    Container(
                      width: double.infinity,
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(offset: Offset(2, 2), color: primaryColor),
                        BoxShadow(
                            offset: Offset(-1, -1), color: primaryLightColor),
                      ]),
                      alignment: Alignment.center,
                      child: TextField(
                        autofocus: true,
                        controller: textEditingController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Roboto'),
                        onChanged: (value) {
                          isValid.value = value.trim() == "CONFIRM";
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type "CONFIRM"',
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CcOutlinedButton(
                              child: const CcShadowedTextWidget(
                                  text: CcConstants.kCancel),
                              onTap: () {
                                AudioService.instance.playSound('tap');
                                Navigator.pop(context,false);
                              }),
                        ),
                        const SizedBox(width: 10),
                        ValueListenableBuilder<bool>(
                          valueListenable: isValid,
                          builder: (_, valid, __) {
                            return Expanded(
                              child: CcOutlinedButton(
                                  color: valid ? errorColor : Colors.black45,
                                  child: CcShadowedTextWidget(
                                    textColor: valid ? Colors.white : Colors.grey.shade500,
                                      text: CcConstants.kConfirm),
                                  onTap: () async {
                                    if (valid) {
                                      AudioService.instance.playSound('tap');
                                      Navigator.pop(context,true);
                                    }
                                  }),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 80,
                decoration: const BoxDecoration(
                    color: primaryColor,
                    boxShadow: [BoxShadow(offset: Offset(0, 5))]),
                child: Stack(
                  children: [
                    const Center(
                        child: CcShadowedTextWidget(
                            text: CcConstants.kComfirmDelete, fontSize: 14)),
                    Positioned(
                        right: 1,
                        child: IconButton(
                            onPressed: () {
                              AudioService.instance.playSound('back');
                              Navigator.pop(context,false);
                            },
                            icon: const Icon(Icons.close,
                                color: Colors.white, size: 30)))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

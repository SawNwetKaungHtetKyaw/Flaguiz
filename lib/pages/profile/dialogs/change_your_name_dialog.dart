import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeYourNameDialog extends StatefulWidget {
  const ChangeYourNameDialog({super.key, required this.userName});
  final String userName;

  @override
  State<ChangeYourNameDialog> createState() => _ChangeYourNameDialogState();
}

class _ChangeYourNameDialogState extends State<ChangeYourNameDialog> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController =
        TextEditingController(text: widget.userName);
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Dialog(
        child: Stack(
          children: [
            Container(
              width: double.maxFinite,
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.only(
                  top: 90, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: Colors.white, width: 3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 55,
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
                      textAlignVertical:
                          TextAlignVertical.center,
                          maxLength: 12,
                          
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: CcConstants.kEnterName,
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
                                text: CcConstants.kClose),
                            onTap: () {
                              AudioService.instance.playSound('tap');
                              Navigator.of(context).pop();
                            }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CcOutlinedButton(
                            child: const CcShadowedTextWidget(
                                text: CcConstants.kConfirm),
                            onTap: () async{
                              AudioService.instance.playSound('tap');
                                 await provider.updateUserDataForUsername(textEditingController.text);
                                 if(context.mounted) Navigator.pop(context);
                            }),
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
                          text: CcConstants.kChangeYourName, fontSize: 14)),
                  Positioned(
                      right: 1,
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
    });
  }
}

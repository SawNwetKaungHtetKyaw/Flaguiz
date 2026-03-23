import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class AboutContactUsWidget extends StatelessWidget {
  const AboutContactUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const CcShadowedTextWidget(text: CcConstants.kContactUs, fontSize: 18),
        const SizedBox(height: 10),
        IconButton(
            onPressed: () async {
              await Utils.openSendMail(context);
            },
            icon: CcGlassWidget(
              width: 300,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail, size: 60, color: Colors.white),
                  const CcShadowedTextWidget(text: CcConstants.kMail),
                  const SizedBox(height: 5),
                  CcShadowedTextWidget(
                    text: CcConfig.companyMail,
                    fontFamily: "Roboto",
                    fontSize: 14,
                    letterSpacing: 1,
                  )
                ],
              ),
            )),
      ],
    );
  }
}

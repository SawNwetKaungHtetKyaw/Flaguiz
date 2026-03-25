import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
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
        ContactUsBoxWidget(
          title: CcConstants.kMail,
          value: CcConfig.companyMail,
          image: AssetsImages.mailIcon,
          onTap: () async {
            await Utils.openSendMail(context);
          },
        ),
        const SizedBox(height: 10),
        ContactUsBoxWidget(
          title: CcConstants.kWebsite,
          value: '',
          image: AssetsImages.webIcon,
          onTap: () async {
            await Utils.openLink(CcConfig.WEBSITE_URL, context);
          },
        ),
      ],
    );
  }
}

class ContactUsBoxWidget extends StatelessWidget {
  const ContactUsBoxWidget({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,
    required this.value,
  });
  final Function onTap;
  final String image, title, value;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          AudioService.instance.playSound('tap');
          onTap();
        },
        icon: CcGlassWidget(
          width: 300,
          height: value == '' ? 130 : 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CcShadowedImageBoxWidget(
                width: 50,
                height: 50,
                image: image,
                radius: 0,
                dx: 0,
                dy: 0,
                shadowColor: Colors.transparent,
              ),
              const SizedBox(
                height: 10,
              ),
              CcShadowedTextWidget(text: title),
              const SizedBox(height: 5),
              value == '' ? const SizedBox() : CcShadowedTextWidget(
                text: value,
                fontFamily: "Roboto",
                fontSize: 14,
                letterSpacing: 1,
              )
            ],
          ),
        ));
  }
}

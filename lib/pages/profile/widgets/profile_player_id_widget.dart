import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ProfilePlayerIdWidget extends StatelessWidget {
  const ProfilePlayerIdWidget({super.key,required this.playerId});
  final String playerId;

  @override
  Widget build(BuildContext context) {
    return CcShadowedTextWidget(
        text: "ID : $playerId",
        fontSize: 11,
        fontFamily: 'Roboto',
        letterSpacing: 1,
        dx: 1.5,
        dy: 1.5,
        textColor: const Color.fromARGB(255, 181, 181, 181));
  }
}

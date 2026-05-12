import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class LeaderboardTabWidget extends StatelessWidget {
  const LeaderboardTabWidget(
      {super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(child: CcShadowedTextWidget(text: title, fontSize: 12,letterSpacing: 1,));
  }
}

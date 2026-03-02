import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/widgets/cc_profile_provider.dart';
import 'package:flutter/material.dart';

class HomeProfileWidget extends StatelessWidget {
  const HomeProfileWidget({super.key,required this.avatarId,required this.borderId});
  final String avatarId;
  final String borderId;

  @override
  Widget build(BuildContext context) {

    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RoutePaths.profile);
      },
      child: CcProfileImageWidget(
          size: 75,
          border: borderId,
          avatar: avatarId,
        ));
  }
}
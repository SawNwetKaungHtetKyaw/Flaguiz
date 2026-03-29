
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_profile_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class FriendCardWidget extends StatelessWidget {
  const FriendCardWidget({
    super.key,
    required this.user,
  });
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AudioService.instance.playSound('tap');
        
      },
      child: Container(
        width: double.maxFinite,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey.shade800,
            boxShadow: const [BoxShadow(offset: Offset(4, 4))]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 5),
                CcProfileImageWidget(avatar: user?.avatars?[0] ?? '', border: user?.borders?[0] ?? '',size: 60),
                const SizedBox(width: 10),
                CcShadowedTextWidget(text: user?.username ?? '')
              ],
            ),
      ),
    );
  }
}

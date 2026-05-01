import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnfriendDialog extends StatelessWidget {
  const UnfriendDialog(
      {super.key, required this.userId, required this.playerId});
  final String userId, playerId;

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsProvider>(
      builder: (context, provider, child) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              width: double.maxFinite,
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.only(
                  top: 100, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  border: Border.all(color: Colors.white, width: 3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CcShadowedTextWidget(
                    text: CcConstants.kUnfriendDescripton,
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
                                  text: CcConstants.kClose),
                              onTap: () {
                                AudioService.instance.playSound('back');
                                Navigator.pop(context);
                              })),
                      const SizedBox(width: 10),
                      Expanded(
                          child: CcOutlinedButton(
                              child: const CcShadowedTextWidget(
                                  text: CcConstants.kConfirm),
                              onTap: () async {
                                AudioService.instance.playSound('tap');

                                Utils.showLoadingDialog(context);
                                await provider.unfriend(
                                    userId: userId, playerId: playerId);
                                provider.listenFriends(userId);

                                if (!context.mounted) return;
                                Utils.hideLoadingDialog(context);

                                Navigator.of(context).pop();
                              })),
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
                          text: CcConstants.kUnFriend, fontSize: 18)),
                  Positioned(
                      top: 2,
                      right: 2,
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
      ),
    );
  }
}

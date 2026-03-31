import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeFriendWidget extends StatelessWidget {
  const HomeFriendWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendsProvider>(builder: (context, provider, child) {
      int requestLength = provider.requests.length;
      return Positioned(
          top: 200,
          left: 10,
          child: GestureDetector(
            onTap: () {
              AudioService.instance.playSound('tap');
              Navigator.of(context).pushNamed(RoutePaths.friends);
            },
            child: Container(
                width: 75,
                height: 75,
                alignment: Alignment.topRight,
                decoration: const BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage(AssetsImages.friends)),
                ),
                child: CcNotificationWidget(
                    isVisiable: requestLength > 0,
                    count: requestLength.toString())),
          ));
    });
  }
}

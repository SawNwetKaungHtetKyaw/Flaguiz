
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class FriendProfileStatusWidget extends StatelessWidget {
  const FriendProfileStatusWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.isVisible
  });
  final Color color;
  final IconData icon;
  final String text;
  final Function onTap;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap: (){
          AudioService.instance.playSound('tap');
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.only(
              top: 3, bottom: 5,left: 8,right: 8),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const[
                BoxShadow(
                  offset: Offset(2, 2)
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 15,
                shadows:const [BoxShadow(offset: Offset(1, 1))],
              ),
              const SizedBox(width: 5),
              CcShadowedTextWidget(
                  text: text, fontSize: 8, dx: 1, dy: 1,letterSpacing: 1,),
            ],
          ),
        ),
      ),
    );
  }
}
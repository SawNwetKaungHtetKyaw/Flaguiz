
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';

class CcOnlineStatusWidget extends StatelessWidget {
  const CcOnlineStatusWidget({
    super.key,
    required this.isOnline,
    required this.dateTime
  });
  final bool isOnline;
  final DateTime? dateTime;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: isOnline ? successColor : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
    
        Text(
          isOnline ? "Online" : Utils.getLastSeen(dateTime),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

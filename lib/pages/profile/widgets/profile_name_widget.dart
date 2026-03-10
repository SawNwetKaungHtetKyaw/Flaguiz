
import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/profile/dialogs/change_your_name_dialog.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class ProfileNameWidget extends StatelessWidget {
  const ProfileNameWidget({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CcShadowedTextWidget(
            text: user?.username ?? 'Player',
            fontSize: 16),
        GestureDetector(
          onTap: (){
            showDialog(context: context, builder: (context) => ChangeYourNameDialog(userName: user?.username ?? 'Player'));
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(3),
                boxShadow: const[
                  BoxShadow(offset: Offset(2, 2)),
                  BoxShadow(offset: Offset(-0.2, -0.2),color: primaryLightColor),
                ]),
            child:const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/home/dialog/already_account_dialog.dart';
import 'package:flaguiz/pages/home/dialog/comfirm_logout_dialog.dart';
import 'package:flaguiz/pages/loading/dialogs/no_internet_dialog.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/enum/login_status.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectWithGoogleWidget extends StatelessWidget {
  const ConnectWithGoogleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => CcOutlinedButton(
          child: CcShadowedTextWidget(
              fontSize: 10,
              text: userProvider.isLoggedIn
                  ? CcConstants.kLogout
                  : CcConstants.kLoginWithGoogle),
          onTap: () async {
            AudioService.instance.playSound('tap');
            if (!await Utils.hasInternet() && context.mounted) {
              showDialog(
                  context: context,
                  builder: (context) => NoInternetDialog(
                      onTap: () {
                        AudioService.instance.playSound('back');
                        Navigator.of(context).pop();
                      },
                      text: CcConstants.kClose));
              return;
            }
            if (!context.mounted) return;
            Utils.showLoadingDialog(context);

            if (userProvider.isLoggedIn) {
              /////====================================
              ///  Logout Section
              /////====================================
              if (!context.mounted) return;
              Utils.hideLoadingDialog(context);

              final result = await showDialog(
                barrierDismissible: false,
                  context: context,
                  builder: (context) => const ComfirmLogoutDialog());

              if (!context.mounted) return;
              if (result == true) {
                Utils.showLoadingDialog(context);
                await userProvider.syncLocalToFirestoreIfNeeded();
                await userProvider.logout();
                if (!context.mounted) return;
              Utils.hideLoadingDialog(context);

              Utils.showToastMessage(context, "Logged out successfully",backgroundColor: primaryColor);
              }

            } else {
              /////====================================
              ///  Login Section
              /////====================================
              final status = await userProvider.loginWithGoogle(context);

              if (!context.mounted) return;
              Utils.hideLoadingDialog(context);

              if (status == LoginStatus.existingUser) {
                final result = await showDialog<bool>(
                    context: context,
                    builder: (_) => const AlreadyAccountDialog());

                if (!context.mounted) return;

                if (result == true) {
                  Utils.showLoadingDialog(context);
                  await userProvider.loadExistingUser(context);
                  if (!context.mounted) return;
                  Utils.hideLoadingDialog(context);
                } else {
                  await userProvider.logout();
                }
              }
            }
          }),
    );
  }
}

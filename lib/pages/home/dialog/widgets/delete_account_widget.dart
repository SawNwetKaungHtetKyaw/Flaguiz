import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/pages/loading/dialogs/no_internet_dialog.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flaguiz/widgets/dialogs/cc_delete_account_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountWidget extends StatelessWidget {
  const DeleteAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CcOutlinedButton(
        color: errorColor,
        child: const CcShadowedTextWidget(
            text: CcConstants.kDeleteAccount, fontSize: 10),
        onTap: () async {
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
          bool confirm = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const CcDeleteAccountDialog(),
          );

          if (confirm != true) return;

          if (!context.mounted) return;
          Utils.showLoadingDialog(context);
          try {
            await context.read<UserProvider>().deleteAccount();

            if (!context.mounted) return;
            Utils.hideLoadingDialog(context);

            Utils.showToastMessage(context, "Account deleted",backgroundColor: errorColor);

          } catch (e) {
            if (!context.mounted) return;
            Utils.hideLoadingDialog(context);

            Utils.showToastMessage(context, "Error: $e",backgroundColor: errorColor);

          }
        });
  }
}

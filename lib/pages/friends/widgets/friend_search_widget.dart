import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/friends/widgets/friend_card_widget.dart';
import 'package:flaguiz/providers/friends_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/widgets/cc_outlined_button.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FriendSearchWidget extends StatefulWidget {
  const FriendSearchWidget({super.key});

  @override
  State<FriendSearchWidget> createState() => _FriendSearchWidgetState();
}

class _FriendSearchWidgetState extends State<FriendSearchWidget> {
  final TextEditingController textEditingController =
      TextEditingController(text: "#");
  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendsProvider, UserProvider>(
      builder: (context, provider, userProvider, child) => Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(offset: Offset(3, 4), color: Colors.black),
                      ]),
                  alignment: Alignment.center,
                  child: TextField(
                    autofocus: true,
                    controller: textEditingController,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (!newValue.text.startsWith("#")) {
                          return TextEditingValue(
                            text: "#${newValue.text.replaceAll("#", "")}",
                            selection: TextSelection.collapsed(
                              offset: newValue.text.length + 1,
                            ),
                          );
                        }
                        return newValue;
                      }),
                    ],
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: "#Player ID"),
                    onSubmitted: (seachTerm) async {
                      final String temp = seachTerm.toUpperCase().trim();
                      final UserModel? user = userProvider.user;
                      if (user == null) return;
                      await provider.searchUserByPlayerId(user.id ?? '', temp);
                    },
                  ),
                ),
              ),
              CcOutlinedButton(
                  width: 45,
                  height: 45,
                  offset: const Offset(3, 4),
                  borderColor: Colors.black12,
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(Icons.search,
                      color: Colors.white,
                      size: 30,
                      shadows: [
                        BoxShadow(offset: Offset(1, 2), color: Colors.black),
                      ]),
                  onTap: () async {
                    AudioService.instance.playSound('tap');
                    final String temp =
                        textEditingController.text.toUpperCase().trim();
                    final UserModel? user = userProvider.user;
                    if (user == null) return;
                    await provider.searchUserByPlayerId(user.id ?? '', temp);
                  }),
            ],
          ),
          FutureBuilder(
            future: provider.searchFuturePlayer,
            builder: (context, snapshot) {
              if (provider.searchFuturePlayer == null) {
                return const Expanded(
                    child: Center(
                  child:
                      CcShadowedTextWidget(text: "Enter Player ID and Search"),
                ));
              }

              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }

              // Error
              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                      child: CcShadowedTextWidget(
                          text: "Error: ${snapshot.error}")),
                );
              }

              // No user found
              if (!snapshot.hasData || snapshot.data == null) {
                return const Expanded(
                  child: Center(
                      child: CcShadowedTextWidget(text: "User not found")),
                );
              }

              // Success
              final player = snapshot.data!;
              return FriendCardWidget(
                  player: player, page: CcConstants.K_SEARCH);
            },
          )
        ],
      ),
    );
  }
}

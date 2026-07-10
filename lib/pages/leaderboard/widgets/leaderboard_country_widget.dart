import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/country_leaderboard_model.dart';
import 'package:flaguiz/pages/leaderboard/widgets/leaderboard_country_card_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_connect_with_google_widget.dart';
import 'package:flaguiz/providers/leaderboard_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardCountryWidget extends StatelessWidget {
  const LeaderboardCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LeaderboardProvider, UserProvider>(
      builder: (context, provider, userProvider, child) {
        return userProvider.isLoggedIn
            ? FutureBuilder(
              future: provider.getCountryLeaderboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: CcShadowedTextWidget(text: "No Data"),
                  );
                }

                final List<CountryLeaderboardModel> countryLeaderboards =
                    snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: countryLeaderboards.length,
                  itemBuilder: (context, index) {
                    CountryLeaderboardModel? country =
                        countryLeaderboards[index];
                    return LeaderboardCountryCardWidget(
                      index: index,
                      country: country,
                    );
                  },
                );
              },
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CcShadowedTextWidget(
                  text: CcConstants.kLeaderboardNeedLoginCountry,
                  letterSpacing: 1,
                  textAlign: TextAlign.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),

                const SizedBox(height: 10),

                /// Login With Google
                const ProfileConnectWithGoogleWidget(),
              ],
            );
      },
    );
  }
}

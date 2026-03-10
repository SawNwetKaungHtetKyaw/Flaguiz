import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/profile/dialogs/edit_dialog.dart';
import 'package:flaguiz/pages/profile/widgets/profile_achivement_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_adventure_status_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_banner_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_challenge_status_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_country_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_name_widget.dart';
import 'package:flaguiz/pages/profile/widgets/profile_trophy_widget.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/service/audio_service.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_image_button.dart';
import 'package:flaguiz/widgets/cc_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<UserProvider, CountryProvider>(
          builder: (context, provider, countryProvider, child) {
        UserModel? user = provider.user;
        List<CountryModel> countryList = countryProvider.countryList;

        provider.countryById(user?.country ?? '', countryList);

        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.profileBg), fit: BoxFit.fill)),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                
                        /// Banner Section
                        ProfileBannerWidget(id: user?.banners?[0] ?? ''),
                
                        const SizedBox(height: 5),
                
                        /// Profile Detail Section
                        Row(
                          children: [
                            CcProfileImageWidget(
                              border: user?.borders?[0] ?? '',
                              avatar: user?.avatars?[0] ?? '',
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Username
                                ProfileNameWidget(user: user),
                
                                /// Trophy
                                ProfileTrophyWidget(trophy: user?.trophy ?? 0)
                              ],
                            )
                          ],
                        ),
                
                        /// Country Section
                        ProfileCountryWidget(countryId: user?.country ?? ''),
                
                        /// Game Status Section (Adventure & Challenge)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ProfileAdventureStatusWidget(
                                list: user?.adventureCompletedList ?? []),
                            Container(
                              width: 0.3,
                              height: 330,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              color: Colors.white,
                            ),
                            ProfileChallengeStatusWidget(
                                list: user?.challengeCompletedList ?? [])
                          ],
                        ),
                
                        /// Achivement Section
                        ProfileAchivementWidget(
                            achievements: user?.achievements ?? [])
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CcBackWidget(image: AssetsImages.defaultBackKey),
                  
                      /// Edit
                      CcImageButton(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          image: AssetsImages.editButton,
                          onTap: () {
                            AudioService.instance.playSound('tap');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const EditDialog());
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

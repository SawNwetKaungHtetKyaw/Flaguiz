import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_avatar.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_background.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_banner.dart';
import 'package:flaguiz/pages/shop_detail/widgets/shop_border.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_coin_box_widget.dart';
import 'package:flaguiz/widgets/cc_energy_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({super.key, required this.category});
  final String category;

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  String heroTag = '';
  String iconicImage = '';
  List<String> ownList = [];

  void checkCategory(UserModel? user) {
    switch (widget.category) {
      case CcConstants.FIRESTORE_AVATAR:
        iconicImage = AssetsImages.shopAvatar;
        heroTag = CcConstants.kH_SHOP_AVATAR;
        ownList = user?.avatars ?? [];
        break;
      case CcConstants.FIRESTORE_BORDER:
        iconicImage = AssetsImages.shopBorder;
        heroTag = CcConstants.kH_SHOP_BORDER;
        ownList = user?.borders ?? [];
        break;
      case CcConstants.FIRESTORE_BACKGROUND:
        iconicImage = AssetsImages.shopBackground;
        heroTag = CcConstants.kH_SHOP_BACKGROUND;
        ownList = user?.backgrounds ?? [];
        break;
      case CcConstants.FIRESTORE_BANNER:
        iconicImage = AssetsImages.shopBanner;
        heroTag = CcConstants.kH_SHOP_BANNER;
        ownList = user?.banners ?? [];
        break;
      default:
        iconicImage = AssetsImages.shopAvatar;
        heroTag = CcConstants.kH_SHOP_AVATAR;
        ownList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        UserModel? user = userProvider.user;
        checkCategory(user);
        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AssetsImages.profileBg),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    /// Back Key
                    const CcBackWidget(image: AssetsImages.defaultBackKey),

                    const SizedBox(width: 40),

                    /// Energy
                    CcEnergyBoxWidget(energy: user?.energy.toString() ?? '0'),

                    const SizedBox(width: 10),

                    /// Coin
                    CcCoinBoxWidget(coin: user?.coin.toString() ?? '0')
                  ],
                ),

                /// Shop Iconic
                Hero(
                  tag: heroTag,
                  child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      child: Image.asset(iconicImage)),
                ),

                /// Avatar Section
                Visibility(
                    visible: widget.category == CcConstants.FIRESTORE_AVATAR,
                    child: ShopAvatar(
                        ownList: ownList,
                        userCoin: user?.coin ?? 0,
                        category: widget.category)),

                /// Border Section
                Visibility(
                    visible: widget.category == CcConstants.FIRESTORE_BORDER,
                    child: ShopBorder(
                        ownList: ownList,
                        userCoin: user?.coin ?? 0,
                        category: widget.category)),

                /// Background Section
                Visibility(
                    visible:
                        widget.category == CcConstants.FIRESTORE_BACKGROUND,
                    child: ShopBackground(
                        ownList: ownList,
                        userCoin: user?.coin ?? 0,
                        category: widget.category)),

                /// Banner Section
                Visibility(
                    visible: widget.category == CcConstants.FIRESTORE_BANNER,
                    child: ShopBanner(
                        ownList: ownList,
                        userCoin: user?.coin ?? 0,
                        category: widget.category)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

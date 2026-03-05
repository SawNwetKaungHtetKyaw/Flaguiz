import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/models/user_model.dart';
import 'package:flaguiz/pages/shop/widgets/shop_item_box_widget.dart';
import 'package:flaguiz/providers/user_provider.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_back_widget.dart';
import 'package:flaguiz/widgets/cc_coin_box_widget.dart';
import 'package:flaguiz/widgets/cc_energy_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsImages.profileBg), fit: BoxFit.cover)),
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          UserModel? user = userProvider.user;
          return SafeArea(
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ShopItemBoxWidget(
                          heroTag: CcConstants.kH_SHOP_AVATAR,
                          image: AssetsImages.shopAvatar,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutePaths.shopDetail,
                                arguments: CcConstants.FIRESTORE_AVATAR);
                          }),

                      /// Border Shop
                      ShopItemBoxWidget(
                          heroTag: CcConstants.kH_SHOP_BORDER,
                          image: AssetsImages.shopBorder,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutePaths.shopDetail,
                                arguments: CcConstants.FIRESTORE_BORDER);
                          }),

                      /// Background Shop
                      ShopItemBoxWidget(
                          heroTag: CcConstants.kH_SHOP_BACKGROUND,
                          image: AssetsImages.shopBackground,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutePaths.shopDetail,
                                arguments: CcConstants.FIRESTORE_BACKGROUND);
                          }),

                      /// Banner Shop
                      ShopItemBoxWidget(
                          heroTag: CcConstants.kH_SHOP_BANNER,
                          image: AssetsImages.shopBanner,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RoutePaths.shopDetail,
                                arguments: CcConstants.FIRESTORE_BANNER);
                          }),
                    ],
                  ),
                ),
              )
            ],
          ));
        }),
      ),
    );
  }
}

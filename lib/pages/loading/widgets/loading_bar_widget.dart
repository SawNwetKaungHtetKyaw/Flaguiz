import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/pages/loading/dialogs/no_internet_dialog.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/service/image_service.dart';
import 'package:flaguiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flaguiz/config/cc_colors.dart';

class LoadingBarWidget extends StatefulWidget {
  const LoadingBarWidget({super.key});

  @override
  State<LoadingBarWidget> createState() => _LoadingBarWidgetState();
}

class _LoadingBarWidgetState extends State<LoadingBarWidget> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _startPreloading();
  }

  Future<void> _startPreloading() async {
    CountryProvider provider =
        Provider.of<CountryProvider>(context, listen: false);

    await provider.loadCountries();

    List<CountryModel> countries = provider.countryList;

    List<String> imageUrls = [];

    for (var country in countries) {
      imageUrls.add("${CcConfig.image_base_url}${country.flagUrl}");
      imageUrls.add("${CcConfig.image_base_url}${country.mapUrl}");
    }

    /// check cache
    bool cached = await Utils.areImagesCached(imageUrls);

    /// check internet
    bool internet = await Utils.hasInternet();

    /// no internet AND no cache -> dialog
    if (!internet && !cached) {
      showNoInternetDialog();
      return;
    }

    final preloader = ImageService(
      imageUrls: imageUrls,
      batchSize: 10,
    );

    await preloader.preload(
      onProgress: (percent) {
        if (!mounted) return;

        setState(() {
          progress = percent;
        });
      },
    );

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, RoutePaths.home);
  }

  void showNoInternetDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => NoInternetDialog(onTap: () async {
              Navigator.pop(context);
              _startPreloading();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30,
        width: 250,
        margin: const EdgeInsets.only(bottom: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 215, 191, 246),
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress / 100,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [secondryColor, primaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Center(
              child: CcShadowedTextWidget(
                text: "${progress.toStringAsFixed(0)}%",
                fontSize: 10,
                dx: 1.5,
                dy: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

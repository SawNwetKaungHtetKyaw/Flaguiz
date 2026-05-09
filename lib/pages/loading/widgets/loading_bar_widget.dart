import 'package:flaguiz/pages/loading/dialogs/no_internet_dialog.dart';
import 'package:flaguiz/providers/country_provider.dart';
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
  @override
  void initState() {
    super.initState();
    _startPreloading();
  }

  Future<void> _startPreloading() async {
    CountryProvider provider =
        Provider.of<CountryProvider>(context, listen: false);

    if (await provider.isDownloaded()) {
      await provider.getCountries();
      provider.animateToFullProgress();
      await Future.delayed(const Duration(seconds: 2));
      _goHome();
      return;
    }

    /// No internet -> dialog
    bool internet = await Utils.hasInternet();
    if (!internet) {
      showNoInternetDialog();
      return;
    }

    //// Background sync (don’t block UI)
    provider.syncCountries();

    //// Countries Image Cached
    if (!mounted) return;
    await provider.startCachedCountryImage(context);

    _goHome();
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryProvider>(
      builder: (context, countryProvider, child) => Column(
        children: [
          FutureBuilder(
              future: countryProvider.isDownloaded(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final isDownloaded = snapshot.data ?? false;
                  return Visibility(
                    visible: !isDownloaded,
                    child: const CcShadowedTextWidget(
                      text: "Downloading",
                      fontSize: 12,
                      dx: 1.5,
                      dy: 1.5,
                    ),
                  );
                }

                return const SizedBox();
              }),
          Center(
            child:
                Consumer<CountryProvider>(builder: (context, provider, child) {
              double progress =
                  double.parse(provider.progress.toStringAsFixed(2)) * 100;

              return Container(
                height: 30,
                width: 250,
                margin: const EdgeInsets.only(bottom: 100, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 215, 191, 246),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: provider.progress,
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
              );
            }),
          ),
        ],
      ),
    );
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
}

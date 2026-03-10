import 'dart:async';

import 'package:flaguiz/config/route/route_paths.dart';
import 'package:flaguiz/utils/asset_images.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
     Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RoutePaths.loading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: 
          Center(child: Image.asset(AssetsImages.companyIcon,width: double.maxFinite,height: 100)),
          
    );
  }
}

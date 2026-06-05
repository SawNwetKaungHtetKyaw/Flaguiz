import 'package:flaguiz/utils/asset_images.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class CcWelcomeToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onFinish;

  const CcWelcomeToastWidget({
    super.key,
    required this.message,
    required this.onFinish,
  });

  @override
  State<CcWelcomeToastWidget> createState() => CcWelcomeToastWidgetState();
}

class CcWelcomeToastWidgetState extends State<CcWelcomeToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(begin: 0.1, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () async {
      await _controller.reverse();
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 350,
              height: 350,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.welcome),
                  fit: BoxFit.cover,
                ),
                
              ),
              child: Container(
                width: 182,
                height: 103,
                margin: EdgeInsets.only(left: 20,top: 2),
                alignment: Alignment.center,
                child: CcShadowedTextWidget(
                  padding: EdgeInsetsGeometry.zero,
                  text: widget.message,
                  textAlign: TextAlign.center,
                  textColor: Colors.black,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                  shadowColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

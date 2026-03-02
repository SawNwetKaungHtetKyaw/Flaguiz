import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class DetailCardWidget extends StatefulWidget {
  const DetailCardWidget({super.key, required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  State<DetailCardWidget> createState() => _DetailCardWidgetState();
}

class _DetailCardWidgetState extends State<DetailCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // 30% down
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward(); // start animation when widget builds
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CcGlassWidget(
              padding: const EdgeInsets.all(4),
              height: 130,
              child: Column(
                children: [
                  SizedBox(
                      width: 70, height: 70, child: Image.asset(widget.icon)),
                  Expanded(
                    child: Center(
                      child: CcShadowedTextWidget(
                        text: widget.text,
                        fontSize: 10,
                        letterSpacing : 1,
                        dx: 1,
                        dy: 1.2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

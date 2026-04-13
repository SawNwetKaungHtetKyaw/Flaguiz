import 'dart:async';
import 'package:flutter/material.dart';

class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation({
    super.key,
    required this.child,
    this.milisecond = 800,
  });

  final Widget child;
  final int milisecond;

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> {
  double scale = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(milliseconds: widget.milisecond), () {
      if (!mounted) return;
      setState(() => scale = 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ✅ VERY IMPORTANT
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      child: widget.child,
    );
  }
}

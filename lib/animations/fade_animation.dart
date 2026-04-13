import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  const FadeAnimation({
    super.key,
    required this.child,
    this.milisecond = 700,
  });

  final Widget child;
  final int milisecond;

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.milisecond),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0, // invisible
      end: 1.0,   // visible
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn, // smooth fade
      ),
    );

    _controller.forward(); // start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
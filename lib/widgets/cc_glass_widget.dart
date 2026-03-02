import 'dart:ui';
import 'package:flutter/material.dart';

class CcGlassWidget extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final double blur;
  final double borderRadius;
  final EdgeInsets padding,margin;
  final Color borderColor;
  final double borderWidth;
  final Alignment gradientBegin;
  final Alignment gradientEnd;

  const CcGlassWidget({
    super.key,
    this.child,
    this.width = double.infinity,
    this.height = 250,
    this.blur = 3,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(8),
    this.margin = EdgeInsets.zero,
    this.borderColor = const Color.fromARGB(90, 255, 255, 255),
    this.borderWidth = 2,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            // subtle translucent background
            gradient: LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: [
                const Color.fromARGB(255, 208, 208, 208).withOpacity(0.12),
                Colors.white.withOpacity(0.06),
              ],
            ),
            border: Border(
                top: BorderSide(color: borderColor, width: borderWidth),
                left: BorderSide(color: borderColor, width: borderWidth)),
            borderRadius: BorderRadius.circular(borderRadius),
            
          ),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flaguiz/config/cc_colors.dart';
import 'package:flutter/material.dart';

class CcOutlinedButton extends StatefulWidget {
  const CcOutlinedButton(
      {super.key,
      required this.child,
      required this.onTap,
      this.width = double.maxFinite,
      this.height = 50,
      this.radius = 5,
      this.color = primaryColor,
      this.borderColor = Colors.white,
      this.shadowColor = Colors.black,
      this.margin,
      this.padding,
      this.alignment = Alignment.center,
      this.offset = const Offset(2, 2)});
  final double width, height, radius;
  final Color color, borderColor, shadowColor;
  final EdgeInsets? margin, padding;
  final Widget child;
  final Alignment alignment;
  final Offset offset;
  final Function onTap;

  @override
  State<CcOutlinedButton> createState() => _CcOutlinedButtonState();
}

class _CcOutlinedButtonState extends State<CcOutlinedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails _) async {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            padding: widget.padding,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: widget.color,
                border: Border.all(color: widget.borderColor),
                boxShadow: [
                  BoxShadow(offset: widget.offset, color: widget.shadowColor)
                ]),
            alignment: widget.alignment,
            child: widget.child),
      ),
    );
  }
}

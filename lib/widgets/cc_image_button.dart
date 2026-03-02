import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class CcImageButton extends StatefulWidget {
  const CcImageButton({
    super.key,
    required this.image,
    required this.onTap,
    this.width = double.maxFinite,
    this.height = 70,
    this.fontsize = 12,
    this.text = '',
    this.widget,
    this.margin = const EdgeInsets.only(bottom: 15, right: 20, left: 20),
    this.padding = const EdgeInsets.only(bottom: 2),
  });

  final String image;
  final double width, height, fontsize;
  final String text;
  final Widget? widget;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final GestureTapCallback onTap;

  @override
  State<CcImageButton> createState() => _CcImageButtonState();
}

class _CcImageButtonState extends State<CcImageButton> {
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
    return Padding(
      padding: widget.margin,
      child: GestureDetector(
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
            padding: widget.padding,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.fill,
              ),
            ),
            child: widget.widget ??
                Center(
                  child: CcShadowedTextWidget(
                    text: widget.text,
                    fontSize: widget.fontsize,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

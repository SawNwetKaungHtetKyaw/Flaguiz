import 'package:flaguiz/config/cc_config.dart';
import 'package:flaguiz/models/country_model.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_image_box_widget.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';

class LibraryCardWidget extends StatefulWidget {
  const LibraryCardWidget({
    super.key,
    required this.country,
    required this.onTap,
  });

  final CountryModel country;
  final Function onTap;

  @override
  State<LibraryCardWidget> createState() => _LibraryCardWidgetState();
}

class _LibraryCardWidgetState extends State<LibraryCardWidget> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.96); // 👈 slight shrink
  }

  void _onTapUp(TapUpDetails _) {
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
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: CcGlassWidget(
            height: 80,
            blur: 0,
            child: Row(
              children: [
                CcShadowedImageBoxWidget(
                  width: 90,
                  height: double.maxFinite,
                  image: "${CcConfig.image_base_url}${widget.country.flagUrl}",
                  radius: 5,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: CcShadowedTextWidget(
                    text: widget.country.name ?? '',
                    fontSize: 11,
                    strokeWidth: 3,
                    dx: 2,
                    dy: 2.5,
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

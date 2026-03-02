import 'package:flaguiz/config/cc_colors.dart';
import 'package:flaguiz/widgets/cc_shadowed_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';


class CcSeeMoreTextWidget extends StatefulWidget {
  final String text;
  final int trimLines;

  const CcSeeMoreTextWidget({
    super.key,
    required this.text,
    this.trimLines = 3, // default: show 3 lines
  });

  @override
  State<CcSeeMoreTextWidget> createState() => _CcSeeMoreTextWidgetState();
}

class _CcSeeMoreTextWidgetState extends State<CcSeeMoreTextWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
            text: widget.text, style: const TextStyle(color: Colors.black));
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CcShadowedTextWidget(
              text: widget.text,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (isOverflow)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _isExpanded ? "See less" : "See more",
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}


class InlineSeeMoreText extends StatefulWidget {
  final String text;
  final int trimLength;

  const InlineSeeMoreText({
    super.key,
    required this.text,
    this.trimLength = 240, // show first 100 chars before "See more"
  });

  @override
  State<InlineSeeMoreText> createState() => _InlineSeeMoreTextState();
}

class _InlineSeeMoreTextState extends State<InlineSeeMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText = !_isExpanded && widget.text.length > widget.trimLength
        ? widget.text.substring(0, widget.trimLength)
        : widget.text;

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: [
          TextSpan(text: displayText,style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
          if (!_isExpanded && widget.text.length > widget.trimLength)
            TextSpan(
              text: "...See more",
              style: const TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() => _isExpanded = true),
            ),
          if (_isExpanded && widget.text.length > widget.trimLength)
            TextSpan(
              text: "  See less",
              style: const TextStyle(color: secondryColor, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() => _isExpanded = false),
            ),
        ],
      ),
    );
  }
}


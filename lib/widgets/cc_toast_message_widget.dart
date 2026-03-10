import 'package:flutter/material.dart';

class CcToastMessageWidget extends StatefulWidget {
  final String message;
  final VoidCallback onFinish;

  const CcToastMessageWidget({
    super.key,
    required this.message,
    required this.onFinish,
  });

  @override
  State<CcToastMessageWidget> createState() => CcToastMessageWidgetState();
}

class CcToastMessageWidgetState extends State<CcToastMessageWidget>
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

    Future.delayed(const Duration(seconds: 1), () async {
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
      bottom: 400,
      left: 50,
      right: 50,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: 
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                
            ),
          ),
        ),
      ),
    );
  }
}

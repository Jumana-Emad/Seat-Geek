import 'package:flutter/material.dart';
import 'dart:math';

class ShakeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const ShakeText({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    this.duration = const Duration(seconds: 1),
  });

  @override
  ShakeTextState createState() => ShakeTextState();
}

class ShakeTextState extends State<ShakeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Text(widget.text, style: widget.style),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(10 * sin(_controller.value * 2 * pi), 0),
          child: child,
        );
      },
    );
  }
}

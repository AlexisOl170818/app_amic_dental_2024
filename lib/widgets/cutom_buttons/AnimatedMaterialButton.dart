import 'package:flutter/material.dart';

class AnimatedMaterialButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const AnimatedMaterialButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AnimatedMaterialButtonState createState() => _AnimatedMaterialButtonState();
}

class _AnimatedMaterialButtonState extends State<AnimatedMaterialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final curve = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MaterialButton(
          color: Theme.of(context).primaryColor,
          onPressed: widget.onPressed,
          child: Text(widget.buttonText),
        ),
      ),
    );
  }
}

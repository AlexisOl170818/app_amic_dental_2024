import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    Color color = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black87
        : Colors.white;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: color,
      child: Stack(
        children: [
          Stack(
            children: [const _PurpleBox(), const _HeaderIcon(), child],
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * 0.05,
        left: MediaQuery.of(context).size.width * 0.25,
        child: FadeIn(
          key: UniqueKey(),
          child: JelloIn(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/logo-amic.jpg",
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ));
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(
            child: _Bubble(),
            top: 90,
            left: 30,
          ),
          Positioned(
            child: _Bubble(),
            top: -40,
            left: -30,
          ),
          Positioned(
            child: _Bubble(),
            bottom: -50,
            left: -20,
          ),
          Positioned(
            child: _Bubble(),
            bottom: -120,
            right: 10,
          ),
          Positioned(
            child: _Bubble(),
            bottom: 50,
            left: 200,
          ),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(16, 50, 114, 1),
            Color.fromRGBO(223, 76, 18, 1)
          ],
        ),
      );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.02)),
    );
  }
}

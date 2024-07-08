import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  /**
   * Crea una transicion al cambiar de pantalla
   */
  Route createTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        var opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
        var scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<void> launchUrl(String? url) async {
    if (url == null) return;
    if (!await launchUrlString(url)) {
      throw 'Could not launch $url';
    }
  }
}

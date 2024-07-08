import 'package:flutter/material.dart';

class BackdropCustomized extends StatelessWidget {
  const BackdropCustomized({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 7, 50, 71),
            const Color.fromARGB(255, 21, 56, 73).withOpacity(0.2)
          ],
        ),
      ),
    );
  }
}

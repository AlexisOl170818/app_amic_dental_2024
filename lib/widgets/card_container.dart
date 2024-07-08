import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    /*    Map<String, Color> color =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? {"bg": Theme.of(context).cardColor, "shadow": Colors.white10}
            : {
                "bg": Colors.white,
                "shadow": Colors.black12,
              }; */
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

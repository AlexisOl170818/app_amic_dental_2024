import 'package:app_amic_dental_2024/screens/login.dart';
import 'package:app_amic_dental_2024/services/authentication_service.dart';
import 'package:app_amic_dental_2024/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class DrawerCustomized extends StatefulWidget {
  const DrawerCustomized({super.key, required this.advancedDrawerController});
  final AdvancedDrawerController advancedDrawerController;

  @override
  State<DrawerCustomized> createState() => _DrawerCustomizedState();
}

class _DrawerCustomizedState extends State<DrawerCustomized> {
  bool isUserAuth = false;

  verifyUserAuth() async {
    isUserAuth = await AuthenticationService().verifyAuthUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    verifyUserAuth();
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: ListView(
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 10.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/logo-amic.jpg'),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 64),
              child: const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Alexis",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    Text("Dentista",
                        style: TextStyle(fontSize: 14, color: Colors.white))
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () => {widget.advancedDrawerController.hideDrawer()},
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
            ),
            ListTile(
              onTap: () async {
                await AuthenticationService().signout();
                Navigator.pushReplacement(
                    context, Utils().createTransition(const Login()));
                // Navigator.pushReplacementNamed(context, AppRoutes.singin);
              },
              leading: const Icon(Icons.exit_to_app),
              title: isUserAuth
                  ? const Text("Cerrar Sesion")
                  : const Text("Iniciar Sesion"),
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Padding(
                    padding: EdgeInsets.only(left: 22.0, right: 12),
                    child: Text('@infoexpo',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

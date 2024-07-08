import 'package:animate_do/animate_do.dart';
import 'package:app_amic_dental_2024/screens/dashboard.dart';
import 'package:app_amic_dental_2024/services/authentication_service.dart';
import 'package:app_amic_dental_2024/ui/input_decoration.dart';
import 'package:app_amic_dental_2024/utils/utils.dart';

import 'package:app_amic_dental_2024/widgets/auth_background.dart';
import 'package:app_amic_dental_2024/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_btn/loading_btn.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              FadeIn(
                // key: UniqueKey(),
                delay: const Duration(milliseconds: 150),
                child: CardContainer(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Login',
                        style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(
                      height: 5,
                    ),
                    const _LoginForm(),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              FadeInLeft(
                child: BounceInDown(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, Utils().createTransition(Dashboard()));
                      },
                      child: const Text(
                        "Continuar como invitado",
                        style: TextStyle(color: Colors.orange),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController badgeController = TextEditingController();

  bool _isFormValid = false;
  bool _isSendUser = false;
  void validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    validateForm();
  }

  @override
  Widget build(BuildContext context) {
    var color = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          BounceInLeft(
            // key: UniqueKey(),
            delay: const Duration(milliseconds: 1500),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              readOnly: _isSendUser,
              controller: emailController,
              style: TextStyle(color: color),
              decoration: InputDecorations.authInputDecoration(
                  color: Colors.orange,
                  hintText: 'ejemplo@ejemplo.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_sharp),
              onChanged: (value) => validateForm(),
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo.';
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          BounceInRight(
            //   key: UniqueKey(),
            delay: const Duration(milliseconds: 1500),
            child: TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: _isSendUser,
              controller: badgeController,
              style: TextStyle(color: color),
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  color: Colors.orange,
                  hintText: '123456',
                  labelText: 'Gafete',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => validateForm(),
              validator: (value) {
                if (value != null &&
                    value.trim().isNotEmpty &&
                    value.length >= 6) {
                  return null;
                }

                return 'Ingresa un gafete valido (Mas de 6 digitos)!';
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SlideInDown(
            // key: UniqueKey(),
            delay: const Duration(seconds: 1),
            child: LoadingBtn(
              disabledTextColor: Theme.of(context).disabledColor,
              borderRadius: 50,
              //curve: Curves.elasticOut,
              animate: true,
              height: 50,
              loader: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white, size: 40),
              width: MediaQuery.of(context).size.width * 0.80,
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.orange,
              onTap: _isFormValid
                  ? (startLoading, stopLoading, btnState) async {
                      //EasyLoading.show(status: "Cargando");
                      _isSendUser = true;
                      setState(() {});
                      if (btnState == ButtonState.idle) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        startLoading();
                        await AuthenticationService().signin(
                            emailController.text.trim(),
                            int.parse(badgeController.text.trim()));
                        await Future.delayed(const Duration(seconds: 1));
                        _isSendUser = false;
                        await stopLoading();
                        Navigator.pushReplacement(context,
                            Utils().createTransition(const Dashboard()));
                      }
                      // EasyLoading.dismiss();
                    }
                  : null,
              child: const Text(
                "Iniciar Sesión",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

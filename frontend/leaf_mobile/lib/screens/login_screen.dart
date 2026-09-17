import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:leaf_mobile/screens/forget_password_screen.dart';
import 'package:leaf_mobile/screens/maintenance_staff/mstaff_screen_router.dart';
import 'package:leaf_mobile/screens/normal_users/user_screen_router.dart';
import 'package:leaf_mobile/screens/register_screen.dart';
import 'package:leaf_mobile/widgets/pasword_eye.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool eyeopen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [logoRow(), formInputs(), specialButtons()]),
    );
  }

  // logo Row
  Row logoRow() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(top: 0.4, left: 60),
          child: Image.asset(
            'assets/images/LogoV3.png',
            width: 290,
            height: 290,
          ),
        ),
      ],
    );
  }

  Padding formInputs() {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 20, right: 30),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.meidumBlue),
                ),
                icon: Icon(Icons.person, color: AppColors.meidumBlue),
                labelText: "Email",
                hintText: "user123@gmail.com",
                labelStyle: TextStyle(color: AppColors.meidumBlue),
              ),
            ),
            TextFormField(
              autofocus: true,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.meidumBlue),
                ),
                icon: Icon(Icons.key, color: AppColors.meidumBlue),
                labelText: "Contraseña",
                labelStyle: TextStyle(color: AppColors.meidumBlue),
                suffixIcon: PasswordEye(
                  openEye: eyeopen,
                  changeStateEye: () {
                    setState(() {
                      eyeopen = !eyeopen;
                    });
                  },
                ),
                suffixIconColor: AppColors.meidumBlue,
              ),

              obscureText: eyeopen,
            ),
          ],
        ),
      ),
    );
  }

  Padding specialButtons() {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilledButton(
            onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => MstaffScreenRouter()));

            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.meidumBlue,
            ),
            child: Text("Iniciar Seción"),
          ),
          TextButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgetPasswordScreen()));},
            style: TextButton.styleFrom(foregroundColor: AppColors.meidumBlue),
            child: Text("¿Olvidaste tu contraseña?"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.meidumBlue),
            child: Text("Registrarse"),
          ),
        ],
      ),
    );
  }
}

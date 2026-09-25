import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:leaf_mobile/screens/login_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        adminProfileInfo(context),
      ],
    );
  }
}

Padding adminProfileInfo(BuildContext context) {
  return Padding(
    padding: EdgeInsetsGeometry.only(
      top: 20,
      left: 15,
      right: 15,
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.alternativeBackground,
      ),
      padding: EdgeInsets.only(
        top: 25,
        bottom: 25,
        left: 15,
        right: 15,
      ),
      child: Column(
        children: [
          Icon(
            Icons.admin_panel_settings,
            size: 80,
            color: AppColors.darkGreen,
          ),

          Text(
            "Administrador: Juanito Alcachofa",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),

          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Rol: Administrador",
              style: TextStyle(fontSize: 20),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminEditProfileScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.darkGreen,
              fixedSize: Size(220, 40),
            ),
            child: Text(
              "Editar perfil",
              style: TextStyle(fontSize: 20),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminCreateProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                fixedSize: Size(220, 40),
              ),
              child: Text(
                "Crear mantenimiento",
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(220, 40),
                backgroundColor: AppColors.stateRed,
              ),
              child: Text(
                "Cerrar Sesión",
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



class AdminEditProfileScreen extends StatefulWidget {
  const AdminEditProfileScreen({super.key});

  @override
  State<AdminEditProfileScreen> createState() =>
      _AdminEditProfileScreenState();
}

class _AdminEditProfileScreenState
    extends State<AdminEditProfileScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Editar perfil"),
        backgroundColor: AppColors.background,
      ),
      body: adminEditProfileForm(
        context,
        emailController,
        userController,
        passwordController,
      ),
    );
  }
}

ListView adminEditProfileForm(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController userController,
  TextEditingController passwordController,
) {
  return ListView(
    padding: EdgeInsets.only(
      top: 70,
      left: 20,
      right: 29,
    ),
    children: [
      Center(
        child: Text(
          "Editar mi usuario:",
          style: TextStyle(fontSize: 31),
        ),
      ),

      Form(
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Email",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Ingrese un correo electrónico",
                icon: Icon(Icons.mail),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            TextFormField(
              controller: userController,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Usuario",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Ingrese su nuevo nombre de usuario",
                icon: Icon(Icons.person),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            TextFormField(
              controller: passwordController,
              obscureText: true,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Contraseña",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Ingrese su nueva contraseña",
                icon: Icon(Icons.lock),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(top: 30),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 40),
                  backgroundColor: AppColors.darkGreen,
                ),
                child: Text(
                  "Guardar Cambios",
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


class AdminCreateProfileScreen extends StatefulWidget {
  const AdminCreateProfileScreen({super.key});

  @override
  State<AdminCreateProfileScreen> createState() =>
      _AdminCreateProfileScreenState();
}

class _AdminCreateProfileScreenState
    extends State<AdminCreateProfileScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    userController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Crear usuario Mantemiento"),
        backgroundColor: AppColors.background,
      ),
      body: adminCreateProfileForm(
        context,
        emailController,
        userController,
        passwordController,
        confirmPasswordController,
      ),
    );
  }
}

ListView adminCreateProfileForm(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController userController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
) {
  return ListView(
    padding: EdgeInsets.only(
      top: 70,
      left: 20,
      right: 29,
    ),
    children: [
      Center(
        child: Text(
          "Nuevo personal de mantenimiento:",
          style: TextStyle(fontSize: 31),
        ),
      ),

      Form(
        child: Column(
          children: [
            TextFormField(
              controller: userController,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Usuario",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Ingrese el nombre del administrador",
                icon: Icon(Icons.person),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Email",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Ingrese el correo electrónico",
                icon: Icon(Icons.mail),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            TextFormField(
              controller: passwordController,
              obscureText: true,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Contraseña",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Ingrese una contraseña",
                icon: Icon(Icons.lock),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              cursorColor: AppColors.meidumBlue,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.meidumBlue,
                  ),
                ),
                labelText: "Confirmar contraseña",
                labelStyle: TextStyle(
                  color: AppColors.meidumBlue,
                ),
                hintText: "Confirme la contraseña",
                icon: Icon(Icons.lock_outline),
                iconColor: AppColors.meidumBlue,
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(top: 30),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 40),
                  backgroundColor: AppColors.darkGreen,
                ),
                child: Text(
                  "Crear administrador",
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
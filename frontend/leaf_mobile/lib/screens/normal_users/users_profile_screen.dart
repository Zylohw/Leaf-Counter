import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:leaf_mobile/screens/login_screen.dart';
import 'package:leaf_mobile/screens/normal_users/user_edit_info_screen.dart';

class UsersProfileScreen extends StatefulWidget {
  const UsersProfileScreen({super.key});
  @override
  State<UsersProfileScreen> createState() => _UsersProfileScreenState();
}

class _UsersProfileScreenState extends State<UsersProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [profileInfo(context)]);
  }
}

Padding profileInfo(BuildContext context) {
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20, left: 7),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.alternativeBackground,
          ),
          padding: EdgeInsets.only(top: 25),
          width: 400,
          height: 290,
          child: Column(
            children: [
              Icon(Icons.person, size: 80, color: AppColors.darkGreen),
              Text(
                "Usuario: Juanito Alcachofa",
                style: TextStyle(fontSize: 18),
              ),
              Text("Casa: C-99", style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserEditInfoScreen()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.darkGreen,
                  fixedSize: Size(200, 0),
                ),
                child: Text("Editar",style: TextStyle(fontSize: 20),),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(200, 0),backgroundColor: AppColors.stateRed),
                  child: Text("Cerrar Sesión",style: TextStyle(color: AppColors.background,fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

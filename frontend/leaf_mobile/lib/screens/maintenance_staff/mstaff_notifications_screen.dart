import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class MstaffNotificationsScreen extends StatefulWidget{
  const MstaffNotificationsScreen({super.key});
  @override
  State<MstaffNotificationsScreen> createState() => _MstaffNotificationsScreenState();
}

class _MstaffNotificationsScreenState extends State<MstaffNotificationsScreen>{

  @override
  Widget build(BuildContext context){
    return ListView(
      children: [
          notifationComponent("Se requiere de lectura")
      ],
    );
  }
}

Padding notifationComponent(String mensaje) {
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20, left: 7, right: 7),
    child: Container(
      padding: EdgeInsets.only(top: 10, left: 40),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lightGreen,
      ),
      child: Row(
        children: [
          Text( mensaje
            ,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check, color: AppColors.meidumBlue, size: 50),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete, color: AppColors.stateRed, size: 50),
          ),
        ],
      ),
    ),
  );
}
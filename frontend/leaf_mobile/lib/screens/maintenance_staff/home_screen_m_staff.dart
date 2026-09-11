import 'package:flutter/material.dart';

class HomeScreenMStaff extends StatefulWidget{
  const HomeScreenMStaff ({super.key});
  @override
  State<HomeScreenMStaff> createState() => _HomeScreenMStaffState();
}

class _HomeScreenMStaffState extends State<HomeScreenMStaff>{
  @override
  Widget build(BuildContext context){
    return Text("Bienvenido personal de mantenimiento");
  }
}
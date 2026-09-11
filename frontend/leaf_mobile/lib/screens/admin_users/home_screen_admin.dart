import 'package:flutter/material.dart';

class HomeScreenAdmin extends StatefulWidget{
  const HomeScreenAdmin({super.key});
  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin>{
  @override
  Widget build(BuildContext build){
    return Text("Bienvenido Admin");
  }
}
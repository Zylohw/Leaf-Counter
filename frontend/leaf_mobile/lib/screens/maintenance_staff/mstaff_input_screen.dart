import 'package:flutter/material.dart';

class MstaffInputScreen extends StatefulWidget{
  const MstaffInputScreen ({super.key});
  @override
  State<MstaffInputScreen> createState() => _MstaffInputScreenState();
}

class _MstaffInputScreenState extends State<MstaffInputScreen>{

  @override
  Widget build(BuildContext context){
    return Center(
      child: Text("Camara",style: TextStyle(fontSize: 30),),
  );
  }
}
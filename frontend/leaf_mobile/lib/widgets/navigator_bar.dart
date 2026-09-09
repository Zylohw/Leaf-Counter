import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class NavigatorBar extends StatefulWidget{
  final Icon icon1 ; 
  final Icon icon2 ; 
  final Icon icon3 ; 
  final Icon icon4 ; 
  final Icon icon5 ; 
  final String label1;
  final String label2;
  final String label3;
  final String label4;
  final String label5;

  const NavigatorBar({super.key,required this.icon1,required this.icon2,required this.icon3,required this.icon4,required this.icon5,required this.label1,required this.label2,required this.label3,required this.label4,required this.label5});
  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar>{
  @override
  Widget build  (BuildContext context){
    return NavigationBar(
      indicatorColor: AppColors.lightBlue,
      destinations: <Widget>[
        NavigationDestination(icon: widget.icon1, label: widget.label1),
        NavigationDestination(icon: widget.icon2, label: widget.label2),
        NavigationDestination(icon: widget.icon3, label: widget.label3),
        NavigationDestination(icon: widget.icon4, label: widget.label4),
        NavigationDestination(icon: widget.icon5, label: widget.label5),
      ]
      );
  }
}
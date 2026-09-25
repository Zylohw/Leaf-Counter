import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class MstaffListCheckedScreen extends StatefulWidget{
  const MstaffListCheckedScreen({super.key});

  @override
  State<MstaffListCheckedScreen> createState() => _MstaffListCheckedScreenState();
} 

class _MstaffListCheckedScreenState extends State<MstaffListCheckedScreen>{

  @override
  Widget build(BuildContext buid){
    return ListView(
        children: [
          houseItem("C-99")
        ],
    );
  }
}

Padding houseItem( String name){
  bool checkedItem = false;
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20,left: 7,right: 7),
    child: Container(
      padding: EdgeInsetsGeometry.only(left: 20),
      decoration: BoxDecoration(
        color: AppColors.alternativeBackground,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children:   [
          Text(name),
          Checkbox(value: checkedItem,onChanged:(bool? value){
            if(value!= null){
              checkedItem = !value;
            }
          },)

        ],
      ),
    ), 
  
  );
}
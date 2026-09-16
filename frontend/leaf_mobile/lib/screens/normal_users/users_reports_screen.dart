import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:month_year_picker/month_year_picker.dart';

class UsersReportsScreen extends StatefulWidget{
  const UsersReportsScreen({super.key});
  @override
  State<UsersReportsScreen> createState() => _UserReportsScreenState();
}

class _UserReportsScreenState extends State<UsersReportsScreen>{

  @override
  Widget build(BuildContext context){
    return ListView(
      children: [
        myFilters(),
        myReport()
      ],
    );

  }
}

// Widget para filtrar reportes
Padding myFilters(){
return Padding(padding: EdgeInsetsGeometry.only(left: 7),
    child: Row(
      children: [
        Container(
          width: 400,
          padding: EdgeInsetsGeometry.only(top: 20,left: 50,bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.lightBlue
          ),
          child: Row(
              children: [
                Text("Mes del reporte:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month)),
                ElevatedButton(onPressed: (){}, 
                
                  style:  ButtonStyle(
                   backgroundColor: WidgetStatePropertyAll(AppColors.alternativeBackground),
                   iconColor: WidgetStatePropertyAll(AppColors.primaryText)
                  ), 
                
                child: Text("Filtrar",style: TextStyle(color:  AppColors.navyBlue),))
              ],
          ),
        )
      ],
    ),
  ) ;
}

// Widget que muestra los reportes
Padding myReport(){
  return Padding(
    padding: EdgeInsetsGeometry.only(top:10,left: 7,right: 7),
    child: Container(
      width: 400,
      padding: EdgeInsetsGeometry.only(left: 50,bottom: 10,top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.lightBlue
      ),
      child: Row(
        children: [
            Text("Reporte Septiembre 2026",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
            IconButton(onPressed: (){}, icon: Icon(Icons.picture_as_pdf,size: 40,))
        ],
      ),
    ),
  
  );
}

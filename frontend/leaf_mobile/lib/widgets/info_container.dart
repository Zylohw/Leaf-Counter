import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import'package:leaf_mobile/core/app_colors.dart';


class InfoContainer extends StatefulWidget{
  const InfoContainer({super.key});
  @override
  State<InfoContainer> createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer>{
  // estos datos son ficticios mas adelante se van a agregar datos de verdad qeu seran los del backend
  // TODO:conectarse al backend y modificar este mapa
  Map<String,double> dataMap = {
    "Dato1":80,
    "Dato2":20  ,
  };
  @override
  Widget build (BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Container(
          padding: EdgeInsets.only(top: 60,left: 10,right: 10,bottom: 10),
          child: Column(
            children: [
              Text("Consumo General", style: TextStyle(
                fontSize: 24,
                color: AppColors.primaryText
              ),),
              PieChart(dataMap: dataMap)
            ],
          ),
          
        ),

        Container(
          padding: EdgeInsets.only(top: 60,left: 10,right: 10,bottom: 10),
          child: Column(
            children: [
              Text("Consumo del mes pasado", style: TextStyle(
                fontSize: 24,
                color: AppColors.primaryText
              ),),
              PieChart(dataMap: dataMap)
            ],
          ),
          
        )
      ],
    );
  }
}



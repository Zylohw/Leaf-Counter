import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class InfoScreenAdmin extends StatefulWidget{
  const InfoScreenAdmin({super.key});
  @override
  State<InfoScreenAdmin> createState() => _InfoScreenAdminState();
}

class _InfoScreenAdminState extends State<InfoScreenAdmin>{
  @override
  Widget build(BuildContext build){
    return ListView(
      children: [
        Text("Bienvenido Administrador",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold)
        ),
        consumoInfocardActual(10.5), 
        penddingHousesComponent(),
        reportsIssuedComponents()
      ],
    );
  }
}


Padding consumoInfocardActual(double data){
  return Padding(
    padding: EdgeInsetsGeometry.only(bottom: 20, left: 15, right: 15),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.alternativeBackground,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsetsGeometry.only(left: 30, right: 20, top: 10),
      child: Column(
        children: [
          Text("Consumo Actual", style: TextStyle(fontSize: 20)),
          SfRadialGauge(
            enableLoadingAnimation: true,
            animationDuration: 1100,
            axes: [
              RadialAxis(
                axisLineStyle: AxisLineStyle(thickness: 30),
                showTicks: false,
                axisLabelStyle: GaugeTextStyle(fontSize: 20),
                maximum: 30,
                minimum: 0,
                pointers: [
                  NeedlePointer(
                    value: data,
                    enableAnimation: true,
                    knobStyle: KnobStyle(
                      color: AppColors.background,
                      knobRadius: 0.06,
                      borderWidth: 0.04,
                      borderColor: Colors.black,
                    ),
                  ),
                  RangePointer(
                    enableAnimation: true,
                    color: lightsIdentifierColor(data),
                    width: 30,
                    value: data,
                  ),
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Text(
                      '$data M^3',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Padding penddingHousesComponent(){
  return Padding(padding: EdgeInsetsGeometry.only(top: 20),
  child: Container(
    height: 200,
    decoration: BoxDecoration(
      color: AppColors.alternativeBackground,
      borderRadius: BorderRadius.circular(20)
    ),
    padding: EdgeInsetsGeometry.only(right: 7,left: 7) ,
    child: Column(
      children: [
        Text("Casas pendientes:",style: TextStyle(fontSize: 30),),
        Text("A-14",style: TextStyle(fontSize: 18),)
      ],
    )
  ),
  );
}

Padding reportsIssuedComponents(){
  return Padding(padding: EdgeInsetsGeometry.only(top: 20),
  child: Container(
    height: 200,
    decoration: BoxDecoration(
      color: AppColors.alternativeBackground,
      borderRadius: BorderRadius.circular(20)
    ),
    padding: EdgeInsetsGeometry.only(right: 7,left: 7,top: 40) ,
    child: Column(
      children: [
        Text("Lecturas completadas:",style: TextStyle(fontSize: 24)),
        Text("27/99",style: TextStyle(fontSize: 20),)
      ],
    )
  ),
  );
}


Color lightsIdentifierColor(double data){

  if(data >= 0.9 || data<= 10.9){
    return AppColors.stateGreen; 
  }else if(data>=10.9 || data<= 29.9 ){
    return AppColors.stateYellowOrange;
  }else{
    return AppColors.stateRed;
  }
}
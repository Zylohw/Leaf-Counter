import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class UsersMenuScreen extends StatefulWidget {
  final String userName;
  const UsersMenuScreen({super.key, required this.userName});
  @override
  State<UsersMenuScreen> createState() => _UserMenuScreenState();
}

class _UserMenuScreenState extends State<UsersMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "Bienvenido ${widget.userName}",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        radialChart(30),
        myGraph(),
      ],
    );
  }
}

Container helloUser(String userName) {
  return Container(
    padding: EdgeInsetsGeometry.only(top: 50, right: 270),
    child: Text(
      userName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
        fontSize: 28,
      ),
    ),
  );
}

Padding radialChart(double data) {
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

Padding myGraph() {
  Map<String, double> dataMap = {"data1": 20.0, "data2": 80.0};
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
          Text("Consumo Hace 6 meses", style: TextStyle(fontSize: 20)),
          PieChart(dataMap: dataMap),
        ],
      ),
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

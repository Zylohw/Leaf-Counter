import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class MstaffHomeScreen extends StatefulWidget {
  const MstaffHomeScreen({super.key});
  @override
  State<MstaffHomeScreen> createState() => _MstaffHomeScreenState();
}

class _MstaffHomeScreenState extends State<MstaffHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [casaPendintes(), reportesGenerados()]);
  }
}

Padding casaPendintes() {
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20, left: 7, right: 7),
    child: Container(
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.alternativeBackground,
      ),
      child: Column(
        children: [
        Text("Casas pendintes de Analisis",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), Text("A-10",style: TextStyle(fontSize: 19),)],
      ),
    ),
  );
}

Padding reportesGenerados() {
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20, left: 7, right: 7),
    child: Container(
      padding: EdgeInsetsGeometry.only(top: 70),
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.alternativeBackground,
      ),
      child: Column(
        children: [
          Text(
            "Reportes generados",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("1/99", style: TextStyle(fontSize: 30)),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class AdminReadingsScreen extends StatefulWidget {
  const AdminReadingsScreen({super.key});

  @override
  State<AdminReadingsScreen> createState() => _AdminReadingsScreenState();
}

class _AdminReadingsScreenState extends State<AdminReadingsScreen> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: 30,
        left: 15,
        right: 15,
        bottom: 30,
      ),
      children: [
        Text(
          "Supervisión de lecturas",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          child: Text(
            "Consulte el estado de las lecturas y reportes de las viviendas.",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
          ),
        ),

        houseItem("C-01", true, true),
        houseItem("C-02", true, false),
        houseItem("C-03", false, false),
        houseItem("C-04", true, true),
        houseItem("C-05", false, false),
      ],
    );
  }
}

Padding houseItem(
  String name,
  bool readingChecked,
  bool reportChecked,
) {

  Color stateColor = AppColors.stateRed;
  String stateText = "Pendiente";

  if (readingChecked && reportChecked) {
    stateColor = AppColors.stateGreen;
    stateText = "Completado";
  } else if (readingChecked) {
    stateColor = AppColors.stateYellowOrange;
    stateText = "Reporte pendiente";
  }

  return Padding(
    padding: EdgeInsetsGeometry.only(
      top: 15,
      left: 7,
      right: 7,
    ),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.alternativeBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyBlue,
                ),
              ),

              Container(
                padding: EdgeInsets.only(
                  top: 7,
                  bottom: 7,
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: stateColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  stateText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Icon(
                  readingChecked
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: readingChecked
                      ? AppColors.stateGreen
                      : AppColors.stateRed,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    readingChecked
                        ? "Lectura realizada"
                        : "Lectura pendiente",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Icon(
                  reportChecked
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: reportChecked
                      ? AppColors.stateGreen
                      : AppColors.stateRed,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    reportChecked
                        ? "Reporte emitido"
                        : "Reporte pendiente",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
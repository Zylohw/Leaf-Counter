import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState
    extends State<AdminNotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        adminNotificationComponent("Se requiere de lectura"),
        adminNotificationComponent("Lectura realizada en C-01"),
        adminNotificationComponent("Reporte emitido para C-02"),
      ],
    );
  }
}

Padding adminNotificationComponent(String mensaje) {
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20, left: 7, right: 7),
    child: Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 10),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lightGreen,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.check,
              color: AppColors.meidumBlue,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: AppColors.stateRed,
              size: 35,
            ),
          ),
        ],
      ),
    ),
  );
}
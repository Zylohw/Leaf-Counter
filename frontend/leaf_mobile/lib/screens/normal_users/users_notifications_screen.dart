import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class UsersNotificationsScreen extends StatefulWidget {
  const UsersNotificationsScreen({super.key});
  @override
  State<UsersNotificationsScreen> createState() =>
      _UserNotificationsScreenState();
}

class _UserNotificationsScreenState extends State<UsersNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [notifationComponent()]);
  }
}

Padding notifationComponent() {
  return Padding(
    padding: EdgeInsetsGeometry.only(top: 20, left: 7, right: 7),
    child: Container(
      padding: EdgeInsets.only(top: 10, left: 20),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lightGreen,
      ),
      child: Row(
        children: [
          Text(
            " tu reporte esta listo",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete, color: AppColors.stateRed, size: 50),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check, color: AppColors.meidumBlue, size: 50),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:leaf_mobile/screens/normal_users/users_menu_screen.dart';
import 'package:leaf_mobile/screens/normal_users/users_notifications_screen.dart';
import 'package:leaf_mobile/screens/normal_users/users_profile_screen.dart';
import 'package:leaf_mobile/screens/normal_users/users_reports_screen.dart';
import 'package:leaf_mobile/screens/normal_users/users_tracking_screen.dart';
/**
 * este widget funciona como router para las demas vistas del usuario de tipo comun entonces todas las vistas relacionadas se conectan en este archivo 
 * modicado por : Zylo ;D
 */
class UserScreenRouter extends StatefulWidget {
  const UserScreenRouter({super.key});
  @override
  State<UserScreenRouter> createState() => _UserScreenRouterState();
}

class _UserScreenRouterState extends State<UserScreenRouter> {
  int indexNavBottom = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indexNavBottom,
        children: [
          /**
           * Contiene las siguientes vistas:
           * menu
           * reportes
           * tracking(proximanete con el microcontrolador)
           * notificaciones
           * perfil
           */
          UsersMenuScreen(userName: "Pablo"),
          UsersReportsScreen(),
          UsersTrackingScreen(),
          UsersNotificationsScreen(),
          UsersProfileScreen()

        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState(() {
            indexNavBottom = index;
          });
        },
        selectedIndex: indexNavBottom,
        indicatorColor: AppColors.lightBlue,
        backgroundColor: AppColors.alternativeBackground,
        destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Menú"),
        NavigationDestination(icon: Icon(Icons.file_open), label: "Reportes"),
        NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: "Tracing"),
        NavigationDestination(icon: Icon(Icons.notifications), label: "Avisos"),
        NavigationDestination(icon: Icon(Icons.person), label: "Perfil")
      ]),  
    
      
    );
  }
}

import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';
import 'package:leaf_mobile/screens/maintenance_staff/mstaff_home_screen.dart';
import 'package:leaf_mobile/screens/maintenance_staff/mstaff_input_screen.dart';
import 'package:leaf_mobile/screens/maintenance_staff/mstaff_list_checked_screen.dart';
import 'package:leaf_mobile/screens/maintenance_staff/mstaff_notifications_screen.dart';

class MstaffScreenRouter extends StatefulWidget {
  const MstaffScreenRouter({super.key});

  @override
  State<MstaffScreenRouter> createState() => _MstaffScreenRouterState();
}

class _MstaffScreenRouterState extends State<MstaffScreenRouter> {
  int indexNav = 0;
  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: IndexedStack(index: indexNav, children: [
        /**
         * Contiene las siguientes vistas:
         * Menu
         * checklist de casas por revisar
         * vista par tomar las fotos y editar mediante un formulario
         * notificaciones 
         * Perfil
         */

        MstaffHomeScreen(),
        MstaffListCheckedScreen(),
        MstaffInputScreen(),
        MstaffNotificationsScreen()
      ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indexNav,
        indicatorColor: AppColors.lightBlue,
        backgroundColor: AppColors.alternativeBackground,
        onDestinationSelected: (int index){
          setState(() {
            indexNav = index;
          });
        },
        destinations:[
        NavigationDestination(icon: Icon(Icons.home), label: "Menu"),
        NavigationDestination(icon: Icon(Icons.list_alt_rounded), label: "Lecturas"),
        NavigationDestination(icon: Icon(Icons.camera_alt,), label: "Reporte",),
        NavigationDestination(icon: Icon(Icons.notifications), label: "Avisos"),
        NavigationDestination(icon: Icon(Icons.person), label: "Perfil"),
      ]),
    );
  }
}

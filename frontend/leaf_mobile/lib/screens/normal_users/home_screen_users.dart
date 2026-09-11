import 'package:flutter/material.dart';
import 'package:leaf_mobile/widgets/info_container.dart';
import 'package:leaf_mobile/widgets/navigator_bar.dart';

class HomeScreenUsers extends StatefulWidget {
  const HomeScreenUsers({super.key});
  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InfoContainer(),
      bottomNavigationBar: NavigatorBar(
        icon1: Icon(Icons.home),
        icon2: Icon(Icons.file_copy_sharp),
        icon3: Icon(Icons.graphic_eq),
        icon4: Icon(Icons.notifications),
        icon5: Icon(Icons.person),
        label1: "Home",
        label2: "Reportes",
        label3: "Tracking",
        label4: "Avisos",
        label5: "Perfil",
      ),
    );
  }
}

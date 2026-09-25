import 'package:flutter/material.dart';
import 'package:leaf_mobile/core/app_colors.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  DateTime? fechaLectura;

  final TextEditingController indicacionesController =
      TextEditingController();

  @override
  void dispose() {
    indicacionesController.dispose();
    super.dispose();
  }

  Future<void> seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaLectura ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: "Seleccione la fecha de lectura",
      cancelText: "Cancelar",
      confirmText: "Aceptar",
    );

    if (fecha != null) {
      setState(() {
        fechaLectura = fecha;
      });
    }
  }

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
          "Programación de lecturas",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          child: Text(
            "Configure las fechas en las que el personal de mantenimiento deberá realizar las lecturas de los contadores.",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
            ),
          ),
        ),

        formProgramacionLecturas(
          context,
          fechaLectura,
          seleccionarFecha,
          indicacionesController,
        ),
      ],
    );
  }
}

Padding formProgramacionLecturas(
  BuildContext context,
  DateTime? fecha,
  VoidCallback seleccionarFecha,
  TextEditingController indicacionesController,
) {
  String fechaTexto = fecha == null
      ? "Seleccione una fecha"
      : "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";

  return Padding(
    padding: EdgeInsets.only(top: 20),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.alternativeBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nueva programación",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child: Text(
              "Fecha de lectura:",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryText,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(
                Icons.calendar_month,
                color: AppColors.meidumBlue,
                size: 30,
              ),
              title: Text(
                fechaTexto,
                style: TextStyle(fontSize: 17),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.meidumBlue,
              ),
              onTap: seleccionarFecha,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              "Indicaciones para mantenimiento:",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryText,
              ),
            ),
          ),

          TextFormField(
            controller: indicacionesController,
            maxLines: 4,
            cursorColor: AppColors.meidumBlue,
            decoration: InputDecoration(
              hintText: "Ingrese indicaciones adicionales",
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.meidumBlue,
                  width: 2,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 30),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.save),
                label: Text(
                  "Guardar programación",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
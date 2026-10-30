import 'package:flutter/rendering.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService 
{
  static const digitosEnteros = 5;
  static const digitosDecimales = 1;
  final TextRecognizer _reconocedor =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<List<String>> leerNumeros(String rutaImagen) async {
    final imagen = InputImage.fromFilePath(rutaImagen); // recibe la ruta de la imagen que la app ya toma foto 
    final resultado = await _reconocedor.processImage(imagen); // reconoce lo que puede leer de la imagen y separa dicha iformación en bloques

    final candidatos = <String>[];

    for (final bloque in resultado.blocks) {
      for (final linea in bloque.lines) {
        final soloDigitos = linea.text.replaceAll(RegExp(r'[^0-9]'), '');
        debugPrint('OCR línea: "${linea.text}" → $soloDigitos');

        if (soloDigitos.length == digitosEnteros + digitosDecimales) {
          candidatos.add(soloDigitos);
        }
      }
    }

    return candidatos.toSet().toList();
  }

  void cerrar() => _reconocedor.close();
}
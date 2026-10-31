import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService 
{
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = String.fromEnvironment
  (
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? token;

  Map<String, dynamic>? usuario;

  Future<void> iniciarSesion(
    String correo,
    String contrasena,
  ) 
  async 
  {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'correo': correo,
            'contrasena': contrasena,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        data['mensaje'] ?? 'No se pudo iniciar sesión',
      );
    }

    final String nuevoToken = data['token'];

    final Map<String, dynamic> nuevoUsuario =
        Map<String, dynamic>.from(data['usuario']);

    await storage.write(
      key: 'leaf_token',
      value: nuevoToken,
    );

    await storage.write(
      key: 'leaf_usuario',
      value: jsonEncode(nuevoUsuario),
    );

    token = nuevoToken;

    usuario = nuevoUsuario;
  }

  Future<void> recuperarSesion() async {
    token = await storage.read(key: 'leaf_token');

    final String? usuarioGuardado = await storage.read(
      key: 'leaf_usuario',
    );

    if (usuarioGuardado != null) {
      usuario = Map<String, dynamic>.from(
        jsonDecode(usuarioGuardado),
      );
    }
  }

  Future<void> cerrarSesion() async {
    await storage.delete(key: 'leaf_token');

    await storage.delete(key: 'leaf_usuario');

    token = null;

    usuario = null;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    return procesarRespuesta(response);
  }

  Future<Uint8List> descargarArchivo(String endpoint) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    String mensaje = 'No se pudo descargar el archivo';

    try {
      final data = jsonDecode(response.body);
      mensaje = data['mensaje']?.toString() ?? mensaje;
    } catch (_) {}

    throw Exception(mensaje);
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    return procesarRespuesta(response);
  }

  Future<Map<String, dynamic>> postConArchivo(
    String endpoint,
    Map<String, String> campos,
    File archivo,
    String nombreCampo,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll(campos);

    request.files.add(
      await http.MultipartFile.fromPath(
        nombreCampo,
        archivo.path,
      ),
    );

    final streamed = await request.send().timeout(
          const Duration(seconds: 60),
        );

    final response = await http.Response.fromStream(streamed);

    return procesarRespuesta(response);
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    return procesarRespuesta(response);
  }

  Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .patch(
          Uri.parse('$baseUrl$endpoint'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    return procesarRespuesta(response);
  }

  Map<String, dynamic> procesarRespuesta(
    http.Response response,
  ) 
  {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(
      data['mensaje'] ?? 'Error al realizar la solicitud',
    );
  }
} 
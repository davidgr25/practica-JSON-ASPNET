import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductoService {
  static const String baseUrl = 'http://localhost:5030/api/productos';

  // RF1: Obtener catálogo
  Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(response.body);
      return datos.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  // RF2 & RF3: Registrar nuevo producto
  Future<Producto> registrarProducto(String nombre, double precio) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre': nombre, 'precio': precio}),
    );

    if (response.statusCode == 201) {
      return Producto.fromJson(jsonDecode(response.body));
    } else {
      // Si el servidor responde 400 Bad Request u otro error
      final body = jsonDecode(response.body);
      throw Exception(body['mensaje'] ?? 'Error al registrar producto');
    }
  }
}
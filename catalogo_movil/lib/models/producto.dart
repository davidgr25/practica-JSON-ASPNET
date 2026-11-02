class Producto {
  final int id;
  final String nombre;
  final double precio;
  final bool disponible;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.disponible,
  });

  // 1. DESERIALIZACIÓN (De JSON a Dart)
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      disponible: json['disponible'] as bool,
    );
  }

  // 2. SERIALIZACIÓN (De Dart a formato Map para JSON)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'precio': precio,
    };
  }
}
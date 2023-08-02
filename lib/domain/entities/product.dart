
import 'package:flutter/services.dart';

class Product {
  final int id;
  final String nombre;
  final double precio;
  final int marcaId;
  final String marca;
  final int categoriaId;
  final String categoria;
  final String codigoBarra;
  final String codigoQr;
  final List<int> imagenUrl;

  Product(
    this.id,
    this.nombre,
    this.precio,
    this.marcaId,
    this.marca,
    this.categoriaId,
    this.categoria,
    this.codigoBarra,
    this.codigoQr,
    this.imagenUrl

  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'marcaId': marcaId,
      'marca': marca,
      'categoriaId': categoria,
      'categoria': categoria,
      'codigoBarra': codigoBarra,
      'codigoQr': codigoQr,
      'imagenurl': imagenUrl

    };
  }
}

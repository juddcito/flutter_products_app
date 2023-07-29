// Objetivo: Leer diferentes modelos y crear mi entidad Product

import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/product_details_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/products_sactidb.dart';
class ProductMapper {
  
  static Product sactiResponseToEntity(ProductSactiDb response) => Product(
    response.id,
    response.nombre, 
    response.precio,
    response.marcaId,
    response.marca,
    response.categoriaId,
    response.categoria,
    response.codigoBarra,
    response.codigoQr,
    response.imagenUrl
  );

  static Product productDetailsToEntity ( ProductDetails product ) => Product(
    product.id,
    product.nombre, 
    product.precio.toDouble(),
    product.marca.id,
    product.marca.nombre,
    product.categoria.id,
    product.categoria.nombre,
    product.codigoBarra,
    product.codigoQr,
    product.imagenUrl
  );

}

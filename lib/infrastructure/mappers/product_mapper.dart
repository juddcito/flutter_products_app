// Objetivo: Leer diferentes modelos y crear mi entidad Product

import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/product_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/sactidb_response.dart';

class ProductMapper {
  static Product sactiResponseToEntity(ProductSactiDb response) => Product(
    response.id,
    response.nombre, 
    response.precio,
    response.marcaId,
    response.marca,
    response.categoriaId,
    response.categoria
  );
}

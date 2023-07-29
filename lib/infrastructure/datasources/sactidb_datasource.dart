import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_products_app/domain/datasources/products_datasource.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/infrastructure/mappers/product_mapper.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/categories_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/marcas_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/product_details_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/products_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/sactidb_response.dart';
import 'package:flutter_products_app/domain/entities/category.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/searched_products.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/marca.dart';

class SactiDbDatasource extends ProductDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.128:120/api/productos',
  ));

  // Para consultar marcas y categorías
  final dio2 = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.128:120/api',
  ));

  @override
  Future<List<Product>> getProducts({int pageIndex = 1}) async {

    final response = await dio.get('/', queryParameters: {'pageIndex': pageIndex});

    final sactiDbResponse = SactiDbResponse.fromJson(response.data);

    final List<Product> products = sactiDbResponse.registers
        .map(
            (sactiProduct) => ProductMapper.sactiResponseToEntity(sactiProduct))
        .toList();

    return products;

  }

  @override
  Future<Product> getProductById(String productId) async {
    final response = await dio.get('/$productId');

    if (response.statusCode != 200)
      throw Exception('Producto con id: $productId no encontrado');

    final productDetails = ProductDetails.fromJson(response.data);
    final Product product =
        ProductMapper.productDetailsToEntity(productDetails);
    return product;
  }

  @override
  Future<bool> deleteProductById(String productId) async {
    bool isDeleted = false;

    try {
      final response = await dio.delete('/$productId');
      print('Respuesta exitosa: ${response.statusCode}');
      isDeleted = true;
      return isDeleted;
    } catch (e) {
      print('Error durante la solicitud HTTP: $e');
      return isDeleted;
    }
  }

  @override
  Future<List<Categoryy>> getCategories() async {
    try {
      final response = await dio2.get('/categorias');
      List<dynamic> jsonData = response.data;
      List<CategorySactiDb> categoriesDb =
          jsonData.map((item) => CategorySactiDb.fromJson(item)).toList();
      List<Categoryy> categories = categoriesDb
          .map((dbItem) => Categoryy(dbItem.id, dbItem.nombre))
          .toList();
      return categories;
    } catch (e) {
      print('Ocurrió un error: $e');
      return [];
    }
  }

  @override
  Future<List<Marca>> getMarcas() async {
    try {
      final response = await dio2.get('/marcas');
      List<dynamic> jsonData = response.data;
      List<MarcaSactiDb> marcasDb =
          jsonData.map((item) => MarcaSactiDb.fromJson(item)).toList();
      List<Marca> marcasList =
          marcasDb.map((marca) => Marca(marca.id, marca.nombre)).toList();
      return marcasList;
    } catch (e) {
      return [];
    }
  }

  // /api/productos/$idProducto
  @override
  Future<void> updateProduct(Product product) async {
    try {
      final response = await dio.put('/${product.id}', data: {
        'id': product.id,
        'nombre': product.nombre,
        'precio': product.precio,
        'marcaId': product.marcaId,
        'categoriaId': product.categoriaId,
        'codigoBarra': product.codigoBarra,
        'codigoQr': product.codigoQr,
        'imagenurl': product.imagenUrl
      });

      if (response.statusCode == 200) {
        print('Petición PUT exitosa: ${response.data}');
      } else {
        print('Error en la petición PUT: {$response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Future<void> postProduct(Map<String,dynamic> product) async {

    try {
      final response = await dio.post('', data: 
      {
        'nombre': product['nombre'],
        'precio': product['precio'],
        'marcaId': product['marcaId'],
        'categoriaId': product['categoriaId'],
        'codigoBarra': product['codigoBarra'],
        'codigoQr': product['codigoQr'],
        'imagen': product['imagen'],
      });

      if (response.statusCode == 201) {
        print('Petición POST exitosa: ${response.data}');
      } else {
        print('Error en la petición POST: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Future<List<Product>> searchProducts( String search ) async {

    try {

      if ( search.isEmpty ) return [];

      final response = await dio.get('',
      queryParameters: {
        'search': search,
        'ver': '1.1'
      }
    );
  
    List<dynamic> jsonData = response.data;
    List<SearchedProduct> searchedProducts = jsonData
    .map((product) => SearchedProduct.fromJson(product)).toList();
    List<Product> products = searchedProducts
          .map((product) => Product(
            product.id,
            product.nombre,
            product.precio.toDouble(),
            product.marca.id.toInt(),
            product.marca.nombre,
            product.categoria.id.toInt(),
            product.categoria.nombre,
            product.codigoBarra,
            product.codigoQr,
            product.imagenUrl
            
      )
    ).toList();
    return products;

    } catch (e) {
      print('Ocurrió un error buscando productos: $e');
      return [];
    }

  }

  /*@override
  Future<Product> getProductById({int productId = 1}) async {
    final response = await dio.get('/$productId');

    if ( response.statusCode != 200 ) throw Exception('Producto con id: $productId no encontrado');

    final productDetails = ProductDetails.fromJson(response.data);

    final Product product = ProductMapper.productDetailsToEntity(productDetails);

    return product;

  }
  */
}

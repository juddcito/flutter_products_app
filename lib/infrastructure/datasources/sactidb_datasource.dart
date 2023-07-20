

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_products_app/domain/datasources/products_datasource.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/infrastructure/mappers/product_mapper.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/categories_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/product_details_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/sactidb_response.dart';
import 'package:flutter_products_app/domain/entities/category.dart';

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
    
    final response = await dio.get('/',
    queryParameters: {
      'pageIndex': pageIndex
    });
    
    final sactiDbResponse = SactiDbResponse.fromJson(response.data);

    final List<Product> products = sactiDbResponse.registers.map(
      (sactiProduct) => ProductMapper.sactiResponseToEntity(sactiProduct)
    ).toList();

    return products;
  }
  
  @override
  Future<Product> getProductById( String productId ) async {

    final response = await dio.get('/$productId');

    if ( response.statusCode != 200 ) throw Exception( 'Producto con id: $productId no encontrado');

    final productDetails = ProductDetails.fromJson( response.data );
    final Product product = ProductMapper.productDetailsToEntity(productDetails);
    return product;

  }

  @override
  Future<bool> deleteProductById( String productId ) async {

    bool isDeleted = false;

    try{
      final response = await dio.delete('/$productId');
      print('Respuesta exitosa: ${response.statusCode}');
      isDeleted = true;
      return isDeleted;
    } catch ( e ) {
      print('Error durante la solicitud HTTP: $e');
      return isDeleted;
    }

  }
  
  @override
  Future<List<Categoryy>> getCategories() async {
    try {
      final response = await dio2.get('/categorias');
      List<dynamic> jsonData = response.data;
      List<CategorySactiDb> categoriesDb = jsonData.map((item) =>
       CategorySactiDb.fromJson(item)).toList();
      List<Categoryy> categories = categoriesDb.map((dbItem) => Categoryy(dbItem.id, dbItem.nombre)).toList();
      return categories;
    } catch ( e ) {

      print('Ocurrió un error: $e');
      return [];

    }
  }
  
  @override
  Future<List<String>> getMarcas() async {
    // TODO: implement getMarcas
    throw UnimplementedError();
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
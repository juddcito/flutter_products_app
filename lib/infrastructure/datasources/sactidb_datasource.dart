import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products_app/domain/datasources/products_datasource.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/infrastructure/mappers/product_mapper.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/categories_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/marcas_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/product_details_sactidb.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/sactidb_response.dart';
import 'package:flutter_products_app/domain/entities/category.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/searched_products.dart';

import '../../domain/entities/marca.dart';

class SactiDbDatasource extends ProductDatasource {
  // Para GET de productos
  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.128:6001/api/productos',
  ));

  // Para GET de marcas y categorías
  final dio2 = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.128:120/api',
  ));

  // Para PUT de productos
  final dio3 = Dio(BaseOptions(
      baseUrl: 'http://192.168.0.128:120/api/productos',
      queryParameters: {'ver': '1.1'}));

  // Para POST de productos
  final dio4 = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.128:6001/api/productos/prod',
  ));

  @override
  Future<List<Product>> getProducts({int pageIndex = 1}) async {
    final response =
        await dio.get('/', queryParameters: {'pageIndex': pageIndex});

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
  Future<void> updateProduct(Product product, String photoPath) async {
    Uint8List imageBytes;

    if (photoPath == "" && product.imagenUrl.isEmpty) {
      ByteData defaultImageBytes =
          await rootBundle.load('assets/loaders/no_image.png');
      imageBytes = defaultImageBytes.buffer.asUint8List();
    } else if (photoPath == "" && product.imagenUrl.isNotEmpty) {
      imageBytes = Uint8List.fromList(product.imagenUrl);
    } else {
      imageBytes = File(photoPath).readAsBytesSync();
    }

    try {
      FormData data = FormData.fromMap({
        'ProductoDto': {
          'id': product.id,
          'nombre': product.nombre,
          'precio': product.precio,
          'marcaId': product.marcaId,
          'categoriaId': product.categoriaId,
          'codigoBarra': product.codigoBarra,
          'codigoQr': product.codigoQr,
        },
        'ImagenCarga':
            MultipartFile.fromBytes(imageBytes, filename: '${product.id}.jpg')
      });

      final response = await dio3.put('',
          data: data, options: Options(contentType: 'multipart/form-data'));
      print(response);

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
  Future<void> postProduct(Map<String, dynamic> product, String photoPath) async {
    final String productName = product["nombre"];
    FormData data;
    File imageFile = File('');
    final dynamic response;

    try {
      if (photoPath.isNotEmpty) {
        imageFile = File(photoPath);
      }

      data = FormData.fromMap({
        if (photoPath != '')
          'ImagenCarga': MultipartFile.fromBytes(imageFile.readAsBytesSync(),
              filename: '$productName.jpg'),
        'ProductoDto': {
          'nombre': product["nombre"],
          'precio': product["precio"],
          'marcaId': product["marcaId"],
          'categoriaId': product["categoriaId"],
          'codigoBarra': product["codigoBarra"],
          'codigoQr': product["codigoQr"],
        }
      });

      if (photoPath.isEmpty) {
         response = await dio4.post('',
            data: data, options: Options(contentType: 'multipart/form-data'));
      } else {
         response = await dio.post('',
            data: data, options: Options(contentType: 'multipart/form-data'));
      }

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
  Future<List<Product>> searchProducts(String search) async {
    try {
      if (search.isEmpty) return [];

      final response =
          await dio.get('', queryParameters: {'search': search, 'ver': '1.1'});

      List<dynamic> jsonData = response.data;
      List<SearchedProduct> searchedProducts =
          jsonData.map((product) => SearchedProduct.fromJson(product)).toList();
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
              product.imagenUrl))
          .toList();
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

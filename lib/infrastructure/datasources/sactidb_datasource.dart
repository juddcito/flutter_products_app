

import 'package:dio/dio.dart';
import 'package:flutter_products_app/domain/datasources/products_datasource.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/infrastructure/mappers/product_mapper.dart';
import 'package:flutter_products_app/infrastructure/models/sactidb/sactidb_response.dart';

class SactiDbDatasource extends ProductDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.128:5001/api/productos/',
  ));

  @override
  Future<List<Product>> getProducts({int pageIndex = 1}) async {
    
    final response = await dio.get('',
    queryParameters: {
      'pageIndex': pageIndex
    });
    
    final sactiDbResponse = SactiDbResponse.fromJson(response.data);

    print('Dio: $dio');

    final List<Product> products = sactiDbResponse.registers.map(
      (sactiProduct) => ProductMapper.sactiResponseToEntity(sactiProduct)
    ).toList();

    print(products[1].id);
    return products;
  }

}
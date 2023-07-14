

import 'package:flutter_products_app/domain/datasources/products_datasource.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/domain/repositories/products_repository.dart';

class ProductRepositoryImpl extends ProductsRepository {

  final ProductDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts({int pageIndex = 1}) {
    return this.datasource.getProducts(pageIndex: pageIndex);
  }

}
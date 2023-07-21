

import 'package:flutter_products_app/domain/datasources/products_datasource.dart';
import 'package:flutter_products_app/domain/entities/product.dart';
import 'package:flutter_products_app/domain/repositories/products_repository.dart';

class ProductRepositoryImpl extends ProductsRepository {

  final ProductDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts({int pageIndex = 1}) {
    return datasource.getProducts(pageIndex: pageIndex);
  }
  
  @override
  Future<Product> getProductById(String productId) {
    return datasource.getProductById(productId);
  }

  @override
  Future<bool> deleteProductById( String productId ){
    return datasource.deleteProductById(productId);
  }
  
  @override
  Future<void> updateProduct(Product product) {
    return datasource.updateProduct(product);
  }

  @override
  Future<void> postProduct(Map<String,dynamic> product) {
    return datasource.postProduct(product);
  }
  
}
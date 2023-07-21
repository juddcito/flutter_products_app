

import 'package:flutter_products_app/domain/entities/product.dart';

abstract class ProductDatasource {

  Future<List<Product>>  getProducts({ int pageIndex = 1 }  );
  Future<Product> getProductById( String productId );
  Future<bool> deleteProductById( String productId );
  Future<void> updateProduct( Product product );
  Future<void> postProduct( Map<String,dynamic> product );

}
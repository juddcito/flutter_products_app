import 'package:flutter_products_app/domain/entities/product.dart';

abstract class ProductsRepository {

  Future<List<Product>>  getProducts({ int pageIndex = 1 }  );

}
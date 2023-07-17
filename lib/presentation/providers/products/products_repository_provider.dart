

import 'package:flutter_products_app/infrastructure/datasources/sactidb_datasource.dart';
import 'package:flutter_products_app/infrastructure/repositories/product_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Este repositorio es inmutable
final productRepositoryProvider = Provider((ref) {

  return ProductRepositoryImpl(SactiDbDatasource());

});
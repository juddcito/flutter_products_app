

import 'package:flutter_products_app/infrastructure/datasources/sactidb_datasource.dart';
import 'package:flutter_products_app/infrastructure/repositories/categories_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesRepositoryProvider = Provider((ref) {

  return CategoryRepositoryImpl(SactiDbDatasource());

});
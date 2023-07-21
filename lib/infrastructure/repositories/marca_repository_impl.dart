

import 'package:flutter_products_app/domain/repositories/marcas_repository.dart';
import 'package:flutter_products_app/infrastructure/datasources/sactidb_datasource.dart';
import '../../domain/entities/marca.dart';

class MarcasRepositoryImpl extends MarcasRepository {

  final SactiDbDatasource datasource;

  MarcasRepositoryImpl(this.datasource);


  @override
  Future<List<Marca>> getMarcas() {
    return datasource.getMarcas();
  }

}
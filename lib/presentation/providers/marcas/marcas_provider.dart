
import 'package:flutter_products_app/presentation/providers/marcas/marcas_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/marca.dart';

final marcasProvider = StateNotifierProvider<MarcasNotifier, List<Marca>>((ref) {

  final fetchMarcas = ref.watch(marcasRepositoryProvider ).getMarcas;

  return MarcasNotifier(fetchMarcas: fetchMarcas);

});

typedef MarcasCallback = Future<List<Marca>> Function();

class MarcasNotifier extends StateNotifier<List<Marca>> {

  final MarcasCallback fetchMarcas;

  MarcasNotifier({required this.fetchMarcas}): super([]);

  Future<void> loadMarcas() async {

    if (state.isNotEmpty) return;

    final List<Marca> marcas = await fetchMarcas();
    state = [...state, ...marcas];

  }

}

final selectedMarcaProvider = StateProvider<String>((ref) => '');
final selectedIdMarcaProvider = StateProvider<int>((ref) => 0);
import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/marca.dart';
import '../../../domain/entities/product.dart';
import '../../providers/categories/categories_provider.dart';
import '../../providers/marcas/marcas_provider.dart';
import '../../widgets/marcas/marcas_dropdown.dart';

class ProductCreateScreen extends ConsumerStatefulWidget {
  static const name = 'product_create_screen';
  const ProductCreateScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends ConsumerState<ProductCreateScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(categoriesProvider.notifier).loadCategories();
    ref.read(marcasProvider.notifier).loadMarcas();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final categories = ref.watch(categoriesProvider);
    final marcas = ref.watch(marcasProvider);

    @override
    Map<String, dynamic> buildProduct() {
      final int? selectedIdCategory = ref.read(selectedIdCategoriaProvider);
      final int selectedIdMarca = ref.read(selectedIdMarcaProvider);
      final String productName = ref.read(productNameProvider);
      final double productPrice = ref.read(productPriceProvider);
      DateTime currentDate = DateTime.now();
      String formattedDate = currentDate.toLocal().toString().split(' ')[0];

      final Map<String, dynamic> product = {
        'nombre': productName,
        'precio': productPrice,
        'fechaCreacion': formattedDate,
        'marcaId': selectedIdMarca,
        'categoriaId': selectedIdCategory
      };

      return product;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined))
        ],
        title: const Text('Agregar producto',
            style: TextStyle(color: Colors.white)),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      body: _ProductCreateView(marcas: marcas, categories: categories),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          final product = buildProduct();
          ref.read(productsProvider.notifier).postProductByProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto creado exitosamente.')));
        },
        child: const Icon(Icons.save_as_sharp),
      ),
    );
  }
}

class _ProductCreateView extends ConsumerStatefulWidget {
  final List<Categoryy> categories;
  final List<Marca> marcas;

  const _ProductCreateView({
    super.key,
    required this.categories,
    required this.marcas,
  });

  @override
  __ProductCreateViewState createState() => __ProductCreateViewState();
}

class __ProductCreateViewState extends ConsumerState<_ProductCreateView> {
  final nombreController = TextEditingController();
  final marcaController = TextEditingController();
  final categoriaController = TextEditingController();
  final precioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreController.addListener(() {
      String? name;
      try {
        name = nombreController.text;
      } catch (e) {
        name = '';
      }
      ref.read(productNameProvider.notifier).state = name;
    });
    precioController.addListener(() {
      double? price;
      try {
        price = double.parse(precioController.text);
      } catch (e) {
        price = 0;
      }
      ref.read(productPriceProvider.notifier).state = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              const SizedBox(
                width: double.infinity,
                height: 200,
                child: Card(
                    child: Icon(
                  Icons.no_photography_outlined,
                  size: 128,
                )),
              ),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.propane_tank_outlined),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 32,
              ),
              MarcasDropdown(marcas: widget.marcas),
              const SizedBox(
                height: 32,
              ),
              CategoriesDropdown(categories: widget.categories),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

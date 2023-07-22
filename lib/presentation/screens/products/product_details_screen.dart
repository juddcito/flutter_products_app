import 'package:flutter/material.dart';
import 'package:flutter_products_app/config/router/app_router.dart';
import 'package:flutter_products_app/presentation/providers/categories/categories_provider.dart';
import 'package:flutter_products_app/presentation/providers/marcas/marcas_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_products_app/presentation/widgets/marcas/marcas_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/marca.dart';
import '../../../domain/entities/product.dart';
import '../../widgets/widgets.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {

  static const name = 'product_details_screen';

  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ProductDetailsScreenState createState() => ProductDetailsScreenState();
}

class ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {

  @override
  void initState() {
    super.initState();
    ref.read( productInfoProvider.notifier ).loadProduct( widget.productId );
    ref.read( categoriesProvider.notifier ).loadCategories();
    ref.read( marcasProvider.notifier ).loadMarcas();
  }

  @override
  Widget build(BuildContext context) {

    final Product? product = ref.watch( productInfoProvider )[widget.productId];

    // TODO Implementar providers para el nombre y precio del producto para el POST

    final colors = Theme.of(context).colorScheme;

    
    final categories = ref.watch( categoriesProvider );
    final marcas = ref.watch( marcasProvider );

    final String selectedCategory = ref.watch( selectedCategoriaProvider);
    final int selectedIdCategory = ref.watch( selectedIdCategoriaProvider );
    final String selectedMarca = ref.watch( selectedMarcaProvider );
    final int selectedIdMarca = ref.watch( selectedIdMarcaProvider );


    if( product == null ) {
      return Scaffold(appBar: AppBar( backgroundColor: colors.primary, foregroundColor: Colors.white, title: const Text('Detalles del producto'),),body: const Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Detalles del producto',
              style: TextStyle(color: Colors.white)),
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
        ),
        body: _ProductDetailsView(product: product, categories: categories, marcas: marcas),
        floatingActionButton: SpeedDial(
          overlayOpacity: 0.8,
          spacing: 15,
          spaceBetweenChildren: 15,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.save),
              label: 'Guardar',
              onTap: () async {

                Product updatedProduct = Product(
                  product.id,
                  product.nombre,
                  product.precio,
                  selectedIdMarca,
                  selectedMarca,
                  selectedIdCategory,
                  selectedCategory,
                );

                print('Selected IDMarca: $selectedIdMarca y SelectedMarca: $selectedMarca');
                ref.watch( productsProvider.notifier ).updateProduct(updatedProduct);
             
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Producto guardado correctamente.')));
              },
            ),
            SpeedDialChild(
              onTap: () async {
                
                final isDeleted = await ref.watch( productsProvider.notifier ).deleteProductById(widget.productId);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Producto eliminado correctamente.')
                ),
              );
              context.pop();
              },
                backgroundColor: Colors.red.shade100,
                child: const Icon(Icons.delete),
                label: 'Eliminar'),
          ],
        ));
  }
}

class _ProductDetailsView extends ConsumerStatefulWidget {

  final Product product;
  final List<Categoryy> categories;
  final List<Marca> marcas;

  const _ProductDetailsView({required this.product, required this.categories, required this.marcas});

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState(

  );

}

class _ProductDetailsViewState extends ConsumerState<_ProductDetailsView> {

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.product.nombre;
    precioController.text = widget.product.precio.toString();
  }

  final nombreController = TextEditingController();
  final precioController = TextEditingController();

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
              MarcasDropdown(marcas: widget.marcas, marcaId: widget.product.marcaId.toString()),
              const SizedBox(
                height: 32,
              ),
              CategoriesDropdown(categories: widget.categories, categoryId: widget.product.categoriaId.toString()),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder()
                ),
                keyboardType: const TextInputType.numberWithOptions(),
              ),
            ],
          ),  
        ),
      ],
    );
  }
}




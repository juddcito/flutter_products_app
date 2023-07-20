import 'package:flutter/material.dart';
import 'package:flutter_products_app/config/router/app_router.dart';
import 'package:flutter_products_app/presentation/providers/categories/categories_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';

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
  }


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final Product? product = ref.watch( productInfoProvider )[widget.productId];
    final categories = ref.watch( categoriesProvider );


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
        body: _ProductDetailsView(product: product, categories: categories),
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Producto guardado correctamente.')));
              },
            ),
            SpeedDialChild(
              onTap: () async {
                
                final isDeleted = await ref.read( productsProvider.notifier ).deleteProductById(widget.productId);
                print('Valor de isDeleted : $isDeleted');
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

class _ProductDetailsView extends StatefulWidget {

  final Product product;
  final List<Categoryy> categories;

  const _ProductDetailsView({super.key, required this.product, required this.categories});

  @override
  State<_ProductDetailsView> createState() => _ProductDetailsViewState();
}


class _ProductDetailsViewState extends State<_ProductDetailsView> {

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.product.nombre;
    marcaController.text = widget.product.marca;
    categoriaController.text = widget.product.categoria;
    precioController.text = widget.product.precio.toString();

    
  }

  final nombreController = TextEditingController();
  final marcaController = TextEditingController();
  final categoriaController = TextEditingController();
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
              TextField(
                controller: marcaController,
                decoration: const InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder()),
              ),
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

class CategoriesDropdown extends StatefulWidget {

  final List<Categoryy> categories;
  final String categoryId;

  const CategoriesDropdown({super.key, required this.categories, required this.categoryId});

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdownState();
}

class _CategoriesDropdownState extends State<CategoriesDropdown> {

  Categoryy? selectedCategory;

  @override
  void initState() {
    super.initState();
    
    int selectedIndex = widget.categories.indexWhere(
      (category) => category.id.toString() == widget.categoryId
    );

    if( selectedIndex != -1 ){
      selectedCategory = widget.categories[selectedIndex];
    }

    print('Index: $selectedIndex');
  }
  
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme.labelLarge;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4)
      ),
      alignment: Alignment.center,
      height: 70,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Categoría',
          contentPadding: EdgeInsets.symmetric(horizontal: 8)
        ),
        child: DropdownButton<Categoryy>(
          isDense: true,
          isExpanded: true,
          onChanged: (Categoryy? newValue){
            setState(() {
              selectedCategory = newValue;
            });
          },
          value: selectedCategory,
          hint: const Text('Selecciona una categoría'),
          items: widget.categories.map<DropdownMenuItem<Categoryy>>((Categoryy category){
            return DropdownMenuItem<Categoryy>(
              value: category,
              
              child: Text(category.nombre, style: textStyle)
            );
          }).toList(),
          
        ),
      ),
    );
  }
}


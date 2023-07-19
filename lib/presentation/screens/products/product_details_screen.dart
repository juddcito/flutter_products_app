import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  }


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final Product? product = ref.watch( productInfoProvider )[widget.productId];

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
        body: _ProductDetailsView(product: product),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Producto guardado correctamente.')));
              },
            ),
            SpeedDialChild(
                backgroundColor: Colors.red.shade100,
                child: const Icon(Icons.delete),
                label: 'Eliminar'),
          ],
        ));
  }
}

class _ProductDetailsView extends StatefulWidget {

  final Product product;

  const _ProductDetailsView({super.key, required this.product});

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
                    prefixIcon: Icon(Icons.propane_tank_outlined),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: categoriaController,
                decoration: const InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.propane_tank_outlined),
                    border: OutlineInputBorder()),
              ),
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
                keyboardType: TextInputType.numberWithOptions(),
              ),
            ],
          ),  
        ),
      ],
    );
  }
  }


import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/product.dart';

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

    // Hacer la petición GET del producto


  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Agregar producto',
            style: TextStyle(color: Colors.white)),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      body: _ProductCreateView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon( Icons.save_as_sharp ),
      ),
    );
  
  }

}

class _ProductCreateView extends StatefulWidget {

  const _ProductCreateView({super.key});



  @override
  State<_ProductCreateView> createState() => __ProductCreateViewState();
}

class __ProductCreateViewState extends State<_ProductCreateView> {

  @override
  void initState() {
    super.initState();
    
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

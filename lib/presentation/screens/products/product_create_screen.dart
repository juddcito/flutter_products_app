import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/barcode/barcode_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/qr/qr_provider.dart';
import 'package:flutter_products_app/presentation/widgets/products/barcode_textfield.dart';
import 'package:flutter_products_app/presentation/widgets/products/qr_textfield.dart';
import 'package:flutter_products_app/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/marca.dart';
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
    final String barcode = '';
    final String qrcode = '';

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
            style: TextStyle(color: Colors.black)),
        backgroundColor: colors.background,
        foregroundColor: Colors.black,
      ),
      body: _ProductCreateView(marcas: marcas, categories: categories, barcode: barcode, qrCode: qrcode,),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade50,
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
  final String barcode;
  final String qrCode;

  const _ProductCreateView({
    super.key,
    required this.categories,
    required this.marcas,
    required this.barcode,
    required this.qrCode
  });

  @override
  __ProductCreateViewState createState() => __ProductCreateViewState();
}

class __ProductCreateViewState extends ConsumerState<_ProductCreateView> {
  
  final nombreController = TextEditingController();
  final marcaController = TextEditingController();
  final categoriaController = TextEditingController();
  final precioController = TextEditingController();
  final barcodeController = TextEditingController();
  final qrController = TextEditingController();

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
                decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: const Icon(Icons.propane_tank_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                ),
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
                decoration: InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                ),
                keyboardType: const TextInputType.numberWithOptions(),
              ),
              const SizedBox(
                height: 32,
              ),
              QrTextfield(qrController: qrController, qrcode: widget.qrCode),
              const SizedBox(
                height: 32,
              ),
              BarcodeTextfield(barcodeController: barcodeController, barcode: widget.barcode),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/barcode/barcode_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/qr/qr_provider.dart';
import 'package:flutter_products_app/presentation/widgets/products/barcode_textfield.dart';
import 'package:flutter_products_app/presentation/widgets/products/qr_textfield.dart';
import 'package:flutter_products_app/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/marca.dart';
import '../../../features/services/camera_gallery_service_impl.dart';
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
    String barcodeResult = ref.watch(barcodeProvider) != '' ? '' : ref.watch(barcodeProvider) ;
    String qrCode = ref.watch(qrProvider)  != '' ? '' : ref.watch(qrProvider) ;

    @override
    Map<String, dynamic> buildProduct() {
      final int? selectedIdCategory = ref.read(selectedIdCategoriaProvider);
      final int selectedIdMarca = ref.read(selectedIdMarcaProvider);
      final String productName = ref.read(productNameProvider);
      final double productPrice = ref.read(productPriceProvider);
      DateTime currentDate = DateTime.now();
      String formattedDate = currentDate.toLocal().toString().split(' ')[0];
      String barcode = ref.watch(barcodeProvider);
      String qrCode = ref.watch(qrProvider);

      final Map<String, dynamic> product = {
        'nombre': productName,
        'precio': productPrice,
        'fechaCreacion': formattedDate,
        'marcaId': selectedIdMarca,
        'categoriaId': selectedIdCategory,
        'codigoBarra': barcode,
        'codigoQr': qrCode
      };

      return product;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final photoPath = await CameraGalleryServiceImpl().takePhoto();
                if (photoPath == null) return;
                ref.read(productImageProvider.notifier).state = photoPath;
              },
              icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(
                        scanType: ScanType.qr,
                      ),
                    ));

                if (res is String) {
                  ref.read(qrProvider.notifier).update((state) => res);
                }
              },
              icon: const Icon(Icons.qr_code)),
          IconButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));

                if (res is String) {
                  ref.read(barcodeProvider.notifier).update((state) => res);
                }
              },
              icon: const Icon(Icons.barcode_reader))
        ],
        title: const Text('Registrar', style: TextStyle(color: Colors.black)),
        backgroundColor: colors.background,
        foregroundColor: Colors.black,
      ),
      body: _ProductCreateView(
          marcas: marcas,
          categories: categories,
          barcode: barcodeResult,
          qrCode: qrCode),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade50,
        shape: const CircleBorder(),
        onPressed: () {
          final product = buildProduct();
          final photoPath = ref.read(productImageProvider);
          ref.read(productsProvider.notifier).postProductByProduct(product, photoPath);
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

  const _ProductCreateView(
      {super.key,
      required this.categories,
      required this.marcas,
      required this.barcode,
      required this.qrCode});

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
    final String image = ref.watch(productImageProvider);
    late ImageProvider imageProvider;

    if (image == '') {
      imageProvider = const AssetImage('assets/loaders/no_image.png');
    } else {
      imageProvider = FileImage(File(image));
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      )),
                ),
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
                        borderRadius: BorderRadius.circular(20))),
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
                        borderRadius: BorderRadius.circular(20))),
                keyboardType: const TextInputType.numberWithOptions(),
              ),
              const SizedBox(
                height: 32,
              ),
              QrTextfield(
                qrController: qrController,
                qrcode: widget.qrCode
              ),
              const SizedBox(
                height: 32,
              ),
              BarcodeTextfield(
                  barcodeController: barcodeController,
                  barcode: widget.barcode),
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

import 'dart:ffi';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter_products_app/features/services/camera_gallery_service_impl.dart';
import 'package:flutter_products_app/presentation/providers/barcode/barcode_provider.dart';
import 'package:flutter_products_app/presentation/providers/categories/categories_provider.dart';
import 'package:flutter_products_app/presentation/providers/marcas/marcas_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/product_info_provider.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/qr/qr_provider.dart';
import 'package:flutter_products_app/presentation/widgets/marcas/marcas_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/marca.dart';
import '../../../domain/entities/product.dart';
import '../../widgets/products/barcode_textfield.dart';
import '../../widgets/products/qr_textfield.dart';
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
    ref.read(productInfoProvider.notifier).loadProduct(widget.productId);
    ref.read(categoriesProvider.notifier).loadCategories();
    ref.read(marcasProvider.notifier).loadMarcas();
  }

  void uploadPhoto(Product product, String photoPath) async {
    
    File imageFile = File(photoPath);

    try {
      final dio = Dio(BaseOptions(
          baseUrl: 'http://192.168.0.128:6001/api/productos',
          queryParameters: {
            'ver': '1.1'
          }
      ));

      FormData data = FormData.fromMap({
        'ProductoDto': {
        'id': product.id,
        'nombre': product.nombre,
        'precio': product.precio,
        'marcaId': product.marcaId,
        'categoriaId': product.categoriaId,
        'codigoBarra': product.codigoBarra,
        'codigoQr': product.codigoQr,
        },
        'ImagenCarga': MultipartFile.fromBytes(
          imageFile.readAsBytesSync(),
          filename: '${product.id}.jpg'
        )
      });

      final response = await dio.put('',
          data: data,
          options: Options(contentType: 'multipart/form-data')
      );
      
    } catch (e) {
      print('Ocurrió un error actualizando producto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;
    final Product? product = ref.watch(productInfoProvider)[widget.productId];
    final categories = ref.watch(categoriesProvider);
    final marcas = ref.watch(marcasProvider);
    String barcodeResult = ref.watch(barcodeProvider);
    String qrCode = ref.watch(qrProvider);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          title: const Text('Detalles'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final photoPath =
                      await CameraGalleryServiceImpl().takePhoto();
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
          title: const Text(
            'Detalles',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
        ),
        body: FadeInLeft(
          child: _ProductDetailsView(
            product: product,
            categories: categories,
            marcas: marcas,
            barcode: barcodeResult,
            qrCode: qrCode,
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.blue.shade50,
          overlayOpacity: 0.8,
          spacing: 15,
          spaceBetweenChildren: 15,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              backgroundColor: Colors.green.shade50,
              child: const Icon(Icons.save),
              label: 'Guardar',
              onTap: () async {
                final String productName = ref.read(productNameProvider);
                final double productPrice = ref.read(productPriceProvider);
                final String? selectedCategory =
                    ref.read(selectedCategoriaProvider);
                final int? selectedIdCategory =
                    ref.read(selectedIdCategoriaProvider);
                final String? selectedMarca = ref.read(selectedMarcaProvider);
                final int? selectedIdMarca = ref.read(selectedIdMarcaProvider);
                final String codigoBarra = ref.read(barcodeProvider);
                final String codigoQr = ref.read(qrProvider);
                final String photoPath = ref.read(productImageProvider);
                final imagenUrl = product.imagenUrl;
                // Guardar la imagen

                Product updatedProduct = Product(
                    product.id,
                    productName,
                    productPrice,
                    selectedIdMarca!,
                    selectedMarca!,
                    selectedIdCategory!,
                    selectedCategory!,
                    codigoBarra,
                    codigoQr,
                    imagenUrl);

                await ref.read(productsProvider.notifier).updateProductByProduct(updatedProduct, photoPath);
                await ref.read(productInfoProvider.notifier).loadProduct(updatedProduct.id.toString());

                ref.read(productImageProvider.notifier).update((state) => '');

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Producto guardado correctamente.')));
              },
            ),
            SpeedDialChild(
                onTap: () async {
                  await ref
                      .read(productsProvider.notifier)
                      .deleteProductById(widget.productId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Producto eliminado correctamente.')),
                  );
                  ref.read(barcodeProvider.notifier).update((state) => '');
                  ref.read(qrProvider.notifier).update((state) => '');
                  context.pop();
                },
                backgroundColor: Colors.red.shade50,
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
  final String barcode;
  final String qrCode;

  const _ProductDetailsView(
      {required this.product,
      required this.categories,
      required this.marcas,
      required this.barcode,
      required this.qrCode});

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends ConsumerState<_ProductDetailsView> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();
  final barcodeController = TextEditingController();
  final qrController = TextEditingController();
  bool _isMounted = true;

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    barcodeController.dispose();
    qrController.dispose();
    _isMounted = false;

    super.dispose();
  }

  Future<void> setProductDetails() async {
    if (_isMounted) {
      return Future.delayed(const Duration(milliseconds: 300), () {
        ref.read(productNameProvider.notifier).state = widget.product.nombre;
        ref.read(productPriceProvider.notifier).state = widget.product.precio;
        ref.read(selectedCategoriaProvider.notifier).state =
            widget.product.categoria;
        ref.read(selectedIdCategoriaProvider.notifier).state =
            widget.product.categoriaId;
        ref.read(selectedMarcaProvider.notifier).state = widget.product.marca;
        ref.read(selectedIdMarcaProvider.notifier).state =
            widget.product.marcaId;
        ref.read(barcodeProvider.notifier).state = widget.product.codigoBarra;
        ref.read(qrProvider.notifier).state = widget.product.codigoQr;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    nombreController.text = widget.product.nombre;
    precioController.text = widget.product.precio.toString();
    qrController.text = widget.product.codigoQr;
    barcodeController.text = widget.product.codigoBarra;

    setProductDetails();

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

    final categories = widget.categories;
    final marcas = widget.marcas;
    final String barcode = widget.barcode;
    final String qrcode = widget.qrCode;
    final String image = ref.watch(productImageProvider);
    late ImageProvider imageProvider;
    
    // Carga de imagen
    if ( image == '' && widget.product.imagenUrl.isEmpty ) {
      imageProvider = const AssetImage('assets/loaders/no_image.png');
    } else if ( image == '' && widget.product.imagenUrl.isNotEmpty ) {
      Uint8List imageBytes = Uint8List.fromList(widget.product.imagenUrl);
      imageProvider = MemoryImage(imageBytes);
    } else {
      imageProvider = FileImage(File(image));
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: const Icon(Icons.propane_tank_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
              ),
              const SizedBox(height: 32),
              MarcasDropdown(
                  marcas: marcas, marcaId: widget.product.marcaId.toString()),
              const SizedBox(height: 32),
              CategoriesDropdown(
                  categories: categories,
                  categoryId: widget.product.categoriaId.toString()),
              const SizedBox(height: 32),
              TextField(
                controller: precioController,
                decoration: InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                keyboardType: const TextInputType.numberWithOptions(),
              ),
              const SizedBox(height: 32),
              QrTextfield(qrController: qrController, qrcode: qrcode),
              const SizedBox(height: 32),
              BarcodeTextfield(
                  barcodeController: barcodeController, barcode: barcode),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

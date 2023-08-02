import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/barcode/barcode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodeTextfield extends ConsumerStatefulWidget {
  final TextEditingController barcodeController;
  final String barcode;

  const BarcodeTextfield({
    super.key,
    required this.barcodeController,
    required this.barcode,
  });

  @override
  _BarcodeTextfieldState createState() => _BarcodeTextfieldState();
}

class _BarcodeTextfieldState extends ConsumerState<BarcodeTextfield> {

  Future<void> resetBarcode() async {
      return Future.delayed(const Duration(milliseconds: 30), () {
        //ref.read(barcodeProvider.notifier).state = '';
      });
  }

  @override
  void initState() {
    super.initState();
    resetBarcode();
  }

  @override
  Widget build(BuildContext context) {

    widget.barcodeController.text = widget.barcode;
  
    return TextField(
      controller: widget.barcodeController,
      enabled: false,
      decoration: InputDecoration(
          labelText: 'Código de barras',
          prefixIcon: const Icon(Icons.barcode_reader),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          )
      ),
    );
    
  }
}

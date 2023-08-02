import 'package:flutter/material.dart';
import 'package:flutter_products_app/presentation/providers/products/products_provider.dart';
import 'package:flutter_products_app/presentation/providers/qr/qr_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QrTextfield extends ConsumerStatefulWidget {
  final TextEditingController qrController;
  final String qrcode;

  const QrTextfield(
      {super.key, required this.qrController, required this.qrcode});

  @override
  _QrTextfieldState createState() => _QrTextfieldState();
}

class _QrTextfieldState extends ConsumerState<QrTextfield> {

  @override
  void initState() {
    super.initState();
    resetQR();
    
  }

  Future<void> resetQR() async {
      return Future.delayed(const Duration(milliseconds: 700), () {
        //ref.read(qrProvider.notifier).state = '';
        //ref.read(productImageProvider.notifier).state = '';
      });
  }

  @override
  Widget build(BuildContext context) {

    widget.qrController.text = widget.qrcode;

    return TextField(
      controller: widget.qrController,
      decoration: InputDecoration(
          labelText: 'Código QR',
          enabled: false,
          prefixIcon: const Icon(Icons.qr_code),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          )
      ),
    );
  }
}

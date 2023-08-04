import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintScreen extends StatefulWidget {
  static const name = "print_screen";

  final List<Map<String, dynamic>> data;

  const PrintScreen(this.data);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";
  final f = NumberFormat("\$###,###.00", "en_US");
  Map<String, dynamic> config = {};
  @override
  bool mounted = true;

  Future<void> _startPrint(BluetoothDevice device) async {

    if (device.address != null) {
      
      await bluetoothPrint.connect(device);

      List<LineText> list = [];

      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Products App",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1
         )
      );

      for (var i = 0; i < widget.data.length; i++) {

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: widget.data[i]['Producto'],
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1)
        );

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: "${f.format(widget.data[i]['Cantidad'])} x ${widget.data[i]['Precio']}",
            align: LineText.ALIGN_LEFT,
            linefeed: 1)
        );

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: f.format(widget.data[i]['Cantidad'] * widget.data[i]['Precio']).toString(),
            align: LineText.ALIGN_RIGHT,
            linefeed: 1)
        );
      }

      // Añadir espacios en blanco al final del ticket
      for (var i = 0; i < 2; i++){
         list.add(
            LineText(
              type: LineText.TYPE_TEXT,
              content: "",
              weight: 2,
              width: 2,
              height: 2,
              align: LineText.ALIGN_CENTER,
              linefeed: 1
            )
          );
      }


      await Future.delayed(const Duration(seconds: 2));
      await bluetoothPrint.printReceipt(config, list);
      await bluetoothPrint.disconnect();
    }
  }

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    mounted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  Future<void> initPrinter() async {

    bluetoothPrint.startScan(timeout: const Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty) {
        if(!mounted) return;
        setState(() {
          _devicesMsg = "No devices";
        });
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
  
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Selecciona una printer'),
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
        ),
        body: _devices.isEmpty
            ? Center(
                child: Text(_devicesMsg),
              )
            : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(_devices[index].name ?? 'No name'),
                    subtitle: Text(_devices[index].address ?? 'No Address'),
                    onTap: () {
                      _startPrint(_devices[index]);
                    },
                  );
                },
              ));
  }
}

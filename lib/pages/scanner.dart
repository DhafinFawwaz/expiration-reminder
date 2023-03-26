import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import '../backend/reminder_helper.dart';
import '../backend/sql_helper.dart';
import '../model/reminder_model.dart';
import '../pages/manual.dart';
import '../util/global_theme.dart';
import '../widget/back_widget.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.refreshPages});
  final Function refreshPages;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isScanning = false;
  Color scanBorderColor = Colors.red;

  Future<void> addReminder(Reminder reminder) async {
    await SQLHelper.createReminder(reminder);
    widget.refreshPages();
  }
  
  bool isCodeValid(String scannedCode){
    // Sari Roti;Bread;2023-03-20
    RegExp exp = RegExp(r'.+?(?=;);.+?(?=;);\d\d\d\d-(0|1)\d-(0|1|2|3)\d');
    return exp.hasMatch(scannedCode);
  }
  void onScanned(String scannedCode)
  {
    if(!isCodeValid(scannedCode) && !isScanning){
      setState(() {
        result = null;
      });
      return;
    }

    // Below gets called if the code is valid
    setState(() {
      scanBorderColor = Colors.green;
      isScanning = true;
    });
    final List<String> splited = scannedCode.split(";");
    String productName = splited[0];
    String productGeneralName = splited[1];
    DateTime expirationDate = DateTime.parse(splited[2]);
    Reminder reminder = Reminder(
      id: 0,
      productName: productName,
      expirationDate: expirationDate,
      notificationTime: DateTime.now(),
      description: ""
    );
    addReminder(reminder);

    final snackBar = SnackBar(
      content: Text('Added ${productName}'),
      action: SnackBarAction(
        textColor: GlobalTheme.slate50,
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    delayCamera();
  }
  void delayCamera() async {
    await Future.delayed(const Duration(seconds: 3), (){
      setState(() {
        scanBorderColor = Colors.red;
        isScanning = false;
        result = null;
      });
    });
  }

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  flex: 4, 
                  child: _buildQrView(context)
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: <Widget>[
              
                        const SizedBox(height: 10),
          
                        const Text(
                          'Scan an Expiration QR code',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      
                        const SizedBox(height: 10),
          
                        const Text(
                            'or',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
          
                        const SizedBox(height: 10),
          
          
                        FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => ManualPage(refreshPages: widget.refreshPages,),
                              ),
                            );
                          }, 
                          label: const Text(
                            "Add Manually",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          elevation: 0,
                          highlightElevation: 0,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 15.0,
              left: 15.0, // or whatever
              child: FloatingBackButton(Colors.white),
            ),
        ]
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: scanBorderColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        if(result != null){
          if(result!.code != null){
            onScanned(result!.code!);
          }
        }

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


}
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String message = "Start Scanning";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$message"),
            RaisedButton(
              onPressed: () async {
                message = await QRCodeReader().scan();
                setState(() {});
              },
              child: Text("Scan"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String message = "Start Scanning ;)";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$message"),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            RaisedButton(
              highlightColor: Colors.green,
              highlightElevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                child: Text(
                  "Scan Now",
                  textScaleFactor: 1.4,
                  style: TextStyle(),
                ),
              ),
              onPressed: () async {
                message = await QRCodeReader().scan() ?? "Start Scanning ;)";
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

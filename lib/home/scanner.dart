import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class ScannerPage extends StatefulWidget {
  final bool isCheckingFood;
  ScannerPage({@required this.isCheckingFood});
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String message = "Start Scanning ;)";
  String commodity;
  DocumentSnapshot snapshot;
  bool scanned = true;
  bool exists = true;
  bool isUndoable = false;
  String id;

  @override
  Widget build(BuildContext context) {
    commodity = widget.isCheckingFood ? "food" : "schwags";

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scanner (${commodity.toUpperCase()})"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$message",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                    scanned = true;
                    exists = true;
                    setState(() {
                      message = "Start Scanning ;)";
                    });

                    message = await QRCodeReader().scan();
                    scanned = message == null ? false : true;
                    id = message;

                    //do stuff only if something is scanned
                    //else just show welcome string
                    if (scanned) {
                      snapshot = await Firestore.instance
                          .collection("attendees")
                          .document("data")
                          .get();
                      exists =
                          snapshot.data["data"][message] == null ? false : true;

                      //check if data exists or not on firebase
                      //proceed towards further checks onyly if
                      //id exists on firebase
                      if (exists) {
                        //check if schwags have already been collected
                        //when data is NOT been NULL
                        if (snapshot.data["data"][message][commodity] == true) {
                          message =
                              "ID $id \n\n${commodity.toUpperCase()} ALREADY COLLECTED!!";
                          isUndoable = false;
                        }
                        //if schwags have not been collected, only then
                        //set the schwags to TRUE
                        else {
                          await Firestore.instance
                              .collection("attendees")
                              .document("data")
                              .updateData({
                            "data.$message.$commodity": true,
                          }).then((onValue) {
                            print("Data has been set");
                            message = "ID $id \n\nMarked as Collected";
                            isUndoable = true;
                          });
                        }
                      } else {
                        message = "Scanned $id\n\nNO DATA FOUND";
                        isUndoable = false;
                      }
                    } else {
                      message = "Start Scanning ;)";
                      isUndoable = false;
                    }

                    setState(() {});
                  },
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
                      "Undo",
                      textScaleFactor: 1.4,
                      style: TextStyle(),
                    ),
                  ),
                  //if the operation is undoable, then make
                  //the undo button disabled
                  onPressed: isUndoable
                      ? () async {
                          snapshot = await Firestore.instance
                              .collection("attendees")
                              .document("data")
                              .get();
                          if (scanned == true &&
                              exists == true &&
                              snapshot.data["data"][id][commodity] == true) {
                            await Firestore.instance
                                .collection("attendees")
                                .document("data")
                                .updateData({
                              "data.$id.$commodity": false,
                            }).then((onValue) {
                              print("Data has been unset");
                              message = "ID $id \nMarked as NOT Collected";
                              isUndoable = false;
                            });
                          } else {
                            print("Nothing to UNDO");
                            message = "Nothing to Undo";
                            isUndoable = false;
                          }
                          setState(() {});
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

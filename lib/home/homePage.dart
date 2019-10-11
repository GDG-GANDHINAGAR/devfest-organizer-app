import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizers_app/speakers/speaker_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage({@required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id;
  Future _scanqr() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() {
        id = result;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          id = "camera permission denied";
        });
      } else {
        setState(() {
          id = "an error occured $e";
        });
      }
    } on FormatException {
      setState(() {
        id = " back button pressed";
      });
    } catch (e) {
      setState(() {
        id = "an error occured $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("homepage")
          .document("dummy_data")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error Occured: ${snapshot.error}"),
            );
          }
          // print(snapshot.data["meta"]["feedback_active"]);
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Speakers"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SpeakerPage();
                          },
                        ),
                      );
                    },
                  ),
                  // true // add condition here
                  snapshot.data["meta"]["feedback_active"] ?? false
                      ? RaisedButton(
                          child: Text("Disable Feedback"),
                          onPressed: () {
                            return showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      "This will make the Feedback button on the Android app get replaced with an Show ID button.\nIt is advised to use it before the fest begins."),
                                  title: Text("Disable Feedback"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Turn Off"),
                                      onPressed: () async {
                                        await Firestore.instance
                                            .collection("homepage")
                                            .document("dummy_data")
                                            .updateData({
                                          "meta.feedback_active": false,
                                        }).then((onValue) {
                                          print("Feedback turned off");
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      : RaisedButton(
                          child: Text("Enable Feedback"),
                          onPressed: () {
                            return showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      "This will make the Show ID button on the Android app get replaced with a feedback form.\nIt is adviced to use it only at the end of the fest."),
                                  title: Text("Enable Feedback"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Turn On"),
                                      onPressed: () async {
                                        await Firestore.instance
                                            .collection("homepage")
                                            .document("dummy_data")
                                            .updateData({
                                          "meta.feedback_active": true,
                                        }).then((onValue) {
                                          print("Feedback turned on");
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                  new FloatingActionButton.extended(
                    icon: Icon(Icons.camera),
                    label: Text("Scan me"),
                    onPressed: _scanqr,
                    tooltip: "scan code",
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

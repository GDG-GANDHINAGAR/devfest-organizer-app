import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizers_app/home/scanner.dart';
import 'package:organizers_app/speakers/speaker_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage({@required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: ListTile(
                        // trailing: Icon(Icons.edit),
                        leading: Icon(Icons.person),
                        title: Text("Edit Speaker Details"),
                        subtitle:
                            Text("Edit Speaker visibility and talk timings"),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return SpeakerPage();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // true // add condition here
                  snapshot.data["meta"]["feedback_active"] ?? false
                      ? Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.feedback),
                              title: Text("Disable Feedback"),
                              subtitle: Text(
                                  "Toggle Feedback form visibility in app"),
                              isThreeLine: true,
                              onTap: () {
                                return showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "The feedback button would disappear from the home screen and users would not be able to access the feedback form"),
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
                            ),
                          ),
                        )
                      // RaisedButton(
                      //     child: Text("Disable Feedback"),
                      //     onPressed: () {
                      //       return showDialog(
                      //         barrierDismissible: true,
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             content: const Text(
                      //                 "This will make the Feedback button on the Android app get replaced with an Show ID button.\nIt is advised to use it before the fest begins."),
                      //             title: Text("Disable Feedback"),
                      //             actions: <Widget>[
                      //               FlatButton(
                      //                 child: Text("Turn Off"),
                      //                 onPressed: () async {
                      //                   await Firestore.instance
                      //                       .collection("homepage")
                      //                       .document("dummy_data")
                      //                       .updateData({
                      //                     "meta.feedback_active": false,
                      //                   }).then((onValue) {
                      //                     print("Feedback turned off");
                      //                     Navigator.of(context).pop();
                      //                   });
                      //                 },
                      //               ),
                      //               FlatButton(
                      //                 child: Text("Cancel"),
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );
                      //     },
                      //   )
                      : Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.feedback),
                              title: Text("Enable Feedback"),
                              subtitle: Text(
                                  "Toggle Feedback form visibility in app"),
                              isThreeLine: true,
                              onTap: () {
                                return showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "A new button would appear on the home screen enabling the users to provide their feedback adter the fest."),
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
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("QR Code Scanner"),
                        subtitle: Text("Scan QR codes and verify tickets"),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ScannerPage();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // : RaisedButton(
                  //     child: Text("Enable Feedback"),
                  //     onPressed: () {
                  //       return showDialog(
                  //         barrierDismissible: true,
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //             content: const Text(
                  //                 "This will make the Show ID button on the Android app get replaced with a feedback form.\nIt is adviced to use it only at the end of the fest."),
                  //             title: Text("Enable Feedback"),
                  //             actions: <Widget>[
                  //               FlatButton(
                  //                 child: Text("Turn On"),
                  //                 onPressed: () async {
                  //                   await Firestore.instance
                  //                       .collection("homepage")
                  //                       .document("dummy_data")
                  //                       .updateData({
                  //                     "meta.feedback_active": true,
                  //                   }).then((onValue) {
                  //                     print("Feedback turned on");
                  //                     Navigator.of(context).pop();
                  //                   });
                  //                 },
                  //               ),
                  //               FlatButton(
                  //                 child: Text("Cancel"),
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 },
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //       );
                  //     },
                  //   ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

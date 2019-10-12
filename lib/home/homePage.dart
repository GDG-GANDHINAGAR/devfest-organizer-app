import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizers_app/home/scanner.dart';
import 'package:organizers_app/speakers/speaker_page.dart';

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
          return SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: ListTile(
                          // trailing: Icon(Icons.edit),
                          leading: Icon(
                            Icons.person,
                            size: 40,
                          ),
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
                                leading: Icon(
                                  Icons.feedback,
                                  size: 40,
                                ),
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
                        : Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.feedback,
                                  size: 40,
                                ),
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
                          leading: Icon(
                            Icons.camera_alt,
                            size: 40,
                          ),
                          title: Text("QR Code Scanner (Schwags)"),
                          subtitle: Text(
                              "Scan QR codes to verify if attendees have collected schwags"),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ScannerPage(
                                    isCheckingFood: false,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.camera_alt,
                            size: 40,
                          ),
                          title: Text("QR Code Scanner (Food)"),
                          subtitle: Text(
                              "Scan QR codes to verify if attendees have taken food"),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ScannerPage(
                                    isCheckingFood: true,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

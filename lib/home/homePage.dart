import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          .collection("speakers")
          .document("dummy_data")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
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
                  true// add condition here
                      ? RaisedButton(
                          child: Text("Enable Feedback"),
                          onPressed: () {
                            return showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      "This will make the Show ID button on the Android app get replaced with a feedback form.\nUse it only at the end of the fest"),
                                  title: Text("Enable Feedback"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Turn On"),
                                      onPressed: () {
                                        //do operation
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
                          child: Text("Disable Feedback"),
                          onPressed: () {
                            return showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                      "This will make the Feedback button on the Android app get replaced with an Show ID button.\nUse it at the beginning and during the fest."),
                                  title: Text("Disable Feedback"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Turn Off"),
                                      onPressed: () {
                                        //do operation
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
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

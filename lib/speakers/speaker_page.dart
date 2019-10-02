import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizers_app/models/speakers.dart';

class SpeakerPage extends StatelessWidget {
  static const String routeName = "/speakers";
  static List<Speaker> speakerList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speakers Settings"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection("speakers")
            .document("dummy_data")
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              print("Encountered error: ${snapshot.error}");
              return CircularProgressIndicator();
            } else {
              speakerList = List<Speaker>();

              for (int i = 0; i < snapshot.data.data["data"].length; i++) {
                speakerList.add(Speaker.fromJson(
                    Map<String, dynamic>.from(snapshot.data.data["data"][i])));
              }
              if (speakerList.length < 1) {
                return Center(
                  child: Text("Coming soon"),
                );
              }
              return ListView.builder(
                itemCount: speakerList.length,
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  return Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints.expand(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(speakerList[i].speakerImage),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      speakerList[i].speakerName,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 5,
                                      color: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length)],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  speakerList[i].speakerSession,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Visibility "),
                                    Switch(
                                        value: speakerList[i].isShown ?? false,
                                        onChanged: (value) {
                                          return isShownConfirmation(
                                            context: context,
                                            i: i,
                                            snapshot: snapshot,
                                            turnOn: value,
                                          );
                                        }),
                                    SizedBox(width: 5),
                                    Icon(speakerList[i].isShown
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Featured"),
                                    Switch(
                                      value: speakerList[i].isFeatured ?? false,
                                      onChanged: (value) {
                                        return isFeaturedConfirmation(
                                          context: context,
                                          i: i,
                                          snapshot: snapshot,
                                          turnOn: value,
                                        );
                                      },
                                    ),
                                    SizedBox(width: 5),
                                    Icon(speakerList[i].isFeatured
                                        ? Icons.star
                                        : Icons.star_border),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<Widget> isShownConfirmation({
    @required BuildContext context,
    @required int i,
    @required AsyncSnapshot<DocumentSnapshot> snapshot,
    @required bool turnOn,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          //control content according to boolean value
          content: turnOn
              ? Text(
                  "Speaker ${speakerList[i].speakerName} and it's details would be visible on the website and app.\nAre you sure you wish to do this?")
              : Text(
                  "Speaker ${speakerList[i].speakerName} and it's details would be hiden from the website and app.\nAre you sure you wish to do this?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              // this is where the actual magic✨(overwriting) happens
              onPressed: () async {
                //if turnOn is true, we need to turn the isShown on
                speakerList[i].isShown = turnOn ? true : false;
                List<dynamic> temp = List<dynamic>();
                for (int i = 0; i < snapshot.data.data["data"].length; i++) {
                  temp.add(speakerList[i].toJson());
                }
                await Firestore.instance
                    .collection("speakers")
                    .document("dummy_data")
                    .updateData(
                  {
                    "data": temp,
                  },
                ).then((onValue) {
                  turnOn
                      ? print("Showing speaker ${speakerList[i].speakerName}")
                      : print("Hiding speaker ${speakerList[i].speakerName} ");

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
  }

  Future<Widget> isFeaturedConfirmation({
    @required BuildContext context,
    @required int i,
    @required AsyncSnapshot<DocumentSnapshot> snapshot,
    @required bool turnOn,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          //control content according to boolean value
          content: turnOn
              ? Text(
                  "Speaker ${speakerList[i].speakerName} would be featured on the website.\nAre you sure you wish to do this?")
              : Text(
                  "Speaker ${speakerList[i].speakerName} would be not featured on the website.\nAre you sure you wish to do this?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              // this is where the actual magic✨(overwriting) happens
              onPressed: () async {
                //if turnOn is true, we need to turn the isShown on
                speakerList[i].isFeatured = turnOn ? true : false;
                List<dynamic> temp = List<dynamic>();
                for (int i = 0; i < snapshot.data.data["data"].length; i++) {
                  temp.add(speakerList[i].toJson());
                }
                await Firestore.instance
                    .collection("speakers")
                    .document("dummy_data")
                    .updateData(
                  {
                    "data": temp,
                  },
                ).then((onValue) {
                  turnOn
                      ? print("Featuring speaker ${speakerList[i].speakerName}")
                      : print(
                          "NOT Featuring speaker ${speakerList[i].speakerName} ");

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
  }

  // Future<Widget> isShownConfirmationOff(
  //     {@required context, @required i, @required snapshot}) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Are you sure?"),
  //         content: Text(
  //             "Speaker ${speakerList[i].speakerName} and it's details would be hiden from the website and app.\nAre you sure you wish to do this?"),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("Yes"),
  //             onPressed: () async {
  //               speakerList[i].isShown = false;
  //               List<dynamic> temp = List<dynamic>();
  //               for (int i = 0; i < snapshot.data.data["data"].length; i++) {
  //                 temp.add(speakerList[i].toJson());
  //               }
  //               await Firestore.instance
  //                   .collection("speakers")
  //                   .document("dummy_data")
  //                   .updateData(
  //                 {
  //                   "data": temp,
  //                 },
  //               ).then((onValue) {
  //                 Navigator.of(context).pop();
  //               });
  //             },
  //           ),
  //           FlatButton(
  //             child: Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizers_app/models/speakers.dart';

class SpeakerPage extends StatelessWidget {
  static List<Speaker> speakerList;

  final TextEditingController totalTimeController = TextEditingController();

  final TextEditingController startTimeController = TextEditingController();

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

              speakerList.sort((a, b) {
                return a.speakerId.compareTo(b.speakerId);
              });

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
                              backgroundImage: CachedNetworkImageProvider(
                                speakerList[i].speakerImage,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("Visibility "),
                                        Switch(
                                            value: speakerList[i].isVisible ??
                                                false,
                                            onChanged: (value) {
                                              return isVisibleConfirmation(
                                                context: context,
                                                i: i,
                                                snapshot: snapshot,
                                                turnOn: value,
                                              );
                                            }),
                                        SizedBox(width: 5),
                                        Icon(
                                          speakerList[i].isVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      child: Text(
                                          "${speakerList[i].startTime == "" ? "Start" : speakerList[i].startTime}"),
                                      onTap: () {
                                        return startTimeConfirmation(
                                          context: context,
                                          i: i,
                                          snapshot: snapshot,
                                        );
                                      },
                                    ),
                                    SizedBox(width: 3),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("Featured"),
                                        Switch(
                                          value: speakerList[i].isFeatured ??
                                              false,
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
                                        Icon(
                                          speakerList[i].isFeatured
                                              ? Icons.star
                                              : Icons.star_border,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      child: Text(
                                          "${speakerList[i].totalTime == "" ? "Total" : speakerList[i].totalTime}"),
                                      onTap: () {
                                        return totalTimeConfirmation(
                                          context: context,
                                          i: i,
                                          snapshot: snapshot,
                                        );
                                      },
                                    ),
                                    SizedBox(width: 3),
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

  Future<Widget> isVisibleConfirmation({
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
                //if turnOn is true, we need to turn the isVisible on
                speakerList[i].isVisible = turnOn ? true : false;
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
                //if turnOn is true, we need to turn the isVisible on
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

  Future<Widget> totalTimeConfirmation({
    @required BuildContext context,
    @required int i,
    @required AsyncSnapshot<DocumentSnapshot> snapshot,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update total time"),
          content: TextFormField(
            controller: totalTimeController,
            decoration: InputDecoration(
              hintText: "Total Time (eg. 30 Mins)",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Save"),
              onPressed: () async {
                speakerList[i].totalTime = totalTimeController.text;
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
                  print(
                      "Updated Total time ${speakerList[i].totalTime} for ${speakerList[i].speakerName}");
                  totalTimeController.clear();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<Widget> startTimeConfirmation({
    @required BuildContext context,
    @required int i,
    @required AsyncSnapshot<DocumentSnapshot> snapshot,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update start time"),
          content: TextFormField(
            controller: startTimeController,
            decoration: InputDecoration(
              hintText: "Start Time (eg. 9:00 AM)",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Save"),
              onPressed: () async {
                speakerList[i].startTime = startTimeController.text;
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
                  print(
                      "Updated Start time ${speakerList[i].startTime} for ${speakerList[i].speakerName}");
                  startTimeController.clear();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

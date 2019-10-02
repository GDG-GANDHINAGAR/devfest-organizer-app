import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizers_app/models/speakers.dart';

class SpeakerPage extends StatelessWidget {
  static const String routeName = "/speakers";
  static List<Speaker> speakerList;

  // Widget socialActions(context, Speaker speaker) => FittedBox(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(
  //               FontAwesomeIcons.facebookF,
  //               size: 15,
  //             ),
  //             onPressed: () {
  //               launch(speaker.fbUrl);
  //             },
  //           ),
  //           IconButton(
  //             icon: Icon(
  //               FontAwesomeIcons.twitter,
  //               size: 15,
  //             ),
  //             onPressed: () {
  //               launch(speaker.twitterUrl);
  //             },
  //           ),
  //           IconButton(
  //             icon: Icon(
  //               FontAwesomeIcons.linkedinIn,
  //               size: 15,
  //             ),
  //             onPressed: () {
  //               launch(speaker.linkedinUrl);
  //             },
  //           ),
  //           IconButton(
  //             icon: Icon(
  //               FontAwesomeIcons.github,
  //               size: 15,
  //             ),
  //             onPressed: () {
  //               launch(speaker.githubUrl);
  //             },
  //           ),
  //         ],
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speakers"),
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
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  speakerList[i].speakerDesc,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  speakerList[i].speakerSession,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                CheckboxListTile(
                                  value: speakerList[i].isShown ?? false,
                                  title: Text("Is Visible"),
                                  onChanged: (value) {
                                    if (value == true) {
                                      //show confirmation dialog for changing values
                                      return showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Are you sure?"),
                                            content: Text(
                                                "Speaker ${speakerList[i].speakerName} and it's details would be visible on the website and app.\nAre you sure you wish to do this?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("Yes"),
                                                //this is where the actual magic✨(overwriting) happens
                                                onPressed: () async {
                                                  speakerList[i].isShown = true;
                                                  List<dynamic> temp =
                                                      List<dynamic>();
                                                  for (int i = 0;
                                                      i <
                                                          snapshot
                                                              .data
                                                              .data["data"]
                                                              .length;
                                                      i++) {
                                                    temp.add(speakerList[i]
                                                        .toJson());
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
                                                        "Showing speaker ${speakerList[i].speakerName}");
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
                                      // speakerList[i].isShown = true;
                                      // List<dynamic> temp = List<dynamic>();
                                      // for (int i = 0;
                                      //     i < snapshot.data.data["data"].length;
                                      //     i++) {
                                      //   temp.add(speakerList[i].toJson());
                                      // }
                                      // await Firestore.instance
                                      //     .collection("speakers")
                                      //     .document("dummy_data")
                                      //     .updateData(
                                      //   {
                                      //     "data": temp,
                                      //   },
                                      // ).then((onValue) {
                                      //   print("Entered values on Firestore");
                                      // });
                                    } else {
                                      //show confirmation dialog for changing values
                                      return showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Are you sure?"),
                                            content: Text(
                                                "Speaker ${speakerList[i].speakerName} and it's details would be hiden from the website and app.\nAre you sure you wish to do this?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  speakerList[i].isShown =
                                                      false;
                                                  List<dynamic> temp =
                                                      List<dynamic>();
                                                  for (int i = 0;
                                                      i <
                                                          snapshot
                                                              .data
                                                              .data["data"]
                                                              .length;
                                                      i++) {
                                                    temp.add(speakerList[i]
                                                        .toJson());
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
                                                        "Hiding speaker ${speakerList[i].speakerName} ");
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
                                  },
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
}

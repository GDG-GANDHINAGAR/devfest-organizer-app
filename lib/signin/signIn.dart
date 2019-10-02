import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizers_app/home/homePage.dart';

class SignIn extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DevFestGnr 2k19"),
      ),
      body: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return HomePage(user: snapshot.data);
            }
            return Container(
              child: Center(
                child: RaisedButton(
                  child: Text("Sign In"),
                  onPressed: () async {
                    FirebaseUser user = await _handleGoogleSignIn();
                    // setBasicData(user);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    return user;
  }

  // void setBasicData(FirebaseUser user) async {
  //   await Firestore.instance.collection('users').document(user.email).setData(
  //     {
  //       "display_name": user.displayName,
  //       "email": user.email,
  //       "uid": user.uid,
  //       "photo_url": user.photoUrl,
  //     },
  //   );
  // }
}

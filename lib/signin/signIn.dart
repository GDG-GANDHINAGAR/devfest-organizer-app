import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizers_app/home/homePage.dart';
import 'package:organizers_app/home/scanner.dart';

class SignIn extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DevFest Dashboard"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ScannerPage();
              },
            ),
          );
        },
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
                    print(user);
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
}

import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/screens/main-pages/MainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign-in/SignIn2.dart';

class Initial extends StatefulWidget {
  static const routeName = '/initial';
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  bool dataLoaded = false;
  FirebaseProvider firebaseProvider;

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      dataLoaded = true;
      firebaseProvider = Provider.of<FirebaseProvider>(context);
    }
    super.didChangeDependencies();
  }

  Future<void> validateSession(BuildContext context) async {
    try {
      await firebaseProvider.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      // await auth.signOut();
      if (auth.currentUser != null) {
        firebaseProvider.user.uid = auth.currentUser.uid;
        DocumentSnapshot doc =
            await db.collection("users").doc(auth.currentUser.uid).get();
        if (doc.exists) {
          firebaseProvider.listenGeneralInfo();
          firebaseProvider.user.data = doc.data()["profile_info"];
          firebaseProvider.user.data["registerDate"] =
              doc.data()["register_date"];
          firebaseProvider.user.type = doc.data()["user_type"];
          Navigator.of(context).pushReplacementNamed(MainPage.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(SignIn2.routeName);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(SignIn2.routeName);
      }
    } catch (e) {
      print('ERROR validateSession: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      validateSession(context);
    });

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    ));
  }
}

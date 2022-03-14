import 'dart:async';

import 'package:AltoProfe/models/AppUser.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/screens/sign-in/Register.dart';
// import 'package:AltoProfe/screens/sign-in/SignIn.dart';
import 'package:AltoProfe/screens/sign-in/SignIn2.dart';
import 'package:AltoProfe/screens/main-pages/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class FirebaseProvider extends ChangeNotifier {
  FirebaseFirestore db;
  FirebaseAuth auth;
  List<Map<String, dynamic>> topics = [];
  bool codeSent = false;
  String verificationID = "";
  StreamSubscription<QuerySnapshot> studentSnapshot;
  StreamSubscription<QuerySnapshot> tutorSnapshot;
  List<Map<String, dynamic>> userTutorships = [];
  List<Map<String, dynamic>> historicalUserTutorships = [];
  List<Map<String, dynamic>> historicalTutorTutorships = [];
  List<Map<String, dynamic>> availableTutorships = [];
  List<Map<String, dynamic>> filteravailableTutorships = [];

  List<Map<String, dynamic>> activeTutorTutorships = [];

  AppUser user = new AppUser();

  // General info
  StreamSubscription generalInfoSubscription;
  int maxHours;

  // Initialize firebase
  initializeApp() async {
    await Firebase.initializeApp();
    auth = FirebaseAuth.instance;
    db = FirebaseFirestore.instance;
  }

  Future<void> getTopics() async {
    try {
      topics.clear();
      QuerySnapshot querySnapshot = await db.collection("topics").get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> topicData = doc.data();
        topicData["uid"] = doc.id;
        topics.add(topicData);
        if (user.data["selected_topics"] != null) {
          int index = user.data["selected_topics"].indexOf(doc.id);
          if (index != -1) {
            topicData["selected"] = true;
          } else {
            topicData["selected"] = false;
          }
        } else {
          topicData["selected"] = false;
        }
      });
    } catch (e) {
      print("ERROR getGeneralInfo: $e");
    }
  }

  Future<bool> createTutorship(Map<String, dynamic> tutorshipData) async {
    try {
      await db.collection("tutorships").doc().set(tutorshipData);
      return true;
    } catch (e) {
      print("ERROR createTutorship: $e");
      return false;
    }
  }

  Future<void> getUserTutorships() async {
    try {
      studentSnapshot = db
          .collection("tutorships")
          .where("student.uid", isEqualTo: user.uid)
          .snapshots()
          .listen((snapshot) {
        userTutorships.clear();
        historicalUserTutorships.clear();
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> tutorshipData = doc.data();
          tutorshipData["uid"] = doc.id;
          if (tutorshipData["status"] > 3) {
            historicalUserTutorships.add(tutorshipData);
          } else {
            userTutorships.add(tutorshipData);
          }
        });
        notifyListeners();
      });
    } catch (e) {
      print("ERROR getUserTutorships: $e");
      return null;
    }
  }

  Future<void> getAvailableTutorships() async {
    try {
      // List<Map<String, dynamic>> userTutorships = [];
      tutorSnapshot =
          db.collection("tutorships").snapshots().listen((snapshot) {
        availableTutorships.clear();
        activeTutorTutorships.clear();
        filteravailableTutorships.clear();
        historicalTutorTutorships.clear();
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> tutorshipData = doc.data();
          tutorshipData["uid"] = doc.id;
          if (user.uid != tutorshipData["student"]["uid"]) {
            if (tutorshipData["status"] == 1) {
              availableTutorships.add(tutorshipData);
              int index = user.data["selected_topics"]
                  .indexOf(tutorshipData["topic"]["uid"]);
              if (index != -1) {
                filteravailableTutorships.add(tutorshipData);
              }
            } else if (tutorshipData["tutor"] != null &&
                tutorshipData["tutor"]["uid"] == user.uid) {
              if (tutorshipData["status"] < 4) {
                activeTutorTutorships.add(tutorshipData);
              } else {
                historicalTutorTutorships.add(tutorshipData);
              }
            }
          }
        });
        notifyListeners();
      });
    } catch (e) {
      print("ERROR getAvailableTutorships: $e");
      return null;
    }
  }

  Future<void> cancelTutorship(String uid) async {
    try {
      await db.collection("tutorships").doc(uid).update({"status": 9});
    } catch (e) {
      print("ERROR cancelTutorship: $e");
    }
  }

  Future<void> registerUser(
      BuildContext context, Map<String, dynamic> userData) async {
    try {
      MethodsProvider().showLoadingDialog(context);
      // Register
      await db.collection('users').doc(user.uid).set(userData).then((v) async {
        user.data = userData["profile_info"];
        user.data["registerDate"] = userData["register_date"];
        user.type = userData["user_type"];
        Navigator.of(context).pushReplacementNamed(MainPage.routeName);
      });
    } catch (e) {
      print("ERROR emailSignIn: $e");
      MethodsProvider().hideLoadingDialog(context);
    }
  }

  // Future<bool> sendEmailToRecover(String email) async {
  //   try {
  //     await auth.sendPasswordResetEmail(email: email);
  //     return true;
  //   } catch (e) {
  //     print("ERROR sendEmailToRecover: $e");
  //     return false;
  //   }
  // }

  Future<void> updateTutorshipStatus(String uid, int status,
      {int sugestedPrice}) async {
    try {
      if (status == 1) {
        await db.collection("tutorships").doc(uid).update({
          "status": 1,
          "tutor": null,
        });
      } else if (status == 2) {
        if (sugestedPrice != null) {
          await db.collection("tutorships").doc(uid).update({
            "status": 2,
            "sugested_price": sugestedPrice,
            "tutor": {
              "uid": user.uid,
              "name": user.data["name"],
              "photo_url": user.data["photo_url"],
              "institution": user.data["institution"]
            }
          });
        } else {
          await db.collection("tutorships").doc(uid).update({
            "status": 2,
            "tutor": {
              "uid": user.uid,
              "name": user.data["name"],
              "photo_url": user.data["photo_url"],
              "institution": user.data["institution"]
            }
          });
        }
      } else if (status == 3) {
        await db.collection("tutorships").doc(uid).update({"status": 3});
      } else if (status == 4) {
        await db.collection("tutorships").doc(uid).update({"status": 4});
      }
    } catch (e) {
      print("ERROR updateTutorshipStatus: $e");
    }
  }

  Future<void> updateServiceStatus(bool newStatus, bool student) async {
    try {
      if (student) {
        user.type["student"] = newStatus;
      } else {
        user.type["tutor"] = newStatus;
      }
      await db
          .collection("users")
          .doc(user.uid)
          .update({"user_type": user.type});
      notifyListeners();
    } catch (e) {
      print("ERROR updateServiceStatus: $e");
    }
  }

  Future<void> validatePhone(BuildContext context, String phoneNumber) async {
    try {
      MethodsProvider().showLoadingDialog(context);
      await auth.verifyPhoneNumber(
          phoneNumber: "+57" + phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneCredetials) async {
            // try {
            //   await auth.signInWithCredential(phoneCredetials).then((result) {
            //     Navigator.pushNamed(context, Register.routeName);
            //   });
            // } catch (e) {
            //   print("ERROR in authCredentiasl: $e");
            // }
          },
          verificationFailed: (FirebaseAuthException exception) {
            print(exception.message);
            MethodsProvider().showFushBar(context,
                title: "Espera", message: "ERROR", icon: Icons.error);
            // codeSent = false;
            notifyListeners();
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            print("CODE SENT: " + verificationId);
            verificationID = verificationId;
            codeSent = true;
            notifyListeners();
            MethodsProvider().hideLoadingDialog(context);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // verificationId = verificationId;
            print(verificationID);
            print("Time out");
            codeSent = false;
            notifyListeners();
          });
    } catch (e) {
      print("ERROR validatePhone: $e");
      codeSent = false;
      notifyListeners();
    }
  }

  updateFilterAvailableTutorships() {
    try {
      filteravailableTutorships.clear();
      availableTutorships.forEach((tutorship) {
        int index =
            user.data["selected_topics"].indexOf(tutorship["topic"]["uid"]);
        if (index != -1) {
          filteravailableTutorships.add(tutorship);
        }
      });
      notifyListeners();
    } catch (e) {
      print("ERROR updateFilterAvailableTutorships: $e");
    }
  }

  showSelectTopicsModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        builder: (
          BuildContext contex,
        ) {
          double screenWidth = MediaQuery.of(context).size.width;
          double absoluteHeght = MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setter) {
              return Container(
                height: absoluteHeght * 0.8,
                child: Column(
                  children: [
                    Container(
                        width: screenWidth,
                        height: absoluteHeght * 0.08,
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(color: Colors.orangeAccent),
                        // padding: EdgeInsets.only(top: absoluteHeght * 0.02),
                        child: Text(
                          "Selecciona los temas para dictar tutorías",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.04),
                        )),
                    Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                        ),
                        child: Divider(
                          color: Colors.black,
                        )),
                    Container(
                      height: absoluteHeght * 0.7,
                      child: ListView.builder(
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              updateSelectedTopics(index);
                              setter(() {
                                topics[index]["selected"] =
                                    !topics[index]["selected"];
                              });
                              updateFilterAvailableTutorships();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06,
                                  vertical: absoluteHeght * 0.01),
                              decoration: BoxDecoration(
                                  color: (topics[index]["selected"])
                                      ? Colors.orangeAccent
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300], blurRadius: 5)
                                  ]),
                              child: Row(
                                children: [
                                  Lottie.network(topics[index]["animation"],
                                      width: screenWidth * 0.2,
                                      height: absoluteHeght * 0.08),
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        topics[index]["name"],
                                        style: TextStyle(
                                            color: (topics[index]["selected"])
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> phoneSignIn(BuildContext context, String smsCode) async {
    try {
      MethodsProvider().showLoadingDialog(context);
      AuthCredential credentials = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: smsCode);
      await auth.signInWithCredential(credentials).then((result) async {
        DocumentSnapshot doc =
            await db.collection("users").doc(result.user.uid).get();
        user.uid = result.user.uid;
        if (doc.exists) {
          user.data = doc.data()["profile_info"];
          user.type = doc.data()["user_type"];

          Navigator.pushReplacementNamed(context, MainPage.routeName);
        } else {
          Navigator.pushNamed(context, Register.routeName,
              arguments: {"phone": result.user.phoneNumber});
        }
        codeSent = false;
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print("ERROR phoneSignIn: $e");
      codeSent = false;
      MethodsProvider().hideLoadingDialog(context);
      notifyListeners();
    }
  }

  Future<void> updateSelectedTopics(int index) async {
    try {
      int idx = user.data["selected_topics"].indexOf(topics[index]["uid"]);
      if (idx != -1) {
        user.data["selected_topics"].removeAt(idx);
      } else {
        user.data["selected_topics"].add(topics[index]["uid"]);
      }
      await db.collection("users").doc(user.uid).update(
          {"profile_info.selected_topics": user.data["selected_topics"]});
      notifyListeners();
    } catch (e) {
      print("ERROR updateSelectedTopics: $e");
    }
  }

  updateAvailableTutorships() {
    try {
      availableTutorships.forEach((tuto) {});
    } catch (e) {
      print("ERROR updateAvailableTutorships: $e");
    }
  }

  listenGeneralInfo() {
    try {
      generalInfoSubscription =
          db.collection("info").doc("general").snapshots().listen((event) {
        Map<String, dynamic> generalData = event.data();
        maxHours = generalData["max_hours"];
      });
    } catch (e) {
      print("ERROR listenGeneralInfo: $e");
    }
  }

  void signOut(BuildContext context) {
    try {
      auth.signOut();
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(SignIn2.routeName);
    } catch (e) {
      print("ERROR signOut: $e");
    }
  }
}

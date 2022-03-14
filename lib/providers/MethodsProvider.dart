import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MethodsProvider extends ChangeNotifier {
  Color blueColor = Colors.blue;
  Color orangeColor = Colors.orangeAccent;
  Color greenColor = Color.fromRGBO(127, 198, 113, 1);
  Color pieColor = Color.fromRGBO(250, 225, 135, 1);

  // Time picker
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  int selectedPeriod = 0;

  int currentView = 0;
  PersistentTabController controller;

  String currentTutorTab = "1";

  void updateCurrentView(index) {
    // currentView = index;
    controller.jumpToTab(index);
    notifyListeners();
  }

  String formatDate(DateTime date, bool isDate) {
    try {
      if (isDate) {
        return date.year.toString() +
            "-" +
            date.month.toString() +
            "-" +
            date.day.toString();
      } else {
        if (date.hour > 12) {
          return (date.hour - 12).toString() + " PM";
        } else {
          return date.hour.toString() + " AM";
        }
      }
    } catch (e) {
      print("ERROR formatDate: $e");
      return "";
    }
  }

  String getTutorshipStatusText(int status) {
    if (status == 1) {
      return "En espera de tutor";
    } else if (status == 2) {
      return "En espera de confirmación";
    } else if (status == 3) {
      return "En proceso";
    } else if (status == 4) {
      return "Finalizada";
    } else {
      return "Cancelada";
    }
  }

  Flushbar showFushBar(BuildContext context,
      {String title = "",
      String message = "",
      IconData icon = Icons.info,
      int duration = 4}) {
    try {
      return Flushbar(
        backgroundColor: blueColor,
        title: title,
        message: message,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        duration: Duration(seconds: duration),
      )..show(context);
    } catch (e) {
      print("ERROR showFushbar: $e");
      return null;
    }
  }

  Future showLoadingDialog(BuildContext context,
      {loadingText = "Cargando"}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            content: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                        "https://assets3.lottiefiles.com/packages/lf20_aBZEgS.json",
                        height: MediaQuery.of(context).size.height * 0.2),
                    Container(
                      child: Text(
                        loadingText,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.055,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )
                  ],
                )),
          );
        });
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

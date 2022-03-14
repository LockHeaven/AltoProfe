import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/screens/tutor-tutorship/TutorHistorical.dart';
import 'package:AltoProfe/screens/tutor-tutorship/TutorTutorshipDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Tutorials extends StatefulWidget {
  // const Tutorials({ Key? key }) : super(key: key);

  @override
  _TutorialsState createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  bool dataLoaded = false;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;

  String tabValue = "1";

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      firebaseProvider.getAvailableTutorships();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return null;
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: absoluteHeight * 0.15,
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.08,
                    right: screenWidth * 0.08,
                    // top: absoluteHeight * 0.04
                  ),
                  decoration: BoxDecoration(
                      color: methodsProvider.orangeColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // User data
                      Flexible(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // "Bienvenido\n" + firebaseProvider.user.data["name"],
                                "Dicta tutorías y mejora tus",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Text(
                                    // "Bienvenido\n" + firebaseProvider.user.data["name"],
                                    "ingresos ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Image.asset(
                                    "assets/icons/money.png",
                                    width: screenWidth * 0.1,
                                    height: absoluteHeight * 0.04,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: absoluteHeight * 0.03,
                      left: screenWidth * 0.04,
                      right: screenWidth * 0.04,
                      bottom: absoluteHeight * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            firebaseProvider.showSelectTopicsModal(context);
                          },
                          child: Container(
                            width: screenWidth * 0.4,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: absoluteHeight * 0.008),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5, color: Colors.grey[300])
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: screenWidth * 0.06,
                                  color: methodsProvider.blueColor,
                                ),
                                Container(
                                  child: Text(
                                    " Mis dominios",
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(TutorHistorical.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: absoluteHeight * 0.012),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, color: Colors.grey[300])
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Historial de tutorías",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.center,
                  child: CupertinoSlidingSegmentedControl(
                      thumbColor: Colors.orangeAccent,
                      padding: EdgeInsets.all(4),
                      groupValue: tabValue,
                      children: {
                        '1': Container(
                          width: screenWidth * 0.35,
                          height: absoluteHeight * 0.04,
                          alignment: Alignment.center,
                          child: Text("Tutorías Activas",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: (tabValue == "1")
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        '2': Container(
                          width: screenWidth * 0.35,
                          height: absoluteHeight * 0.04,
                          alignment: Alignment.center,
                          child: Text(
                            "Tutorías Disponibles",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: (tabValue == "2")
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      },
                      onValueChanged: (val) {
                        setState(() {
                          tabValue = val;
                        });
                        methodsProvider.currentTutorTab = val;
                      }),
                ),
                // ACTIVE TUTORSHIPS LIST
                (tabValue == "1")
                    ? (firebaseProvider.activeTutorTutorships.isEmpty)
                        ? Center(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: absoluteHeight * 0.1),
                              child: Text(
                                "No tienes tutorías activas",
                                style: TextStyle(fontSize: screenWidth * 0.043),
                              ),
                            ),
                          )
                        : Container(
                            height: absoluteHeight * 0.54,
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: absoluteHeight * 0.04),
                            child: ListView.builder(
                              itemCount:
                                  firebaseProvider.activeTutorTutorships.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                            TutorTutorshipDetails.routeName,
                                            arguments: index);
                                  },
                                  child: Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.only(
                                        bottom: absoluteHeight * 0.04),
                                    padding: EdgeInsets.symmetric(
                                        // horizontal: screenWidth * 0.02,
                                        vertical: absoluteHeight * 0.015),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[300],
                                              blurRadius: 5)
                                        ]),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 6,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: screenWidth * 0.05),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: screenWidth * 0.15,
                                                  margin: EdgeInsets.only(
                                                      right:
                                                          screenWidth * 0.04),
                                                  child: Lottie.network(
                                                    firebaseProvider
                                                                .activeTutorTutorships[
                                                            index]["topic"]
                                                        ["animation"],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      firebaseProvider
                                                              .activeTutorTutorships[
                                                          index]["topic"]["name"],
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.05,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Divider(),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  absoluteHeight *
                                                                      0.005),
                                                      child: Text(
                                                        DateFormat.MMMMEEEEd()
                                                            .format(firebaseProvider
                                                                .activeTutorTutorships[
                                                                    index][
                                                                    "tutorship_date"]
                                                                .toDate())
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenWidth *
                                                                    0.038),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Precio: ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.038,
                                                                color: Colors
                                                                    .black)),
                                                        Text(
                                                          "\$" +
                                                              firebaseProvider
                                                                  .activeTutorTutorships[
                                                                      index]
                                                                      ["topic"][
                                                                      "min_price"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.038,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                    : (firebaseProvider.filteravailableTutorships.isEmpty)
                        ? Center(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: absoluteHeight * 0.1),
                              child: Text(
                                  (firebaseProvider
                                              .user.data["selected_topics"] ==
                                          null)
                                      ? "Debes seleccionar los temas que dominas"
                                      : (firebaseProvider
                                                  .user
                                                  .data["selected_topics"]
                                                  .length ==
                                              0)
                                          ? "Debes seleccionar los temas que dominas"
                                          : "No hay tutorías disponibles",
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.043)),
                            ),
                          )
                        :
                        // AVAILABLE TUTORSHIPS LIST
                        Container(
                            height: absoluteHeight * 0.54,
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: absoluteHeight * 0.04),
                            child: ListView.builder(
                              itemCount: firebaseProvider
                                  .filteravailableTutorships.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(
                                            TutorTutorshipDetails.routeName,
                                            arguments: index);
                                  },
                                  child: Container(
                                    width: screenWidth,
                                    margin: EdgeInsets.only(
                                        bottom: absoluteHeight * 0.04),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[300],
                                              blurRadius: 5)
                                        ]),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              // horizontal: screenWidth * 0.02,
                                              vertical: absoluteHeight * 0.015),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 6,
                                                fit: FlexFit.tight,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: screenWidth * 0.05),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            screenWidth * 0.15,
                                                        margin: EdgeInsets.only(
                                                            right: screenWidth *
                                                                0.04),
                                                        child: Lottie.network(
                                                          firebaseProvider
                                                                      .filteravailableTutorships[
                                                                  index]["topic"]
                                                              ["animation"],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            firebaseProvider
                                                                        .filteravailableTutorships[
                                                                    index][
                                                                "topic"]["name"],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                        0.05,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Divider(),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        absoluteHeight *
                                                                            0.005),
                                                            child: Text(
                                                              DateFormat
                                                                      .MMMMEEEEd()
                                                                  .format(firebaseProvider
                                                                      .filteravailableTutorships[
                                                                          index]
                                                                          [
                                                                          "tutorship_date"]
                                                                      .toDate())
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth *
                                                                          0.038),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text("Precio: ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.038,
                                                                      color: Colors
                                                                          .black)),
                                                              Text(
                                                                "\$" +
                                                                    firebaseProvider
                                                                        .filteravailableTutorships[
                                                                            index]
                                                                            [
                                                                            "topic"]
                                                                            [
                                                                            "min_price"]
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenWidth *
                                                                            0.038,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ));
  }
}

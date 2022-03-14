import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentTutorshipDetails extends StatefulWidget {
  const StudentTutorshipDetails({Key key}) : super(key: key);
  static const routeName = "student-tutorship-details";

  @override
  _StudentTutorshipDetailsState createState() =>
      _StudentTutorshipDetailsState();
}

class _StudentTutorshipDetailsState extends State<StudentTutorshipDetails> {
  bool dataLoaded = false;

  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;

  int index;

  @override
  Future<void> didChangeDependencies() async {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      index = ModalRoute.of(context).settings.arguments;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: absoluteHeight * 0.08,
                        ),
                        child: Text(
                          "Descripción de la tutoría",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.055,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: absoluteHeight * 0.04),
                      padding: EdgeInsets.only(
                          top: absoluteHeight * 0.02,
                          right: screenWidth * 0.05,
                          left: screenWidth * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey[300], blurRadius: 5)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                  firebaseProvider.userTutorships[index]
                                      ["topic"]["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold)),
                              Lottie.network(
                                  firebaseProvider.userTutorships[index]
                                      ["topic"]["animation"],
                                  width: screenWidth * 0.25),
                            ],
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: screenWidth * 0.07,
                                  bottom: absoluteHeight * 0.023),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Descripción",
                                  ),
                                  Divider(),
                                  Text(
                                    firebaseProvider.userTutorships[index]
                                        ["description"],
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      margin: EdgeInsets.only(top: absoluteHeight * 0.04),
                      padding: EdgeInsets.only(
                          top: absoluteHeight * 0.02,
                          right: screenWidth * 0.12,
                          left: screenWidth * 0.12,
                          bottom: absoluteHeight * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey[300], blurRadius: 5)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Fecha"),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: absoluteHeight * 0.02),
                                child: Text(
                                  methodsProvider.formatDate(
                                      firebaseProvider.userTutorships[index]
                                              ["tutorship_date"]
                                          .toDate(),
                                      true),
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text("Hora"),
                              Text(
                                  methodsProvider.formatDate(
                                      firebaseProvider.userTutorships[index]
                                              ["tutorship_date"]
                                          .toDate(),
                                      false),
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Column(
                            children: [
                              Text("Precio por hora"),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: absoluteHeight * 0.02),
                                child: Text(
                                    "\$" +
                                        firebaseProvider.userTutorships[index]
                                                ["price"]
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text("Cantidad de horas"),
                              Text(
                                  firebaseProvider.userTutorships[index]
                                              ["hours"]
                                          .toString() +
                                      ((firebaseProvider.userTutorships[index]
                                                  ["hours"] ==
                                              1)
                                          ? " hora"
                                          : " horas"),
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          if (firebaseProvider.userTutorships[index]
                                  ["status"] ==
                              3) {
                            if (await canLaunch(
                                "https://meet.google.com/heg-kqdk-uqo")) {
                              await launch(
                                  "https://meet.google.com/heg-kqdk-uqo");
                            } else {
                              throw 'Could not launch https://meet.google.com/heg-kqdk-uqo"';
                            }
                          }
                        } catch (e) {
                          print("ERROR LAUCH URL: $e");
                        }
                      },
                      child: Container(
                        width: screenWidth,
                        margin: EdgeInsets.only(top: absoluteHeight * 0.04),
                        padding: EdgeInsets.only(
                            top: absoluteHeight * 0.02,
                            right: screenWidth * 0.05,
                            left: screenWidth * 0.02,
                            bottom: absoluteHeight * 0.02),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.grey[300], blurRadius: 5)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Google Meets  ",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                            Image.asset(
                              "assets/icons/meets.png",
                              width: screenWidth * 0.1,
                              height: absoluteHeight * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      margin: EdgeInsets.only(top: absoluteHeight * 0.04),
                      padding: EdgeInsets.only(
                          top: absoluteHeight * 0.02,
                          right: screenWidth * 0.05,
                          left: screenWidth * 0.02,
                          bottom: absoluteHeight * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey[300], blurRadius: 5)
                          ]),
                      child: (firebaseProvider.userTutorships[index]["tutor"] !=
                              null)
                          ? Container(
                              // height: absoluteHeight * 0.07,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        firebaseProvider.userTutorships[index]
                                            ["tutor"]["photo_url"],
                                        width: screenWidth * 0.2,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: screenWidth * 0.02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            firebaseProvider
                                                    .userTutorships[index]
                                                ["tutor"]["name"],
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical:
                                                    absoluteHeight * 0.007),
                                            child: Text(
                                              firebaseProvider
                                                      .userTutorships[index]
                                                  ["tutor"]["institution"],
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                              ),
                                            ),
                                          ),
                                          (firebaseProvider
                                                          .userTutorships[index]
                                                      ["sugested_price"] !=
                                                  null)
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      "Precio sugerido: \$",
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.04),
                                                    ),
                                                    Text(
                                                      firebaseProvider
                                                          .userTutorships[index]
                                                              ["sugested_price"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.04,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: absoluteHeight * 0.05,
                              alignment: Alignment.center,
                              child: Text(
                                "En espera de un tutor",
                                style: TextStyle(
                                  color: methodsProvider.blueColor,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              (firebaseProvider.userTutorships[index]["status"] == 2)
                  ? Container(
                      margin: EdgeInsets.only(
                          top: absoluteHeight * 0.04,
                          bottom: absoluteHeight * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              Future.delayed(Duration(milliseconds: 500),
                                  () async {
                                await firebaseProvider.updateTutorshipStatus(
                                    firebaseProvider.userTutorships[index]
                                        ["uid"],
                                    1);
                              });
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              height: absoluteHeight * 0.06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Rechazar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Accept
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              Future.delayed(Duration(milliseconds: 500),
                                  () async {
                                await firebaseProvider.updateTutorshipStatus(
                                    firebaseProvider.userTutorships[index]
                                        ["uid"],
                                    3);
                              });
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              height: absoluteHeight * 0.06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent[700],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Aceptar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              (firebaseProvider.userTutorships[index]["status"] < 3)
                  ? GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 500), () async {
                          await firebaseProvider.cancelTutorship(
                              firebaseProvider.userTutorships[index]["uid"]);
                        });
                      },
                      child: Container(
                        width: screenWidth,
                        height: absoluteHeight * 0.06,
                        margin: EdgeInsets.only(
                            bottom: absoluteHeight * 0.05,
                            top: (firebaseProvider.userTutorships[index]
                                        ["status"] ==
                                    2)
                                ? 0
                                : absoluteHeight * 0.1),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Cancelar tutoría",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(),
              (firebaseProvider.userTutorships[index]["status"] == 3)
                  ? GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 500), () async {
                          await firebaseProvider.updateTutorshipStatus(
                              firebaseProvider.userTutorships[index]["uid"], 4);
                        });
                      },
                      child: Container(
                        width: screenWidth,
                        height: absoluteHeight * 0.06,
                        margin: EdgeInsets.only(
                            bottom: absoluteHeight * 0.05,
                            top: (firebaseProvider.userTutorships[index]
                                        ["status"] ==
                                    2)
                                ? 0
                                : absoluteHeight * 0.1),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Finalizar tutoría",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorTutorshipDetails extends StatefulWidget {
  const TutorTutorshipDetails({Key key}) : super(key: key);
  static const routeName = "tutor-tutorship-details";

  @override
  _TutorTutorshipDetailsState createState() => _TutorTutorshipDetailsState();
}

class _TutorTutorshipDetailsState extends State<TutorTutorshipDetails> {
  bool dataLoaded = false;

  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;

  int index;
  String currentTutorTabIndex;
  TextEditingController priceController = new TextEditingController();

  @override
  Future<void> didChangeDependencies() async {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      index = ModalRoute.of(context).settings.arguments;
      currentTutorTabIndex = methodsProvider.currentTutorTab;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: absoluteHeight,
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
                          Flexible(
                            flex: 4,
                            child: Column(
                              children: [
                                Text(
                                    ((currentTutorTabIndex == "1")
                                            ? firebaseProvider.activeTutorTutorships
                                            : firebaseProvider
                                                .availableTutorships)[index]
                                        ["topic"]["name"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold)),
                                Lottie
                                    .network(
                                        ((currentTutorTabIndex == "1")
                                                ? firebaseProvider
                                                    .activeTutorTutorships
                                                : firebaseProvider
                                                    .availableTutorships)[index]
                                            ["topic"]["animation"],
                                        width: screenWidth * 0.25),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 6,
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
                                    ((currentTutorTabIndex == "1")
                                            ? firebaseProvider.activeTutorTutorships
                                            : firebaseProvider
                                                .availableTutorships)[index]
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
                                      ((currentTutorTabIndex == "1")
                                                  ? firebaseProvider
                                                      .activeTutorTutorships
                                                  : firebaseProvider
                                                      .availableTutorships)[
                                              index]["tutorship_date"]
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
                                      ((currentTutorTabIndex == "1")
                                                  ? firebaseProvider
                                                      .activeTutorTutorships
                                                  : firebaseProvider
                                                      .availableTutorships)[
                                              index]["tutorship_date"]
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
                                        ((currentTutorTabIndex == "1")
                                                    ? firebaseProvider
                                                        .activeTutorTutorships
                                                    : firebaseProvider
                                                        .availableTutorships)[
                                                index]["price"]
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text("Cantidad de horas"),
                              Text(
                                  ((currentTutorTabIndex == "1")
                                                  ? firebaseProvider
                                                      .activeTutorTutorships
                                                  : firebaseProvider
                                                      .availableTutorships)[index]
                                              ["hours"]
                                          .toString() +
                                      ((((currentTutorTabIndex == "1")
                                                      ? firebaseProvider
                                                          .activeTutorTutorships
                                                      : firebaseProvider
                                                          .availableTutorships)[
                                                  index]["hours"] ==
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
                          if (((currentTutorTabIndex == "1")
                                  ? firebaseProvider.activeTutorTutorships
                                  : firebaseProvider
                                      .availableTutorships)[index]["status"] ==
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
                          // top: absoluteHeight * 0.02,
                          right: screenWidth * 0.05,
                          left: screenWidth * 0.02,
                          // bottom: absoluteHeight * 0.02
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.grey[300], blurRadius: 5)
                            ]),
                        child: (((currentTutorTabIndex == "1")
                                        ? firebaseProvider.activeTutorTutorships
                                        : firebaseProvider
                                            .availableTutorships)[index]
                                    ["status"] ==
                                1)
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                child: TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    expands: false,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        prefixText: "\$",
                                        prefixStyle:
                                            TextStyle(fontWeight: FontWeight.bold),
                                        border: InputBorder.none,
                                        labelText: "Precio sugerido (Opcional)",
                                        labelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: screenWidth * 0.04))))
                            : (((currentTutorTabIndex == "1") ? firebaseProvider.activeTutorTutorships : firebaseProvider.availableTutorships)[index]["sugested_price"] != null)
                                ? Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05,
                                        vertical: absoluteHeight * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Precio sugerido: ",
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.04),
                                        ),
                                        Text(
                                          "\$" +
                                              ((currentTutorTabIndex == '1')
                                                          ? firebaseProvider
                                                              .activeTutorTutorships
                                                          : firebaseProvider
                                                              .availableTutorships)[
                                                      index]['sugested_price']
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox()),
                  ],
                ),
              ),
              (((currentTutorTabIndex == "1")
                              ? firebaseProvider.activeTutorTutorships
                              : firebaseProvider.availableTutorships)[index]
                          ["status"] >
                      2)
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        if (((currentTutorTabIndex == "1"
                                ? firebaseProvider.activeTutorTutorships
                                : firebaseProvider
                                    .availableTutorships)[index]["status"]) ==
                            1) {
                          Navigator.pop(context);
                          if (priceController.text != "") {
                            if (int.parse(priceController.text) <=
                                ((currentTutorTabIndex == "1")
                                    ? firebaseProvider.activeTutorTutorships
                                    : firebaseProvider
                                        .availableTutorships)[index]["price"]) {
                              methodsProvider.showFushBar(context,
                                  icon: Icons.error,
                                  title: "Espera",
                                  duration: 4,
                                  message:
                                      "El precio sugerido debe ser mayor al precio establecido por el estudiante");
                            } else {
                              await firebaseProvider.updateTutorshipStatus(
                                  ((currentTutorTabIndex == "1")
                                      ? firebaseProvider.activeTutorTutorships
                                      : firebaseProvider
                                          .availableTutorships)[index]["uid"],
                                  2,
                                  sugestedPrice:
                                      int.parse(priceController.text));
                            }
                            firebaseProvider.updateFilterAvailableTutorships();
                          } else {
                            await firebaseProvider.updateTutorshipStatus(
                                ((currentTutorTabIndex == "1")
                                    ? firebaseProvider.activeTutorTutorships
                                    : firebaseProvider
                                        .availableTutorships)[index]["uid"],
                                2);
                            firebaseProvider.updateFilterAvailableTutorships();
                          }
                        } else {}
                      },
                      child: Container(
                        width: screenWidth,
                        height: absoluteHeight * 0.06,
                        margin: EdgeInsets.symmetric(
                            vertical: absoluteHeight * 0.05),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              (((currentTutorTabIndex == "1")
                                              ? firebaseProvider
                                                  .activeTutorTutorships
                                              : firebaseProvider
                                                  .availableTutorships)[index]
                                          ["status"] ==
                                      1)
                                  ? Colors.greenAccent[700]
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          (((currentTutorTabIndex == "1")
                                          ? firebaseProvider.activeTutorTutorships
                                          : firebaseProvider
                                              .availableTutorships)[index]
                                      ["status"] ==
                                  1)
                              ? "Estoy interesado"
                              : "En espera de aceptación",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

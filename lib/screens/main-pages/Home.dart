import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/screens/student-tutorship/RequestTutorship.dart';
import 'package:AltoProfe/screens/student-tutorship/StudentHistorical.dart';
import 'package:AltoProfe/screens/student-tutorship/StudentTutorshipDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  // const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool dataLoaded = false;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;

  @override
  Future<void> didChangeDependencies() async {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      firebaseProvider.getUserTutorships();
      // setState(() {});
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
                      color: methodsProvider.blueColor,
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
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // "Bienvenido\n" + firebaseProvider.user.data["name"],
                                    "Solicita un tutor para que te ayude",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        // "Bienvenido\n" + firebaseProvider.user.data["name"],
                                        "con tus dudas ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Image.asset(
                                        "assets/icons/book.png",
                                        width: screenWidth * 0.1,
                                        height: absoluteHeight * 0.04,
                                      ),
                                    ],
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
                if (firebaseProvider.userTutorships.isEmpty)
                  Container(
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: absoluteHeight * 0.05),
                          child: Text(
                            "Aún no has solicitado tutorías",
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              top: absoluteHeight * 0.03),
                          child: Divider(color: Colors.grey),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: absoluteHeight * 0.03),
                          height: absoluteHeight * 0.25,
                          child: Lottie.network(
                              "https://assets7.lottiefiles.com/packages/lf20_oojuetow.json"),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: absoluteHeight * 0.05),
                          child: Text(
                            "¿Necesitas ayuda con alguna\nasignatura o trabajo?",
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            try {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(RequestTutorship.routeName);
                            } catch (e) {
                              print("ERROR nav: $e");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: absoluteHeight * 0.05,
                                bottom: absoluteHeight * 0.1),
                            height: absoluteHeight * 0.055,
                            width: screenWidth * 0.6,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: methodsProvider.blueColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Solicitar tutoría",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.042,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                else
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                child: Text(
                                  "Tutorías activas",
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(StudentHistorical.routeName);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                      vertical: absoluteHeight * 0.012),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.grey[300])
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Historial de solicitudes",
                                    style: TextStyle(
                                        color: methodsProvider.blueColor,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TUTORSHIPS LIST
                        Container(
                          height: absoluteHeight * 0.45,
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: ListView.builder(
                            itemCount: firebaseProvider.userTutorships.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                          StudentTutorshipDetails.routeName,
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
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: absoluteHeight * 0.015),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Estado: ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: screenWidth * 0.04),
                                            ),
                                            Text(
                                              methodsProvider
                                                  .getTutorshipStatusText(
                                                firebaseProvider
                                                        .userTutorships[index]
                                                    ["status"],
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: screenWidth * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.035,
                                            vertical: absoluteHeight * 0.015),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              fit: FlexFit.loose,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    (firebaseProvider.userTutorships[
                                                                    index]
                                                                ["tutor"] !=
                                                            null)
                                                        ? Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  Image.network(
                                                                firebaseProvider
                                                                            .userTutorships[index]
                                                                        [
                                                                        "tutor"]
                                                                    [
                                                                    "photo_url"],
                                                                width:
                                                                    screenWidth *
                                                                        0.15,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[300],
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Icon(
                                                              Icons.person,
                                                              size:
                                                                  screenWidth *
                                                                      0.08,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                    (firebaseProvider.userTutorships[
                                                                    index]
                                                                ["tutor"] !=
                                                            null)
                                                        ? Column(
                                                            children: [
                                                              Text(
                                                                firebaseProvider
                                                                    .userTutorships[
                                                                        index][
                                                                        "tutor"]
                                                                        ["name"]
                                                                    .split(
                                                                        " ")[0],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenWidth *
                                                                            0.04,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    top: absoluteHeight *
                                                                        0.005),
                                                                child: Text(
                                                                  firebaseProvider
                                                                              .userTutorships[index]
                                                                          [
                                                                          "tutor"]
                                                                      [
                                                                      "institution"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        screenWidth *
                                                                            0.038,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : Container(
                                                            margin: EdgeInsets.only(
                                                                top:
                                                                    absoluteHeight *
                                                                        0.01),
                                                            child: Text(
                                                                "Sin asignar",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .orange,
                                                                  fontSize:
                                                                      screenWidth *
                                                                          0.038,
                                                                )),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 6,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: screenWidth * 0.05),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      firebaseProvider
                                                              .userTutorships[
                                                          index]["topic"]["name"],
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.042,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  absoluteHeight *
                                                                      0.005),
                                                      child: Text(
                                                        DateFormat.MMMMEEEEd()
                                                            .format(firebaseProvider
                                                                .userTutorships[
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
                                                        Text("Hora: "),
                                                        Text(
                                                          methodsProvider.formatDate(
                                                              firebaseProvider
                                                                  .userTutorships[
                                                                      index][
                                                                      "tutorship_date"]
                                                                  .toDate(),
                                                              false),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.038,
                                                              color: Colors
                                                                  .orange),
                                                        )
                                                      ],
                                                    )
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
                        Container(
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              bottom: absoluteHeight * 0.015),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ),
                        Center(
                          child: Container(
                            margin:
                                EdgeInsets.only(bottom: absoluteHeight * 0.02),
                            child: Text(
                              "¿Necesitas ayuda con alguna materia?",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenWidth * 0.036),
                            ),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(RequestTutorship.routeName);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: absoluteHeight * 0.04),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.15,
                                  vertical: absoluteHeight * 0.02),
                              decoration: BoxDecoration(
                                color: methodsProvider.blueColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Solicitar tutoría",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}

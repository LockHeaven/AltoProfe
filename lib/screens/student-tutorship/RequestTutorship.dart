import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/widgets/time_picker.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class RequestTutorship extends StatefulWidget {
  // const RequestTutorship({ Key? key }) : super(key: key);
  static const routeName = "/request-tutorship";

  @override
  _RequestTutorshipState createState() => _RequestTutorshipState();
}

class _RequestTutorshipState extends State<RequestTutorship> {
  bool dataLoaded = false;
  bool loading = false;

  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;

  TextEditingController priceController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  Map<String, dynamic> selectedTopic = {};
  String selectedJourney;
  DateTime selectedDate = DateTime.now();
  int minRanking = 3;
  int selectedHours;

  List<DropdownMenuItem> topicsItems = [];
  List<DropdownMenuItem> hoursItems = [];

  CalendarController _calendarController;

  @override
  Future<void> didChangeDependencies() async {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      firebaseProvider.topics.forEach((topic) {
        topicsItems.add(DropdownMenuItem(
          child: Text(topic["name"]),
          value: topic["name"],
        ));
      });
      for (int i = 1; i <= 6; i++) {
        hoursItems.add(DropdownMenuItem(
          child: (i == 1)
              ? Text(
                  i.toString() + " hora",
                  style: TextStyle(fontSize: screenWidth * 0.037),
                )
              : Text(i.toString() + " horas",
                  style: TextStyle(fontSize: screenWidth * 0.037)),
          value: i,
        ));
      }
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> _validateTutorshipData(BuildContext scaffoldContext) async {
    try {
      setState(() {
        loading = true;
      });
      if (selectedTopic["name"] == null) {
        methodsProvider.showFushBar(scaffoldContext,
            icon: Icons.error,
            title: "Espera",
            message: "Debes seleccionar el tema de la tutoría");
      } else if (descriptionController.text.isEmpty) {
        methodsProvider.showFushBar(scaffoldContext,
            icon: Icons.error,
            title: "Espera",
            message: "Debes proporcionar una descripción de la tutoría");
      } else if (priceController.text.isEmpty) {
        methodsProvider.showFushBar(scaffoldContext,
            icon: Icons.error,
            title: "Espera",
            message:
                "Debes establecer el precio mínimo (por hora) de la tutoría");
      } else if (int.parse(priceController.text) < selectedTopic["min_price"]) {
        methodsProvider.showFushBar(scaffoldContext,
            icon: Icons.error,
            title: "Espera",
            message: "El precio establecido es menor al mínimo");
      } else if (selectedHours == null) {
        methodsProvider.showFushBar(scaffoldContext,
            icon: Icons.error,
            title: "Espera",
            message: "Debes seleccionar la cantidad de horas");
      } else {
        DateTime finishDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            int.parse(methodsProvider.hoursController.text),
            int.parse(methodsProvider.minutesController.text));
        if (methodsProvider.selectedPeriod == 1) {
          if (methodsProvider.hoursController.text != "12") {
            finishDate = finishDate.add(Duration(hours: 12));
          }
        } else {
          if (methodsProvider.hoursController.text == "12") {
            finishDate = finishDate.subtract(Duration(hours: 12));
          }
        }
        if (finishDate.hour >= 0 && finishDate.hour < 4) {
          methodsProvider.showFushBar(scaffoldContext,
              icon: Icons.error,
              title: "Espera",
              message:
                  "No puedes hacer solicitudes entre las 12 am y las 4 am");
        } else {
          Map<String, dynamic> tutorshipData = {
            "creation_date": DateTime.now(),
            "tutorship_date": finishDate,
            "topic": selectedTopic,
            "description": descriptionController.text,
            "hours": selectedHours,
            "price": int.parse(priceController.text),
            "student": {
              "uid": firebaseProvider.user.uid,
              "name": firebaseProvider.user.data["name"],
              "phone": firebaseProvider.user.data["phone"],
            },
            "status": 1,
            "rejected_tutors": [],
            "contact_type": "google_meets"
          };
          bool resp = await firebaseProvider.createTutorship(tutorshipData);
          if (resp) {
            Navigator.pop(context);
          } else {
            methodsProvider.showFushBar(scaffoldContext,
                icon: Icons.error,
                title: "Ocurrió un error!",
                message: "Intenta nuevamente");
          }
        }
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("ERROR validateTutorshipData: $e");
      methodsProvider.showFushBar(scaffoldContext,
          icon: Icons.error,
          title: "Ocurrió un error!",
          message: "Intenta nuevamente");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // HEADER
                  Container(
                    // margin: EdgeInsets.only(top: absoluteHeight * 0.02),
                    padding: EdgeInsets.symmetric(
                        vertical: absoluteHeight * 0.03,
                        horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: methodsProvider.blueColor,
                      // borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: screenWidth * 0.1,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Solicitar tutoría",
                            style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.13,
                        )
                      ],
                    ),
                  ),
                  // TOPICS TITLE
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.05),
                    child: Text(
                      "¿Qué deseas aprender?",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // TOPICS DROPDOWN
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: absoluteHeight * 0.03),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[300], blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(7)),
                    child: Container(
                      child: DropdownButton(
                          isExpanded: true,
                          value: selectedTopic["name"],
                          underline: SizedBox(),
                          hint: Text("Seleccionar materia"),
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.black),
                          onChanged: (val) {
                            int index = firebaseProvider.topics
                                .indexWhere((topic) => topic["name"] == val);
                            setState(() {
                              selectedTopic = firebaseProvider.topics[index];
                            });
                          },
                          items: topicsItems),
                    ),
                  ),
                  // DESCRIPTION
                  Container(
                      margin: EdgeInsets.only(top: absoluteHeight * 0.01),
                      child: Text(
                        "Descripción de la tutoría",
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        top: absoluteHeight * 0.02,
                        left: screenWidth * 0.1,
                        right: screenWidth * 0.1),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[300], blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(7)),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: Colors.black54, fontSize: screenWidth * 0.04),
                    ),
                  ),
                  // JOURNEY TITLE
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.03),
                    child: Text(
                      "Selecciona la fecha de la tutoría",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // // JOURNEY SELECTOR
                  // Container(
                  //     margin: EdgeInsets.only(
                  //       top: absoluteHeight * 0.025,
                  //       left: screenWidth * 0.07,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedJourney = "Mañana";
                  //             });
                  //           },
                  //           child: Container(
                  //             padding: EdgeInsets.all(5),
                  //             decoration: BoxDecoration(
                  //                 color: (selectedJourney != "Mañana")
                  //                     ? Colors.transparent
                  //                     : methodsProvider.blueColor,
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: Column(
                  //               children: [
                  //                 // Icon(
                  //                 //   Icons.ac_unit,
                  //                 //   size: screenWidth * 0.15,
                  //                 //   color: (selectedJourney != "Mañana")
                  //                 //       ? Colors.grey
                  //                 //       : Colors.white,
                  //                 // ),
                  //                 Image.asset(
                  //                   'assets/icons/mañana.png',
                  //                   scale: 2,
                  //                 ),
                  //                 Container(
                  //                     margin: EdgeInsets.only(
                  //                         top: absoluteHeight * 0.01),
                  //                     child: Text(
                  //                       "Mañana",
                  //                       style: TextStyle(
                  //                         fontSize: screenWidth * 0.038,
                  //                         color: (selectedJourney != "Mañana")
                  //                             ? Colors.grey
                  //                             : Colors.white,
                  //                       ),
                  //                     )),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedJourney = "Tarde";
                  //             });
                  //           },
                  //           child: Container(
                  //             padding: EdgeInsets.all(5),
                  //             decoration: BoxDecoration(
                  //                 color: (selectedJourney != "Tarde")
                  //                     ? Colors.transparent
                  //                     : methodsProvider.blueColor,
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: Column(
                  //               children: [
                  //                 // Icon(
                  //                 //   Icons.ac_unit,
                  //                 //   size: screenWidth * 0.15,
                  //                 //   color: (selectedJourney != "Tarde")
                  //                 //       ? Colors.grey
                  //                 //       : Colors.white,
                  //                 // ),
                  //                 Image.asset(
                  //                   'assets/icons/tarde.png',
                  //                   scale: 2,
                  //                 ),
                  //                 Container(
                  //                     margin: EdgeInsets.only(
                  //                         top: absoluteHeight * 0.01),
                  //                     child: Text(
                  //                       "Tarde",
                  //                       style: TextStyle(
                  //                         fontSize: screenWidth * 0.038,
                  //                         color: (selectedJourney != "Tarde")
                  //                             ? Colors.grey
                  //                             : Colors.white,
                  //                       ),
                  //                     )),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedJourney = "Noche";
                  //             });
                  //           },
                  //           child: Container(
                  //             margin:
                  //                 EdgeInsets.only(right: screenWidth * 0.07),
                  //             padding: EdgeInsets.all(5),
                  //             decoration: BoxDecoration(
                  //                 color: (selectedJourney != "Noche")
                  //                     ? Colors.transparent
                  //                     : methodsProvider.blueColor,
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: Column(
                  //               children: [
                  //                 // Icon(
                  //                 //   Icons.ac_unit,
                  //                 //   size: screenWidth * 0.15,
                  //                 //   color: (selectedJourney != "Noche")
                  //                 //       ? Colors.grey
                  //                 //       : Colors.white,
                  //                 // ),
                  //                 Image.asset(
                  //                   'assets/icons/noche.png',
                  //                   scale: 2,
                  //                 ),
                  //                 Container(
                  //                     margin: EdgeInsets.only(
                  //                         top: absoluteHeight * 0.01),
                  //                     child: Text(
                  //                       "Noche",
                  //                       style: TextStyle(
                  //                         fontSize: screenWidth * 0.038,
                  //                         color: (selectedJourney != "Noche")
                  //                             ? Colors.grey
                  //                             : Colors.white,
                  //                       ),
                  //                     )),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     )),
                  Container(
                    margin: EdgeInsets.only(
                        top: absoluteHeight * 0.03,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05),
                    child: TableCalendar(
                      onDaySelected: (newDate, list, list2) {
                        setState(() {
                          selectedDate = newDate;
                        });
                      },
                      availableGestures: AvailableGestures.none,
                      calendarController: _calendarController,
                      headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonVisible: false,
                          titleTextBuilder: (date, locale) =>
                              DateFormat.MMMd(locale)
                                  .format(date)
                                  .toUpperCase(),
                          titleTextStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                          )),
                      calendarStyle: CalendarStyle(),
                      startDay: DateTime.now(),
                      // locale: 'es_ES',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.04),
                    child: Text(
                      "Selecciona la hora de la tutoría",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TimePicker(),
                        Container(
                          width: screenWidth * 0.3,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300], blurRadius: 5)
                              ]),
                          child: DropdownButton(
                              isExpanded: true,
                              value: selectedHours,
                              underline: SizedBox(),
                              hint: Text(
                                "Cantidad de horas",
                                style: TextStyle(fontSize: screenWidth * 0.034),
                              ),
                              style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.black),
                              onChanged: (val) {
                                // int index = firebaseProvider.topics.indexWhere(
                                //     (topic) => topic["name"] == val);
                                setState(() {
                                  selectedHours = val;
                                });
                              },
                              items: hoursItems),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.035),
                    child: Text(
                      "Precio de la tutoría",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.035),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    width: screenWidth * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(color: Colors.grey[300], blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(7)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      expands: false,
                      decoration: InputDecoration(
                          prefixText: "\$",
                          border: InputBorder.none,
                          labelText: "Min: \$" +
                              (selectedTopic["min_price"] ?? 0).toString() +
                              " COP (Por hora)",
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: absoluteHeight * 0.035),
                  //   child: Text("Valoración mínima",
                  //       style: TextStyle(
                  //           fontSize: screenWidth * 0.045,
                  //           fontWeight: FontWeight.bold)),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: absoluteHeight * 0.03),
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             minRanking = 1;
                  //           });
                  //         },
                  //         child: Container(
                  //           child: Icon(
                  //             (minRanking >= 1)
                  //                 ? Icons.star
                  //                 : Icons.star_border,
                  //             size: screenWidth * 0.13,
                  //             color: (minRanking >= 1)
                  //                 ? methodsProvider.blueColor
                  //                 : Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             minRanking = 2;
                  //           });
                  //         },
                  //         child: Container(
                  //           child: Icon(
                  //             (minRanking >= 2)
                  //                 ? Icons.star
                  //                 : Icons.star_border,
                  //             size: screenWidth * 0.13,
                  //             color: (minRanking >= 2)
                  //                 ? methodsProvider.blueColor
                  //                 : Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             minRanking = 3;
                  //           });
                  //         },
                  //         child: Container(
                  //           child: Icon(
                  //             (minRanking >= 3)
                  //                 ? Icons.star
                  //                 : Icons.star_border,
                  //             size: screenWidth * 0.13,
                  //             color: (minRanking >= 3)
                  //                 ? methodsProvider.blueColor
                  //                 : Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             minRanking = 4;
                  //           });
                  //         },
                  //         child: Container(
                  //           child: Icon(
                  //             (minRanking >= 4)
                  //                 ? Icons.star
                  //                 : Icons.star_border,
                  //             size: screenWidth * 0.13,
                  //             color: (minRanking >= 4)
                  //                 ? methodsProvider.blueColor
                  //                 : Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             minRanking = 5;
                  //           });
                  //         },
                  //         child: Container(
                  //           child: Icon(
                  //             (minRanking >= 5)
                  //                 ? Icons.star
                  //                 : Icons.star_border,
                  //             size: screenWidth * 0.13,
                  //             color: (minRanking >= 5)
                  //                 ? methodsProvider.blueColor
                  //                 : Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // BUTTON REQUEST TUTORSHIP
                  GestureDetector(
                    onTap: () {
                      _validateTutorshipData(scaffoldContext);
                    },
                    child: Container(
                      width: screenWidth * 0.6,
                      height: absoluteHeight * 0.065,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: absoluteHeight * 0.06,
                          bottom: absoluteHeight * 0.08),
                      decoration: BoxDecoration(
                          color: methodsProvider.blueColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: (!loading)
                          ? Text(
                              "Solicitar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

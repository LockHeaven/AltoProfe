import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/screens/student-tutorship/StudentTutorshipDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentHistorical extends StatefulWidget {
  StudentHistorical({Key key}) : super(key: key);
  static const routeName = "student-historical";

  @override
  _StudentHistoricalState createState() => _StudentHistoricalState();
}

class _StudentHistoricalState extends State<StudentHistorical> {
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
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: absoluteHeight * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "Historial",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: absoluteHeight * 0.03,
                    left: screenWidth * 0.08,
                    right: screenWidth * 0.08),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: firebaseProvider.historicalUserTutorships.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: screenWidth,
                      margin: EdgeInsets.only(bottom: absoluteHeight * 0.04),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey[300], blurRadius: 5)
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Estado: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.04),
                                ),
                                Text(
                                  methodsProvider.getTutorshipStatusText(
                                    firebaseProvider
                                            .historicalUserTutorships[index]
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
                                        (firebaseProvider
                                                        .historicalUserTutorships[
                                                    index]["tutor"] !=
                                                null)
                                            ? Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    firebaseProvider
                                                                .historicalUserTutorships[
                                                            index]["tutor"]
                                                        ["photo_url"],
                                                    width: screenWidth * 0.15,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.person,
                                                  size: screenWidth * 0.08,
                                                  color: Colors.black,
                                                )),
                                        (firebaseProvider
                                                        .historicalUserTutorships[
                                                    index]["tutor"] !=
                                                null)
                                            ? Column(
                                                children: [
                                                  Text(
                                                    firebaseProvider
                                                        .historicalUserTutorships[
                                                            index]["tutor"]
                                                            ["name"]
                                                        .split(" ")[0],
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: absoluteHeight *
                                                            0.005),
                                                    child: Text(
                                                      firebaseProvider
                                                                  .historicalUserTutorships[
                                                              index]["tutor"]
                                                          ["institution"],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.038,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(
                                                margin: EdgeInsets.only(
                                                    top: absoluteHeight * 0.01),
                                                child: Text("Sin asignar",
                                                    style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize:
                                                          screenWidth * 0.038,
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
                                                  .historicalUserTutorships[
                                              index]["topic"]["name"],
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.042,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: absoluteHeight * 0.005),
                                          child: Text(
                                            DateFormat.MMMMEEEEd()
                                                .format(firebaseProvider
                                                    .historicalUserTutorships[
                                                        index]["tutorship_date"]
                                                    .toDate())
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.038),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text("Hora: "),
                                            Text(
                                              methodsProvider.formatDate(
                                                  firebaseProvider
                                                      .historicalUserTutorships[
                                                          index]
                                                          ["tutorship_date"]
                                                      .toDate(),
                                                  false),
                                              style: TextStyle(
                                                  fontSize: screenWidth * 0.038,
                                                  color: Colors.orange),
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
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

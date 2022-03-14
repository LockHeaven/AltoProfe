import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TutorHistorical extends StatefulWidget {
  TutorHistorical({Key key}) : super(key: key);
  static const routeName = "tutor-historical";

  @override
  _TutorHistoricalState createState() => _TutorHistoricalState();
}

class _TutorHistoricalState extends State<TutorHistorical> {
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
                decoration: BoxDecoration(color: Colors.orangeAccent),
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
                  itemCount: firebaseProvider.historicalTutorTutorships.length,
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
                                            .historicalTutorTutorships[index]
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
                                      child: Lottie.network(
                                          firebaseProvider
                                                  .historicalTutorTutorships[
                                              index]["topic"]["animation"],
                                          width: screenWidth * 0.15)),
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
                                                  .historicalTutorTutorships[
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
                                                    .historicalTutorTutorships[
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
                                                      .historicalTutorTutorships[
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

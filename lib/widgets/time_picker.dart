import 'dart:ui';

import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> with TickerProviderStateMixin {
  bool dataLoaded = false;
  double screenWidth;
  double absoluteHeight;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  FocusNode hoursFocus = new FocusNode();
  FocusNode minutesFocus = new FocusNode();
  TabController tabBarController;

  @override
  void initState() {
    tabBarController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      if (methodsProvider.hoursController.text.isEmpty) {
        methodsProvider.hoursController.text = '00';
      }
      if (methodsProvider.minutesController.text.isEmpty) {
        methodsProvider.minutesController.text = '00';
      }
      // methodsProvider.selectedPeriod = 0;
      hoursFocus.addListener(() {
        if (hoursFocus.hasFocus) {
          // if (methodsProvider.hoursController.text == "00") {
          methodsProvider.hoursController.text = "";
          // }
        } else {
          if (methodsProvider.hoursController.text == "") {
            methodsProvider.hoursController.text = '00';
          } else if (methodsProvider.hoursController.text.length == 1) {
            methodsProvider.hoursController.text =
                '0' + methodsProvider.hoursController.text;
          }
        }
      });
      tabBarController = TabController(
        initialIndex: (methodsProvider.selectedPeriod != null)
            ? methodsProvider.selectedPeriod
            : 0,
        length: 2,
        vsync: this,
      );
      minutesFocus.addListener(() {
        if (minutesFocus.hasFocus) {
          // if (methodsProvider.minutesController.text == "00") {
          methodsProvider.minutesController.text = "";
          // }
        } else {
          if (methodsProvider.minutesController.text == "") {
            methodsProvider.minutesController.text = '00';
          } else if (methodsProvider.minutesController.text.length == 1) {
            methodsProvider.minutesController.text =
                '0' + methodsProvider.minutesController.text;
          }
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Time field
          Container(
            height: absoluteHeight * 0.05,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours field
                Container(
                  width: screenWidth * 0.13,
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (newHours) {
                      try {
                        int hours = int.parse(newHours);
                        if (newHours != "00") {
                          if (newHours.length == 1) {
                            if (hours > 1) {
                              methodsProvider.hoursController.text =
                                  '0' + newHours;
                              if (methodsProvider.minutesController.text !=
                                  "00") {
                                hoursFocus.unfocus();
                              } else {
                                hoursFocus.nextFocus();
                              }
                              // setState(() {});
                            }
                          } else {
                            if (hours > 12) {
                              methodsProvider.hoursController.text = '12';
                              if (methodsProvider.minutesController.text !=
                                  "00") {
                                hoursFocus.unfocus();
                              } else {
                                hoursFocus.nextFocus();
                              }
                              // setState(() {});
                            } else {
                              if (methodsProvider.minutesController.text !=
                                  "00") {
                                hoursFocus.unfocus();
                              } else {
                                hoursFocus.nextFocus();
                              }
                              // setState(() {});
                            }
                          }
                        } else {
                          methodsProvider.hoursController.text = "";
                        }
                      } catch (e) {
                        print('ERROR hourseFiled: $e');
                        methodsProvider.hoursController.text = "";
                      }
                    },
                    controller: methodsProvider.hoursController,
                    focusNode: hoursFocus,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    expands: false,
                    textAlign: TextAlign.center,
                    maxLengthEnforced: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.036),
                    decoration: InputDecoration(
                        border: InputBorder.none, counter: SizedBox()),
                  ),
                ),
                Container(
                  child: Text(
                    ":",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05),
                  ),
                ),
                // Minutes field
                Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.13,
                  child: TextField(
                    onChanged: (newMinutes) {
                      try {
                        int minutes = int.parse(newMinutes);
                        if (newMinutes.length == 1) {
                          if (minutes > 6) {
                            methodsProvider.minutesController.text =
                                '0' + newMinutes;
                            minutesFocus.nextFocus();
                            // setState(() {});
                          }
                        } else {
                          if (minutes > 60) {
                            methodsProvider.minutesController.text = '60';
                            minutesFocus.nextFocus();
                            // setState(() {});
                          } else {
                            minutesFocus.nextFocus();
                            // setState(() {});
                          }
                        }
                      } catch (e) {
                        print('ERROR minutesField: $e');
                        methodsProvider.minutesController.text = "";
                      }
                    },
                    controller: methodsProvider.minutesController,
                    focusNode: minutesFocus,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    expands: false,
                    maxLengthEnforced: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.036),
                    decoration: InputDecoration(
                        border: InputBorder.none, counter: SizedBox()),
                  ),
                )
              ],
            ),
          ),
          // Am Pm
          Container(
              margin: EdgeInsets.only(left: screenWidth * 0.02),
              height: absoluteHeight * 0.05,
              decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(2),
              child: TabBar(
                controller: tabBarController,
                onTap: (value) {
                  methodsProvider.selectedPeriod = value;
                },
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                labelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Container(
                      // height: absoluteHeight * 0.07,
                      width: screenWidth * 0.12,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: methodsProvider.myColor.withOpacity(0.1)
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'AM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.03),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'PM',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.03),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

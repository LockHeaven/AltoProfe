import 'package:AltoProfe/screens/student-tutorship/RequestTutorship.dart';
import 'package:AltoProfe/screens/student-tutorship/StudentHistorical.dart';
import 'package:AltoProfe/screens/student-tutorship/StudentTutorshipDetails.dart';
import 'package:flutter/material.dart';
import 'providers/FirebaseProvider.dart';
import 'providers/MethodsProvider.dart';
import 'screens/Initial.dart';
import 'screens/sign-in/Register.dart';
import 'screens/sign-in/SignIn.dart';
import 'package:provider/provider.dart';

import 'screens/sign-in/SignIn2.dart';
import 'screens/main-pages/MainPage.dart';
import 'screens/tutor-tutorship/TutorHistorical.dart';
import 'screens/tutor-tutorship/TutorTutorshipDetails.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MethodsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alto Profe',
      debugShowCheckedModeBanner: false,
      locale: Locale('es', 'CO'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (BuildContext context) => Initial(),
        SignIn.routeName: (BuildContext context) => SignIn(),
        SignIn2.routeName: (BuildContext context) => SignIn2(),
        Register.routeName: (BuildContext context) => Register(),
        MainPage.routeName: (BuildContext context) => MainPage(),
        RequestTutorship.routeName: (BuildContext context) =>
            RequestTutorship(),
        StudentTutorshipDetails.routeName: (BuildContext context) =>
            StudentTutorshipDetails(),
        TutorTutorshipDetails.routeName: (BuildContext context) =>
            TutorTutorshipDetails(),
        StudentHistorical.routeName: (BuildContext context) =>
            StudentHistorical(),
        TutorHistorical.routeName: (BuildContext context) => TutorHistorical(),
      },
    );
  }
}

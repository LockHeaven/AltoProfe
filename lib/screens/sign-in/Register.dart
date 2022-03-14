import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool dataLoaded = false;
  double screenWidth;
  double absoluteHeight;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController documentController = new TextEditingController();
  TextEditingController genreController = new TextEditingController();
  TextEditingController institutionController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  bool receiveTutorships = true;
  bool teachTutorships = false;

  bool hidePassword = true;

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      Map arguments = ModalRoute.of(context).settings.arguments;
      phoneController.text = arguments["phone"];
    }
    super.didChangeDependencies();
  }

  void _validateFields(BuildContext context) {
    try {
      if (nameController.text.isEmpty) {
        methodsProvider.showFushBar(context,
            title: "Espera",
            message: "¡Debes ingresar tu nombre!",
            icon: Icons.error);
      } else if (documentController.text.isEmpty) {
        methodsProvider.showFushBar(context,
            title: "Espera",
            message: "¡Debes ingresar tu número de documento!",
            icon: Icons.error);
      } else if (emailController.text.isEmpty) {
        methodsProvider.showFushBar(context,
            title: "Espera",
            message: "¡Debes ingresar tu correo electrónico!",
            icon: Icons.error);
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        methodsProvider.showFushBar(context,
            title: "Espera",
            message: "¡Debes ingresar un correo válido!",
            icon: Icons.error);
      } else {
        Map<String, dynamic> userData = {
          "profile_info": {
            "name": nameController.text,
            "phone": phoneController.text,
            "document": documentController.text,
            "institution": institutionController.text,
            "email": emailController.text,
            "photo_url": "",
            "selected_topics": []
          },
          "user_type": {"student": true, "tutor": true},
          "register_date": DateTime.now(),
        };
        firebaseProvider.registerUser(context, userData);
      }
    } catch (e) {
      print("ERROR validateFields: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Center(
              child: Container(
                margin: EdgeInsets.only(top: absoluteHeight * 0.05),
                child: Text(
                  "Registar tus datos",
                  style: TextStyle(
                      color: methodsProvider.blueColor,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Name field
            Container(
              margin: EdgeInsets.only(
                  top: absoluteHeight * 0.05,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 5)
                  ]),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: screenWidth * 0.041),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Nombre completo",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontSize: screenWidth * 0.041)),
              ),
            ),
            // Phone field
            Container(
              margin: EdgeInsets.only(
                  top: absoluteHeight * 0.03,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 5)
                  ]),
              child: TextField(
                controller: phoneController,
                enabled: false,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                maxLengthEnforced: true,
                style: TextStyle(fontSize: screenWidth * 0.041),
                decoration: InputDecoration(
                    counter: SizedBox(),
                    border: InputBorder.none,
                    labelText: "Número de celular",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontSize: screenWidth * 0.041)),
              ),
            ),
            // Document field
            Container(
              margin: EdgeInsets.only(
                  top: absoluteHeight * 0.03,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 5)
                  ]),
              child: TextField(
                controller: documentController,
                maxLength: 10,
                maxLengthEnforced: true,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: screenWidth * 0.041),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    labelText: "Documento de indentidad",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontSize: screenWidth * 0.041)),
              ),
            ),
            // Institution field
            Container(
              margin: EdgeInsets.only(
                  top: absoluteHeight * 0.03,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 5)
                  ]),
              child: TextField(
                controller: institutionController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: screenWidth * 0.041),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Institución educativa",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontSize: screenWidth * 0.041)),
              ),
            ),
            // Email field
            Container(
              margin: EdgeInsets.only(
                  top: absoluteHeight * 0.03,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 5)
                  ]),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: screenWidth * 0.041),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Correo electrónico",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontSize: screenWidth * 0.041)),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: absoluteHeight * 0.025,
                    right: screenWidth * 0.15,
                    left: screenWidth * 0.15),
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                )),
            // Container(
            //   margin: EdgeInsets.only(top: absoluteHeight * 0.01),
            //   child: Text(
            //     "Selecciona los servicios que deseas",
            //     style: TextStyle(
            //         fontSize: screenWidth * 0.034, color: Colors.grey),
            //   ),
            // ),
            // Type of user
            // Container(
            //   margin: EdgeInsets.only(
            //     top: absoluteHeight * 0.03,
            //   ),
            //   height: absoluteHeight * 0.17,
            //   width: double.infinity,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 0,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             GestureDetector(
            //               onTap: () {
            //                 setState(() {
            //                   receiveTutorships = !receiveTutorships;
            //                 });
            //               },
            //               child: AnimatedContainer(
            //                 margin: EdgeInsets.only(
            //                     left: screenWidth * 0.1,
            //                     right: screenWidth * 0.1),
            //                 duration: Duration(milliseconds: 300),
            //                 padding: EdgeInsets.symmetric(
            //                     horizontal: screenWidth * 0.04,
            //                     vertical: absoluteHeight * 0.02),
            //                 decoration: BoxDecoration(
            //                     color: (receiveTutorships)
            //                         ? methodsProvider.pieColor
            //                         : Colors.white,
            //                     boxShadow: [
            //                       BoxShadow(
            //                           color: Colors.grey[300], blurRadius: 5)
            //                     ],
            //                     borderRadius: BorderRadius.circular(10)),
            //                 child: Text(
            //                   "Quiero recibir tutorías",
            //                   style: TextStyle(
            //                       fontSize: screenWidth * 0.039,
            //                       fontWeight: (receiveTutorships)
            //                           ? FontWeight.bold
            //                           : FontWeight.normal),
            //                 ),
            //               ),
            //             ),
            //             GestureDetector(
            //               onTap: () {
            //                 setState(() {
            //                   teachTutorships = !teachTutorships;
            //                 });
            //               },
            //               child: AnimatedContainer(
            //                 margin: EdgeInsets.only(
            //                     top: absoluteHeight * 0.03,
            //                     left: screenWidth * 0.1,
            //                     right: screenWidth * 0.1),
            //                 duration: Duration(milliseconds: 300),
            //                 padding: EdgeInsets.symmetric(
            //                     horizontal: screenWidth * 0.04,
            //                     vertical: absoluteHeight * 0.02),
            //                 decoration: BoxDecoration(
            //                     color: (teachTutorships)
            //                         ? methodsProvider.pieColor
            //                         : Colors.white,
            //                     boxShadow: [
            //                       BoxShadow(
            //                           color: Colors.grey[300], blurRadius: 5)
            //                     ],
            //                     borderRadius: BorderRadius.circular(10)),
            //                 child: Text(
            //                   "¡Quiero dictar tutorías!",
            //                   style: TextStyle(
            //                       fontSize: screenWidth * 0.039,
            //                       fontWeight: (teachTutorships)
            //                           ? FontWeight.bold
            //                           : FontWeight.normal),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       Positioned(
            //         right: screenWidth * 0.1,
            //         child: Lottie.network(
            //             "https://assets2.lottiefiles.com/packages/lf20_5gabkutg.json",
            //             width: screenWidth * 0.3,
            //             repeat: false),
            //       ),
            //     ],
            //   ),
            // ),
            // Register button
            GestureDetector(
              onTap: () {
                _validateFields(context);
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: absoluteHeight * 0.08,
                    bottom: absoluteHeight * 0.04,
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: absoluteHeight * 0.020),
                decoration: BoxDecoration(
                    color: methodsProvider.blueColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Registrarme",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04),
                ),
              ),
            ),
          ],
        ),
      ))),
    );
  }
}

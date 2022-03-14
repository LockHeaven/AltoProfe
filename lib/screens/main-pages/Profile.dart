import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  // const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool dataLoaded = false;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;
  double screenWidth;
  double absoluteHeight;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController documentController = new TextEditingController();
  TextEditingController genreController = new TextEditingController();
  TextEditingController institutionController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  bool student;
  bool tutor;

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      dataLoaded = true;
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
      nameController.text = firebaseProvider.user.data["name"];
      documentController.text = firebaseProvider.user.data["document"];
      institutionController.text = firebaseProvider.user.data["institution"];
      emailController.text = firebaseProvider.user.data["email"];
      phoneController.text = firebaseProvider.user.data["phone"];
      student = firebaseProvider.user.type["student"];
      tutor = firebaseProvider.user.type["tutor"];
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
            children: [
              // Title
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: absoluteHeight * 0.05),
                  child: Text(
                    "Información personal",
                    style: TextStyle(
                        color: methodsProvider.blueColor,
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Profile image
              Container(
                margin: EdgeInsets.only(top: absoluteHeight * 0.05),
                height: absoluteHeight * 0.16,
                width: screenWidth * 0.3,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  firebaseProvider.user.data["photo_url"]))),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: methodsProvider.blueColor),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: screenWidth * 0.045,
                          ),
                        ))
                  ],
                ),
              ),
              // Name field
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 9,
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        enabled: false,
                        style: TextStyle(fontSize: screenWidth * 0.041),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Nombre completo",
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.041)),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: screenWidth * 0.05,
                        ))
                  ],
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
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: screenWidth * 0.041),
                  decoration: InputDecoration(
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
                  enabled: false,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 9,
                      child: TextField(
                        enabled: false,
                        controller: institutionController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: screenWidth * 0.041),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Institución educativa",
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.041)),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(
                          // padding: EdgeInsets.only(left: screenWidth * 0.1),
                          child: Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: screenWidth * 0.05,
                          ),
                        ))
                  ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 9,
                      child: TextField(
                        enabled: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: screenWidth * 0.041),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Correo electrónico",
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.041)),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(
                          // padding: EdgeInsets.only(left: screenWidth * 0.1),
                          child: Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: screenWidth * 0.05,
                          ),
                        ))
                  ],
                ),
              ),
              // User type
              // Container(
              //     margin: EdgeInsets.only(
              //         top: absoluteHeight * 0.03,
              //         left: screenWidth * 0.1,
              //         right: screenWidth * 0.1),
              //     child: Column(
              //       children: [
              //         Container(
              //           margin: EdgeInsets.only(bottom: absoluteHeight * 0.02),
              //           child: Text(
              //             "Servicios activos",
              //             style: TextStyle(
              //                 fontSize: screenWidth * 0.04,
              //                 fontWeight: FontWeight.w500),
              //           ),
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Container(
              //                 // padding: EdgeInsets.symmetric(
              //                 //     horizontal: screenWidth * 0.02,
              //                 //     vertical: absoluteHeight * 0.008),
              //                 width: screenWidth * 0.25,
              //                 height: absoluteHeight * 0.09,
              //                 decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(10),
              //                     boxShadow: [
              //                       BoxShadow(
              //                           color: Colors.grey[300], blurRadius: 5)
              //                     ]),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Text(
              //                       "Estudiante",
              //                       style: TextStyle(
              //                           fontSize: screenWidth * 0.036),
              //                     ),
              //                     Switch(
              //                         value: student,
              //                         onChanged: (val) async {
              //                           await firebaseProvider
              //                               .updateServiceStatus(val, true);
              //                           if (firebaseProvider
              //                               .user.type["tutor"]) {
              //                             methodsProvider.updateCurrentView(2);
              //                           } else {
              //                             methodsProvider.updateCurrentView(1);
              //                           }
              //                         })
              //                   ],
              //                 )),
              //             Container(
              //                 // padding: EdgeInsets.symmetric(
              //                 //     horizontal: screenWidth * 0.02,
              //                 //     vertical: absoluteHeight * 0.008),
              //                 width: screenWidth * 0.25,
              //                 height: absoluteHeight * 0.09,
              //                 decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(10),
              //                     boxShadow: [
              //                       BoxShadow(
              //                           color: Colors.grey[300], blurRadius: 5)
              //                     ]),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Text(
              //                       "Tutor",
              //                       style: TextStyle(
              //                           fontSize: screenWidth * 0.036),
              //                     ),
              //                     Switch(
              //                         value: tutor,
              //                         onChanged: (val) async {
              //                           await firebaseProvider
              //                               .updateServiceStatus(val, false);
              //                           if (firebaseProvider
              //                               .user.type["tutor"]) {
              //                             methodsProvider.updateCurrentView(2);
              //                           } else {
              //                             methodsProvider.updateCurrentView(1);
              //                           }
              //                         })
              //                   ],
              //                 )),
              //           ],
              //         )
              //       ],
              //     )),

              // Log out button
              GestureDetector(
                onTap: () {
                  firebaseProvider.signOut(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: absoluteHeight * 0.05,
                      bottom: absoluteHeight * 0.05,
                      left: screenWidth * 0.1,
                      right: screenWidth * 0.1),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: absoluteHeight * 0.015),
                  decoration: BoxDecoration(
                      color: methodsProvider.blueColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Cerrar sesión",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}

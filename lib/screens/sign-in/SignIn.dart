import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:AltoProfe/screens/sign-in/Register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/sign-in';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool dataLoad = false;
  bool loading = false;
  double screenWidth;
  double absoluteHeight;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;

  bool hidePassword = true;
  String selectedRole = '';

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  void didChangeDependencies() {
    if (!dataLoad) {
      screenWidth = MediaQuery.of(context).size.width;
      absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      methodsProvider = Provider.of<MethodsProvider>(context);
      firebaseProvider = Provider.of<FirebaseProvider>(context);
    }
    super.didChangeDependencies();
  }

  Future<void> validateStudentsFields(BuildContext context) async {
    // try {
    //   setState(() {
    //     loading = true;
    //   });
    //   if (emailController.text.isEmpty) {
    //     methodsProvider.showSnackBar(
    //         context: context,
    //         title: "Espera",
    //         message: "¡Debes ingresar tu correo!",
    //         icon: Icons.error);
    //   } else if (!RegExp(
    //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //       .hasMatch(emailController.text)) {
    //     methodsProvider.showSnackBar(
    //         context: context,
    //         title: "Espera",
    //         message: "¡Debes ingresar un correo válido!",
    //         icon: Icons.error);
    //   } else if (passwordController.text.isEmpty) {
    //     methodsProvider.showSnackBar(
    //         context: context,
    //         title: "Espera",
    //         message: "¡Debes ingresar tu contraseña!",
    //         icon: Icons.error);
    //   } else {
    //     await firebaseProvider.emailSignIn(
    //         context, emailController.text, passwordController.text);
    //   }
    //   setState(() {
    //     loading = false;
    //   });
    // } catch (e) {
    //   print("ERROR vaidateStudentFields: $e");
    // }
  }

  // Future<void> validateEmailToRecover(
  //     BuildContext context, String email) async {
  //   try {
  //     if (email.isEmpty) {
  //       methodsProvider.showSnackBar(
  //           context: context,
  //           icon: Icons.error,
  //           title: "Espera",
  //           message: "Debes ingresar un correo");
  //     } else if (!RegExp(
  //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //         .hasMatch(email)) {
  //       methodsProvider.showSnackBar(
  //           context: context,
  //           icon: Icons.error,
  //           title: "Espera",
  //           message: "Debes ingresar un correo válido");
  //     } else {
  //       await firebaseProvider.sendEmailToRecover(email);
  //       methodsProvider.showSnackBar(
  //           context: context,
  //           icon: Icons.done,
  //           title: "Listo",
  //           message: "El correo de recuperación se ha enviado");
  //     }
  //   } catch (e) {
  //     print("ERROR validateEmailToRecover: $e");
  //     Navigator.pop(context);
  //     methodsProvider.showSnackBar(
  //         context: context,
  //         icon: Icons.error,
  //         title: "Espera",
  //         message: "Ha ocurrido un error. Intenta nuevamente");
  //   }
  // }

  void showRecoverPasswordModal(BuildContext context) {
    try {
      TextEditingController emailRecover = new TextEditingController();
      double screenWidth = MediaQuery.of(context).size.width;
      double absoluteHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (modalContext) {
            return Builder(builder: (BuildContext modalContext) {
              return Container(
                height: absoluteHeight * 0.4,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: absoluteHeight * 0.025),
                      child: Text(
                        "Recuperar contraseña",
                        style: TextStyle(
                            color: methodsProvider.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.043),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: absoluteHeight * 0.03),
                      child: Text(
                        "Te enviaremos un correo para que puedas restablecer tu contraseña.",
                        style: TextStyle(
                            fontSize: screenWidth * 0.037,
                            color: Colors.grey[500]),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: Colors.grey[300])
                          ]),
                      child: TextField(
                        controller: emailRecover,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // validateEmailToRecover(modalContext, emailRecover.text);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: absoluteHeight * 0.04),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: absoluteHeight * 0.015),
                        decoration: BoxDecoration(
                            color: methodsProvider.blueColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Enviar",
                            style: TextStyle(
                                fontSize: screenWidth * 0.037,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    )
                  ],
                ),
              );
            });
          });
    } catch (e) {
      print("ERROR showRecoverPasswordModal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              width: screenWidth,
              margin: EdgeInsets.only(
                  left: screenWidth * 0.1, right: screenWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.2),
                    child: Text(
                      'ALTO PROFE',
                      style: TextStyle(
                          color: methodsProvider.blueColor,
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Sub title
                  Container(
                    margin: EdgeInsets.only(top: absoluteHeight * 0.01),
                    child: Text(
                      'Soluciones académicas',
                      style: TextStyle(
                          color: methodsProvider.blueColor,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState: (selectedRole == '')
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 500),
                    firstChild: Container(
                      width: screenWidth,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: absoluteHeight * 0.15),
                            child: Text(
                              'Ingresar como',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  color: Colors.grey[600]),
                            ),
                          ),
                          // Student button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = 'Estudiante';
                              });
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: absoluteHeight * 0.03),
                              width: screenWidth * 0.6,
                              height: absoluteHeight * 0.06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: methodsProvider.blueColor),
                              child: Text(
                                'Estudiante',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // Tutor button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = 'Tutor';
                              });
                            },
                            child: Container(
                                margin:
                                    EdgeInsets.only(top: absoluteHeight * 0.03),
                                width: screenWidth * 0.6,
                                height: absoluteHeight * 0.06,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // color: methodsProvider.greenColor,
                                    color: methodsProvider.blueColor),
                                child: Text(
                                  'Tutor',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.043,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    secondChild: Container(
                      width: screenWidth,
                      margin: EdgeInsets.only(top: absoluteHeight * 0.1),
                      child: Column(
                        children: [
                          // Student
                          // Set rol
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = '';
                                emailController.text = "";
                                passwordController.text = "";
                              });
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: methodsProvider.blueColor,
                                  ),
                                  Text(
                                    'Escoger rol',
                                    style: TextStyle(
                                        color: methodsProvider.blueColor,
                                        fontSize: screenWidth * 0.04),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                              margin:
                                  EdgeInsets.only(top: absoluteHeight * 0.05),
                              child: (selectedRole == 'Estudiante')
                                  ?
                                  // Student
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Email field
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.01),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.04),
                                          // decoration: BoxDecoration(
                                          //     color: Colors.white,
                                          //     borderRadius:
                                          //         BorderRadius.circular(10),
                                          //     boxShadow: [
                                          //       BoxShadow(
                                          //           color: Colors.grey[300],
                                          //           blurRadius: 5)
                                          //     ]),
                                          child: TextField(
                                            controller: emailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.04),
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.email),
                                                labelText: 'Correo electrónico',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        screenWidth * 0.04)),
                                          ),
                                        ),
                                        // Password field
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: absoluteHeight * 0.03,
                                              left: screenWidth * 0.01,
                                              right: screenWidth * 0.01),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.04),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 8,
                                                child: TextField(
                                                  controller:
                                                      passwordController,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: hidePassword,
                                                  style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.04),
                                                  decoration: InputDecoration(
                                                      labelText: 'Contraseña',
                                                      labelStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize:
                                                              screenWidth *
                                                                  0.04)),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    hidePassword =
                                                        !hidePassword;
                                                  });
                                                },
                                                child: Icon(
                                                  (hidePassword)
                                                      ? Icons
                                                          .remove_red_eye_outlined
                                                      : Icons.remove_red_eye,
                                                  color: (hidePassword)
                                                      ? Colors.black
                                                      : methodsProvider
                                                          .blueColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: absoluteHeight * 0.03,
                                              left: screenWidth * 0.05,
                                              right: screenWidth * 0.05,
                                              bottom: absoluteHeight * 0.04),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 7,
                                                fit: FlexFit.tight,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        showRecoverPasswordModal(
                                                            scaffoldContext);
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          'He olvidado mi contraseña',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.035,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color:
                                                                  methodsProvider
                                                                      .blueColor),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(Register
                                                                .routeName);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top:
                                                                absoluteHeight *
                                                                    0.015),
                                                        child: Text(
                                                          'Registrarme',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.037,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  methodsProvider
                                                                      .blueColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                flex: 3,
                                                fit: FlexFit.loose,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    validateStudentsFields(
                                                        scaffoldContext);
                                                  },
                                                  child: (!loading)
                                                      ? Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                      0.05,
                                                              vertical:
                                                                  absoluteHeight *
                                                                      0.015),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  methodsProvider
                                                                      .blueColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            'Iniciar',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.037,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )
                                                      : CircularProgressIndicator(),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                          'O puedes ingresar con:',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: absoluteHeight * 0.04),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                height: screenWidth * 0.1,
                                                child: Image.asset(
                                                  'assets/icons/google.png',
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                height: screenWidth * 0.1,
                                                child: Image.asset(
                                                  'assets/icons/facebook.png',
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  :
                                  // Tutor
                                  Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: absoluteHeight * 0.01,
                                              left: screenWidth * 0.01,
                                              right: screenWidth * 0.01),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey[300],
                                                    blurRadius: 5)
                                              ]),
                                          child: TextField(
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                prefixIcon: Icon(Icons.phone),
                                                prefixText: "+57 ",
                                                labelText: "Número de celular"),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: absoluteHeight * 0.05),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth * 0.1,
                                                vertical:
                                                    absoluteHeight * 0.015),
                                            decoration: BoxDecoration(
                                                color:
                                                    methodsProvider.blueColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              "Iniciar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      screenWidth * 0.036),
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:AltoProfe/providers/FirebaseProvider.dart';
import 'package:AltoProfe/providers/MethodsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class SignIn2 extends StatefulWidget {
  static const routeName = '/sign-in-2';
  @override
  _SignIn2State createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  bool dataLoad = false;
  bool loading = false;
  double screenWidth;
  double absoluteHeight;
  MethodsProvider methodsProvider;
  FirebaseProvider firebaseProvider;

  bool hidePassword = true;
  String selectedRole = '';

  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _smsCode = new TextEditingController();

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

  Future<void> _validateFields(BuildContext context) async {
    try {
      // setState(() {
      //   loading = true;
      // });
      if (!firebaseProvider.codeSent) {
        if (_phoneController.text.isEmpty) {
          methodsProvider.showFushBar(context,
              title: "Espera",
              message: "¡Debes ingresar tu número de celular!",
              icon: Icons.error);
        } else if (_phoneController.text.length < 10) {
          methodsProvider.showFushBar(context,
              title: "Espera",
              message: "¡Debes ingresar tu número de celular completo!",
              icon: Icons.error);
        } else {
          await firebaseProvider.validatePhone(context, _phoneController.text);
        }
      } else {
        await firebaseProvider.phoneSignIn(context, _smsCode.text.trim());
        _phoneController.text = "";
        _smsCode.text = "";
      }
      // setState(() {
      //   loading = false;
      // });
    } catch (e) {
      print("ERROR vaidateStudentFields: $e");
      // setState(() {
      //   loading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          margin: EdgeInsets.only(
              left: screenWidth * 0.1, right: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Title
              Container(
                margin: EdgeInsets.only(top: absoluteHeight * 0.1),
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
              // Littie animation
              Container(
                height: absoluteHeight * 0.45,
                child: Lottie.network(
                    "https://assets2.lottiefiles.com/packages/lf20_wepuwkno.json"),
              ),
              // Container(
              //   child: Divider(),
              // ),
              Container(
                margin: EdgeInsets.only(top: absoluteHeight * 0.02),
                child: Text(
                  "Inicia sesión o regístrate con tu celular",
                  style: TextStyle(
                      fontSize: screenWidth * 0.038, color: Colors.grey),
                ),
              ),
              (firebaseProvider.codeSent)
                  ? Container(
                      margin: EdgeInsets.only(top: absoluteHeight * 0.03),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "+57 " + _phoneController.text,
                        style: TextStyle(
                            fontSize: screenWidth * 0.037,
                            color: methodsProvider.greenColor),
                      ),
                    )
                  : SizedBox(),
              // Phone field
              Container(
                margin: EdgeInsets.only(top: absoluteHeight * 0.03),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300], blurRadius: 5)
                    ]),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.03),
                      child: Icon(
                        Icons.phone,
                        size: screenWidth * 0.045,
                        color: methodsProvider.blueColor,
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: (!firebaseProvider.codeSent)
                            ? _phoneController
                            : _smsCode,
                        maxLength: (!firebaseProvider.codeSent) ? 10 : 6,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        cursorColor: methodsProvider.blueColor,
                        style: TextStyle(
                            fontSize: screenWidth * 0.04, letterSpacing: 0.2),
                        decoration: InputDecoration(
                          counter: SizedBox(),
                          border: InputBorder.none,
                          // prefixText: " +57 ",
                          hintText: (!firebaseProvider.codeSent)
                              ? "Número de celular"
                              : "Codigo de verificación",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Continue button
              GestureDetector(
                onTap: () {
                  if (!loading) {
                    _validateFields(context);
                  }
                },
                child: Container(
                    width: screenWidth * 0.5,
                    height: absoluteHeight * 0.053,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: absoluteHeight * 0.03),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: methodsProvider.blueColor,
                    ),
                    child: (loading)
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            "Continuar",
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
              )
            ],
          ),
        ),
      )),
    );
  }
}

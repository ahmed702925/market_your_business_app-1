import 'package:shoryanelhayat_user/providers/auth.dart';
import 'package:shoryanelhayat_user/providers/usersProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Animation/FadeAnimation.dart';

import 'dart:io' show Platform;

import 'org_widgets/arc_banner_image.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _submitLoading = false;
  final _emailFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  final _repeatPwdFocusNode = FocusNode();

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool validateStrongPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
              title: const Text('حدث خطأ ما'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: const Text('حسنا'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
          : CupertinoAlertDialog(
              title: const Text('حدث خطأ ما'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text('حسنا'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _pwdFocusNode.dispose();
    _emailFocusNode.dispose();
    _repeatPwdFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _submitLoading = true;
    });

    try {
      // Log user in
      String localId = await Provider.of<Auth>(context, listen: false).signup(
        _authData['email'],
        _authData['password'],
      );

      await Provider.of<UsersPtovider>(context, listen: false).addUser(
        localId,
        _authData['name'],
        _authData['email'],
        _authData['password'],
      );

      Flushbar(
        message: 'تم تسيجل البريد الإلكتروني بنجاح',
        icon: Icon(
          Icons.thumb_up,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(8),
        borderRadius: 8,
      )..show(context).then(
          (value) => Navigator.of(context).pushReplacementNamed('/Login'));
    } catch (error) {
      print(error);
      const errorMessage = 'البريد الإلكتروني موجود بالفعل ';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _submitLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * (1 / 3);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              //  height: height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -100,
                    child: ClipPath(
                      clipper: ArcClipper(),
                      child: Image.asset(
                        'assets/images/backg2.png',
                        fit: BoxFit.fill,
                        height: 600.0,
                        width: width,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 100),
                    child: Center(
                      child: const Text(
                        'مرحبا بك فى شريان الحياة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
///////////////////////////////////

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 150),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                          1.5,
                          Text(
                            "تسجيل حساب",
                            style: TextStyle(
//                          color: Color.fromRGBO(49, 39, 79, 1),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          1.7,
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(196, 135, 198, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ]),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_emailFocusNode);
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "اسم المستخدم",
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Colors.green[700],
                                          ),
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      onSaved: (value) {
                                        _authData['name'] = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      focusNode: _emailFocusNode,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_pwdFocusNode);
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "البريد الإلكتروني",
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.green[700],
                                        ),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        bool emailValid = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value);
                                        if (!emailValid) {
                                          return 'البريد الإلكتروني غير صالح ';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['email'] = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      focusNode: _pwdFocusNode,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_repeatPwdFocusNode);
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "كلمة المرور",
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.green[700],
                                          ),
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      obscureText: true,
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 5) {
                                          return 'كلمة المرور قصيرة جدا';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['password'] = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      focusNode: _repeatPwdFocusNode,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "تأكيد كلمة المرور",
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.green[700],
                                          ),
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      obscureText: true,
                                      controller: _passwordConfirmController,
                                      validator: (value) {
                                        if (value != _passwordController.text) {
                                          return 'غير مطابقة';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _authData['password'] = value;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  FadeAnimation(
                                    1.9,
                                    InkWell(
                                      onTap: () {
                                        if (!_submitLoading) {
                                          _submit();
                                        }
                                      }, // handle your onTap here
                                      child: Container(
                                        height: 45,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 0, 30, 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
//                          color: Color.fromRGBO(49, 39, 79, 1),
                                          color: Colors.green[700],
                                        ),
                                        child: Center(
                                          child: _submitLoading == false
                                              ? Text(
                                                  "تسجيل حساب",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                )
                                              : CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            2,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                              child: Center(
                                child: FlatButton(
                                  child: const Text(
                                    "أمتلك حساب",
                                    style: TextStyle(
                                      color: Color.fromRGBO(49, 39, 79, .6),
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, '/Login'),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )

///////////////////////////////////////////
                ],
              ),
            ),

            //////////////////////////00000000000000000000000000000000
          ],
        ),
      ),
    );
  }
}

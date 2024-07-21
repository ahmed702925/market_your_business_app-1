import 'package:shoryanelhayat_user/notifiers/activity_notifier.dart';
import 'package:shoryanelhayat_user/notifiers/organization_notifier.dart';
import 'package:shoryanelhayat_user/providers/auth.dart';
import 'package:shoryanelhayat_user/providers/usersProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Animation/FadeAnimation.dart';
import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dart:io' show Platform;

class NormalDenotationScreen extends StatefulWidget {
  @override
  _NormalDenotationScreenState createState() => _NormalDenotationScreenState();
}

class _NormalDenotationScreenState extends State<NormalDenotationScreen> {
  String selectedType;
  ActivityNotifier activityNotifier;
  OrganizationNotifier orgNotifier;
  var _submitLoading = false;
  List<String> _denoteType = <String>[
    'نقدى',
    'عينى',
    'نقدى وعينى',
  ];

  List<IconData> _donateIcons = <IconData>[
    FontAwesomeIcons.moneyBill,
    FontAwesomeIcons.eye,
    Icons.looks_two,
  ];

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController moneyController = new TextEditingController();
  TextEditingController itemsController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'mobile': '',
    'address': '',
    'time': '',
    'money': '',
    'items': '',
    'amount': '',
  };
  Future<void> _submit(BuildContext context) async {
    String amount = _authData['amount'];
    String items = _authData['items'];

    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    if (selectedType == null) {
      _showErrorDialog("من فضلك اختار نوع التبرع ");
      return;
    }
    if (_image == null && selectedType != 'نقدى') {
      _showErrorDialog("من فضلك اضاف صورة التبرع ");
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _submitLoading = true;
    });
    if (selectedType != 'نقدى') {
      _downloadUrl = await uploadImage(_image);
      if (selectedType == 'عينى') {
        amount = "";
      }
    } else {
      items = "";
      _downloadUrl =
          'https://www.moneyunder30.com/wp-content/uploads/2018/05/2_how-to-invest-648x364-c-default.jpg';
    }

    var arabicTimeFormat = DateFormat.Hms('ar');
    var arabicDateFormat = DateFormat.yMd('ar');

    String formattedTime = arabicTimeFormat.format(DateTime.now());
    String formattedDate = arabicDateFormat.format(DateTime.now());
    String arabicFormattedDateTime = formattedTime + ' ' + formattedDate;
    final data = Provider.of<Auth>(context);
    try {
      await Provider.of<UsersPtovider>(context, listen: false)
          .makeDonationRequest2(
              userId: data.userData.id,
              orgId: orgNotifier.currentOrg.id,
              orgName: orgNotifier.currentOrg.orgName,
              availableOn: _authData['time'],
              donationAmount: amount,
              donationDate: arabicFormattedDateTime,
              donationType: selectedType,
              activityName: activityNotifier.currentActivity.name,
              donatorAddress: _authData['address'],
              donatorItems: items,
              image: _downloadUrl,
              mobile: _authData['mobile'],
              userName: _authData['name']);

      Flushbar(
        message: 'تم ارسال طلب تبرعك بنجاح',
        icon: Icon(
          Icons.thumb_up,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      )..show(context).then((value) => Navigator.of(context).pop());
    } catch (error) {
      print(error);
      const errorMessage = ' حدث خطا ما';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _submitLoading = false;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  final globalKey = GlobalKey<ScaffoldState>();
  var _isLoadImg = false;
  File _image;
  String _downloadUrl;

  Future getImage() async {
    File img;

    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        _image = img;
        _isLoadImg = true;
      } else {
        // _image = img;
        if (_image != null) {
          _isLoadImg = true;
        } else {
          _isLoadImg = false;
        }
      }
    });
  }

  Future<String> uploadImage(File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;

    String _downloadUrl = await storageReference.getDownloadURL();

    return _downloadUrl;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
              title: const Text('تحذير'),
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
              title: const Text('تحذير'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text('حسنا'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    })
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
    orgNotifier = Provider.of<OrganizationNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nested(),
    );
  }

  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.green[700],
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  activityNotifier.currentActivity.name != null
                      ? activityNotifier.currentActivity.name
                      : 'تبرع الآن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                background: Stack(children: <Widget>[
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              NetworkImage("https://i.imgur.com/5xFZM4o.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ])),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(0),
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(0)),
                          color: Colors.green[700].withOpacity(0.75),
                        ),
                        child: Text(
                          orgNotifier.currentOrg.orgName != null
                              ? orgNotifier.currentOrg.orgName
                              : 'تبرع الآن',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.grey[600],
                                    blurRadius: 2.0,
                                    offset: Offset(4, 2))
                              ]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "اسم المتبرع",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.green[700],
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey)),
                                validator: (value) {
                                  bool spaceRex =
                                      new RegExp(r"^\\s+$").hasMatch(value);
                                  if (spaceRex ||
                                      value.length == 0 ||
                                      value == null) {
                                    return 'ادخل الاسم من فضلك';
                                  } else if (value.length < 3) {
                                    return 'الاسم لايمكن ان يكون اقل من ثلاثه احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _authData['name'] = value;
                                },
                                controller: nameController,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "رقم التلفون المحمول",
                                    prefixIcon: Icon(
                                      Icons.mobile_screen_share,
                                      color: Colors.green[700],
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey)),
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  _authData['mobile'] = val;
                                },
                                controller: mobileController,
                                validator: (value) {
                                  bool spaceRex =
                                      new RegExp(r"^\\s+$").hasMatch(value);
                                  if (spaceRex ||
                                      value.length == 0 ||
                                      value == null) {
                                    return 'ادخل رقم الهاتف من فضلك';
                                  } else if (value.length < 11) {
                                    return 'رقم الهاتف لايمكن ان يكون اقل من 11 رقم';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0)),
                                    labelText: "العنوان",
                                    labelStyle: TextStyle(
                                        color: Colors.grey, fontSize: 24)),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 2,
                                onChanged: (val) {
                                  _authData['address'] = val;
                                },
                                validator: (value) {
                                  bool spaceRex =
                                      new RegExp(r"^\\s+$").hasMatch(value);
                                  if (spaceRex ||
                                      value.length == 0 ||
                                      value == null) {
                                    return 'ادخل العنوان من فضلك';
                                  } else if (value.length < 5) {
                                    return 'العنوان لايمكن ان يكون اقل من 5 احرف';
                                  }
                                  return null;
                                },
                                controller: addressController,
                              ),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                child: Text(
                                  'اكتب الوقت الذى تكون فيه متاح لكي ياتى مندوبنا اليك',
                                  style: TextStyle(
                                      fontSize: 17,
                                      height: 1,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0)),
                                    prefixIcon: Icon(
                                      Icons.access_time,
                                      color: Colors.green[700],
                                    ),
                                    labelStyle: TextStyle(
                                        color: Colors.grey, fontSize: 24)),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 2,
                                onChanged: (val) {
                                  _authData['time'] = val;
                                },
                                controller: timeController,
                                validator: (value) {
                                  bool spaceRex =
                                      new RegExp(r"^\\s+$").hasMatch(value);
                                  if (spaceRex ||
                                      value.length == 0 ||
                                      value == null) {
                                    return 'ادخل الوقت من فضلك';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.handsHelping,
                                  size: 25.0,
                                  color: Colors.green[700],
                                ),
                                SizedBox(width: 50.0),
                                DropdownButton(
                                  items: _denoteType
                                      .map(
                                        (value) => DropdownMenuItem(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                _donateIcons[
                                                    _denoteType.indexOf(value)],
                                                size: 25.0,
                                                color: Color(0xff11b719),
                                              ),
                                              SizedBox(width: 50.0),
                                              Text(
                                                value,
                                                style: TextStyle(
                                                    color: Color(0xff11b719)),
                                              ),
                                            ],
                                          ),
                                          value: value,
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (selectedAccountType) {
                                    print('$selectedAccountType');
                                    setState(() {
                                      selectedType = selectedAccountType;
                                    });
                                  },
                                  value: selectedType,
                                  isExpanded: false,
                                  hint: const Text(
                                    'اختار نوع التبرع',
                                    style: TextStyle(color: Color(0xff11b719)),
                                  ),
                                )
                              ],
                            ),
                            if (selectedType == 'نقدى' ||
                                selectedType == 'نقدى وعينى')
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: " المبلغ بالجنيه المصرى ",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.moneyBill,
                                        color: Colors.green[700],
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey)),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    _authData['amount'] = value;
                                  },
                                  controller: moneyController,
                                  validator: (value) {
                                    bool spaceRex =
                                        new RegExp(r"^\\s+$").hasMatch(value);
                                    if (spaceRex ||
                                        value.length == 0 ||
                                        value == null) {
                                      return 'ادخل المبلغ من فضلك';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            if (selectedType != 'نقدى' && selectedType != null)
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.camera,
                                      size: 25.0,
                                      color: Colors.green[700],
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        child: const Text("اضف صورة التبرع",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)))
                                  ],
                                ),
                              ),
                            if (selectedType != 'نقدى' && selectedType != null)
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.grey[300],
                                  width: 200,
                                  height: 200,
                                  child: _isLoadImg
                                      ? Image.file(_image)
                                      : Icon(
                                          Icons.add,
                                          size: 40,
                                        ),
                                ),
                                onTap: getImage,
                              ),
                            if (selectedType != 'نقدى' && selectedType != null)
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  child: const Text(
                                    'اكتب مواصفات ونوع الاشياء والكمية التي تود التبرع بها ',
                                    style: TextStyle(
                                        fontSize: 17,
                                        height: 1,
                                        fontWeight: FontWeight.bold),
                                  )),
                            if (selectedType != 'نقدى' && selectedType != null)
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                  child: const Text(
                                    ' مثال:3 اطقم ملابس و 2بطاطين....',
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1,
                                        color: Colors.grey),
                                  )),
                            if (selectedType != 'نقدى' && selectedType != null)
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(2.0)),
                                      labelText: "الوصف",
                                      labelStyle: TextStyle(
                                          color: Colors.grey, fontSize: 24)),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 3,
                                  onChanged: (value) {
                                    _authData['items'] = value;
                                  },
                                  controller: itemsController,
                                  validator: (value) {
                                    bool spaceRex =
                                        new RegExp(r"^\\s+$").hasMatch(value);
                                    if (spaceRex ||
                                        value.length == 0 ||
                                        value == null) {
                                      return 'ادخل الوصف من فضلك';
                                    }
                                    return null;
                                  },
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FadeAnimation(
                    1.9,
                    Builder(
                      builder: (ctx) => InkWell(
                        onTap: () {
                          if (!_submitLoading) {
                            _submit(ctx);
                          }
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: _submitLoading == false
                                ? Text(
                                    "تبرع الأن",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

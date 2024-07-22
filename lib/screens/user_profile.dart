import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoryanelhayat_user/models/user_nav.dart';
import 'package:shoryanelhayat_user/providers/auth.dart';
import 'package:shoryanelhayat_user/providers/shard_pref.dart';
import 'package:shoryanelhayat_user/providers/usersProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/usersProvider.dart';
import 'login_screen.dart';
import 'org_widgets/arc_banner_image.dart';

class UserProfileScreen extends StatefulWidget {
  // Organization storyline = new Organization(
  //     orgName: "wwww",
  //     description: "tttt",
  //     address: "Ramadan Elnaggar66",
  //     email: "ramadan96naggar@gmail.com99",
  //     mobileNo: "01272173025");
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UsersProvider? usersProvider;
  UserNav? userLoad;
  var _isLoadImg = false;
  var _edited = false;
  var editedClicked = false;
  var _submitLoading = false;
  XFile? _image;
  String? userName;

  final GlobalKey<FormState> _formKey = GlobalKey();
//  final globalKey = GlobalKey<ScaffoldState>();

  Future<UserNav> loadSharedPrefs() async {
    UserNav? user;
    try {
      SharedPref sharedPref = SharedPref();
      user = UserNav.fromJson(await sharedPref.read("user"));
      setState(() {
        userLoad = user;
      });
    } catch (Excepetion) {
      // do something
    }
    return user!;
  }

  Future<String> uploadImage(File image) async {
    String? _downloadUrl;
    Reference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    UploadTask uploadTask = storageReference.putFile(image);
    uploadTask.then((res) async {
      _downloadUrl = await storageReference.getDownloadURL();
    });
    return _downloadUrl!;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                title: const Text('تسجيل خروج'),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('الغاء'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'نعم',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      SharedPref sharedPref = SharedPref();
                      sharedPref.remove("user");
                      LoginScreen.googleSignIn.disconnect();
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            )
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: CupertinoAlertDialog(
                title: const Text('تسجيل خروج'),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text('الغاء'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      }),
                  CupertinoDialogAction(
                      child: const Text(
                        'نعم',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        SharedPref sharedPref = SharedPref();
                        sharedPref.remove("user");
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      })
                ],
              ),
            ),
    );
  }

  Future getImage() async {
    // File img;
    // img = await ImagePicker.pickImage(source: ImageSource.gallery);
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null) {
        _image = img;
        _isLoadImg = true;
      } else {
        if (_image != null) {
          _isLoadImg = true;
        } else {
          _isLoadImg = false;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    //this.getActivites(widget.currentOrg.id);
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    var screenWidth = MediaQuery.of(context).size.width;
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Container(
            height: 240,
            child: Stack(
              children: [
                ClipPath(
                  clipper: ArcClipper(),
                  child: Container(
                    height: 160,
                    width: screenWidth,
                    color: Colors.green,
                  ),
                ),
                userLoad == null
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(
                          child: Container(
                            width: 140,
                            height: 140,
                            //  color: Colors.lime,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: Colors.orange,
                                border:
                                    Border.all(color: Colors.white, width: 5)),
                            child: _isLoadImg
                                ? CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(_image!.path))
                                    // radius: 40.0,
                                    )
                                : userLoad!.userImage == null
                                    ? CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/profile2.png"),
                                        // radius: 40.0,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(userLoad!.userImage!),
                                        // radius: 40.0,
                                      ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(80, 170, 0, 0),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      //  color: Colors.lime,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white, width: 2)),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          getImage();
                          setState(() {
                            _edited = true;
                          });
                        },
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.green[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Center(
            child: Text(
              'الملف الشخصى',
              style: GoogleFonts.amiri(
                fontSize: 18,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            column,
            userLoad == null
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'اسم المستخدم',
                          style:
                              textTheme.titleMedium!.copyWith(fontSize: 21.0),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //  SizedBox(width: 10.0),
                            !editedClicked
                                ? Text(
                                    userName == null
                                        ? userLoad!.userName!
                                        : userName!,
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: Colors.black45,
                                      fontSize: 18.0,
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        3,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        initialValue: userName == null
                                            ? userLoad!.userName
                                            : userName,
                                        validator: (value) {
                                          if (value!.length < 3) {
                                            bool spaceRex =
                                                new RegExp(r"^\\s+$")
                                                    .hasMatch(value);
                                            if (spaceRex || value.length == 0) {
                                              return 'ادخل الاسم من فضلك';
                                            } else {
                                              return 'الاسم لايمكن ان يكون اقل من ثلاثه احرف';
                                            }
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          userName = value;
                                        },
                                      ),
                                    )),
                            !editedClicked
                                ? IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editedClicked = true;
                                      });
                                    },
                                    color: Colors.green,
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.done,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editedClicked = false;
                                        _edited = true;
                                      });
                                    },
                                    color: Colors.green,
                                  ),
                          ],
                        ),
                        Text(
                          'البريد الإلكتروني',
                          style:
                              textTheme.titleMedium!.copyWith(fontSize: 21.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          userLoad!.email!,
                          style: textTheme.bodyMedium!.copyWith(
                            color: Colors.black45,
                            fontSize: 18.0,
                          ),
                        ),
                        // Text(
                        //   ' رقم التليفون المحمول',
                        //   style: textTheme.subtitle1.copyWith(fontSize: 21.0),
                        // ),
                        // SizedBox(height: 5.0),
                        // Text(
                        //   widget.storyline.mobileNo,
                        //   style: textTheme.bodyText2.copyWith(
                        //     color: Colors.black45,
                        //     fontSize: 18.0,
                        //   ),
                        // ),
                        SizedBox(height: 5.0),
                        TextButton(
                          child: Text(
                            ' تغير كلمة المرور',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[700],
                            ),
                          ),
                          onPressed: () async {
                            try {
                              print("Email is : " + userLoad!.email!);
                              Auth auth = new Auth();
                              await auth.resetPassword(userLoad!.email!);
                              Flushbar(
                                message: 'تم إرسال رابط تغيير كلمة المرور',
                                icon: Icon(
                                  Icons.thumb_up,
                                  size: 28.0,
                                  color: Colors.blue[300],
                                ),
                                duration: Duration(seconds: 3),
                                margin: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(8),
                              )..show(context);
                            } catch (error) {
                              const errorMessage =
                                  'البريد الإلكتروني غير موجود';
                              _showErrorDialog(errorMessage);
                            }
                          },
                        ),
                        if (_edited)
                          Container(
                              height: 45,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    // side: BorderSide(color: Colors.green, width: 2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    !_submitLoading
                                        ? Text(
                                            ' حفظ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                          ),
                                  ],
                                ),
                                onPressed: () async {
                                  // if (!_formKey.currentState.validate()) {
                                  //   // Invalid!
                                  //   print("formKey.currentState IS Invalid");
                                  //   return;
                                  // }
                                  setState(() {
                                    _submitLoading = true;
                                  });
                                  String imageUrl;
                                  if (userName == null) {
                                    userName = userLoad!.userName;
                                  }
                                  if (_image == null) {
                                    imageUrl = userLoad!.userImage!;
                                  } else {
                                    imageUrl =
                                        await uploadImage(File(_image!.path));
                                  }
                                  try {
                                    await Provider.of<UsersProvider>(context,
                                            listen: false)
                                        .updateUser(
                                      userLoad!.id!,
                                      userName!,
                                      userLoad!.email!,
                                      imageUrl,
                                    );
                                    Flushbar(
                                        message: 'تم تعديل بياناتك بنجاح',
                                        icon: Icon(
                                          Icons.thumb_up,
                                          size: 28.0,
                                          color: Colors.blue[300],
                                        ),
                                        duration: Duration(seconds: 3),
                                        margin: EdgeInsets.all(8),
                                        borderRadius:
                                            BorderRadius.circular(8.0))
                                      ..show(context);
                                    setState(() {
                                      _submitLoading = false;
                                    });
                                  } catch (error) {
                                    print(error);
                                    const errorMessage = ' حدث خطا ما';
                                    _showErrorDialog(errorMessage);
                                  }
                                },
                              )),
                        Container(
                            height: 45,
                            margin: const EdgeInsets.fromLTRB(80, 100, 80, 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green,
                                backgroundColor: Colors.white, // Text color
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 2), // Border color and width
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // Button border radius
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 20.0), // Padding
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'تسجيل خروج',
                                    style: TextStyle(
                                      color: Colors.green, // Text color
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _showErrorDialog("هل تريد تسجيل الخروج");
                              },
                            )),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoryanelhayat_user/models/user_nav.dart';
import 'package:shoryanelhayat_user/providers/shard_pref.dart';
import 'package:shoryanelhayat_user/screens/help_screen.dart';
import 'package:shoryanelhayat_user/screens/login_screen.dart';
import 'package:shoryanelhayat_user/screens/my_donation_screen.dart';

import '../providers/usersProvider.dart';

class CustomNavigationDrawer extends StatefulWidget {
  @override
  _CustomNavigationDrawerState createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  UsersProvider? usersProvider;
  UserNav? userLoad;

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
                      })
                ],
              ),
            ),
    ).then((value) => Navigator.of(context).pop());
  }

  void _showErrorDialogLogin(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
              title: Text('تسجيل دخول'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text('ليس الأن'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  child: Text('تسجيل الدخول'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.pushNamed(ctx, '/Login');
                  },
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: Text('تسجيل دخول'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('ليس الأن'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('تسجيل الدخول'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.pushNamed(context, '/Login');
                  },
                )
              ],
            ),
    );
  }

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

  @override
  void initState() {
    super.initState();

    loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backg1.png',
                  ),
                  fit: BoxFit.fill),
            ),
            accountName: userLoad == null
                ? Text(
                    "مرحبا بك ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17, height: 0.5),
                  )
                : Text(
                    userLoad!.userName!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
            accountEmail: userLoad == null
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/Login');
                    },
                    child: const Text(
                      "تسجيل الدخول / التسجيل ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                : Text(
                    userLoad!.email!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.green,
              child: userLoad == null
                  ? Icon(
                      Icons.perm_identity,
                      size: 40,
                    )
                  : Text(
                      userLoad!.userName!.substring(0, 1),
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
          new ListTile(
            title: const Text(
              "الرئيسية",
              style: TextStyle(fontSize: 16),
            ),
            leading: new Icon(
              Icons.home,
              size: 30,
              color: Colors.brown,
            ),
            onTap: () => Navigator.pushReplacementNamed(context, '/Home'),
          ),
          // new ListTile(
          //   title: const Text(
          //     "المفضلة",
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   leading: new Icon(
          //     Icons.favorite,
          //     size: 30,
          //     color: Colors.red,
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.pushNamed(context, '/Favourite');
          //   },
          // ),
//          new ListTile(
//            title: const Text(
//              "ملفى الشخصى",
//              style: TextStyle(fontSize: 16),
//            ),
//            leading: new Icon(
//              Icons.person,
//              size: 30,
//              color: Colors.orange,
//            ),
//            onTap: () async {
//              UserNav userLoad = await loadSharedPrefs();
//              Navigator.pop(context);
//              if (userLoad == null) {
//                _showErrorDialogLogin("الرجاء التسجيل قبل الدخول");
//              } else {
//                // Navigator.of(context).pop();
//                Navigator.pushNamed(context, '/UserProfile');
//              }
//            },
//          ),
          // new ListTile(
          //   title: const Text(
          //     "الإشعارات",
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          //   ),
          //   leading: Icon(Icons.notifications),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.pushNamed(context, '/Notifications');
          //   },
          // ),
          new ListTile(
            title: const Text(
              "تبرعاتي",
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold
              ),
            ),
            leading: new Icon(
              FontAwesomeIcons.handsHelping,
              size: 30,
              color: Colors.green,
            ),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return MyDonationsScreen();
              }));
            },
          ),
//          new ListTile(
//            title: const Text(
//              "التبرعات الخارجية",
//              style: TextStyle(fontSize: 16),
//            ),
//            leading: new Icon(
//              Icons.account_balance_wallet,
//              size: 30,
//              color: Colors.blue,
//            ),
//            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.pushNamed(context, '/ExternalDonation');
//            },
//          ),

          new ListTile(
            title: const Text(
              "الدعم و المساعدة",
              style: TextStyle(fontSize: 16),
            ),
            leading: new Icon(
              Icons.help,
              size: 30,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HelpScreen()));
            },
          ),
          Divider(),

          if (userLoad != null)
            new ListTile(
              title: const Text(
                "تسجيل خروج",
                style: TextStyle(fontSize: 16),
              ),
              leading: new Icon(
                Icons.exit_to_app,
                size: 30,
              ), // FontAwesomeIcons.signOutAlt
              onTap: () {
                _showErrorDialog("هل تريد تسجيل الخروج");
              },
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:shoryanelhayat_user/Animation/FadeAnimation.dart';
import 'package:shoryanelhayat_user/models/user_nav.dart';
import 'package:shoryanelhayat_user/notifiers/activity_notifier.dart';
import 'package:shoryanelhayat_user/providers/shard_pref.dart';
import 'package:shoryanelhayat_user/screens/normal_donation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityDetails extends StatefulWidget {
  @override
  _ActivityDetailsState createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  bool isFirstTime = true;
  String myTitle = "default title";
  ActivityNotifier? activityNotifier;

  bool more = true;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل دخول'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('ليس الأن'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('تسجيل الدخول'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushNamed(context, '/Login');
            },
          ),
        ],
      ),
    );
  }

  Future<UserNav> loadSharedPrefs() async {
    UserNav? user;
    try {
      SharedPref sharedPref = SharedPref();
      user = UserNav.fromJson(await sharedPref.read("user"));
    } catch (Excepetion) {
      // do something
    }
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
      isFirstTime = false;
    }
    return Scaffold(
      body: nested(),
    );
  }

  body() {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(20)),
                  color: Colors.green[700]!.withOpacity(0.75),
                ),
                child: Text(
                  ' الوصف',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Colors.grey[600]!,
                            blurRadius: 2.0,
                            offset: Offset(4, 2))
                      ]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FadeAnimation(
              1.7,
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    more == true &&
                            activityNotifier!
                                    .currentActivity.description.length >=
                                60
                        ? Flexible(
                            child: Text(
                              activityNotifier!.currentActivity.description,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            ),
                          )
                        : Flexible(
                            child: Text(
                              activityNotifier!.currentActivity.description,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            ),
                          ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          more = !more;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              more &&
                                      activityNotifier!.currentActivity
                                              .description.length >=
                                          60
                                  ? 'المزيد'
                                  : '',
                              style: textTheme.bodySmall!.copyWith(
                                  fontSize: 18.0,
                                  color: theme.colorScheme.secondary),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              more == false &&
                                      activityNotifier!.currentActivity
                                              .description.length >=
                                          60
                                  ? 'اقل'
                                  : '',
                              style: textTheme.bodySmall!.copyWith(
                                  fontSize: 18.0,
                                  color: theme.colorScheme.secondary),
                            ),
                          ),
                          Icon(
                            more &&
                                    activityNotifier!.currentActivity
                                            .description.length >=
                                        60
                                ? Icons.keyboard_arrow_down
                                : more == false &&
                                        activityNotifier!.currentActivity
                                                .description.length >=
                                            60
                                    ? Icons.keyboard_arrow_down
                                    : null,
                            size: 20.0,
                            color: theme.colorScheme.secondary,
                          ),
//                    Icon(
//                      Icons.keyboard_arrow_up
//                          :
//                      size: 20.0,
//                      color: theme.accentColor,
//                    ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
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
                  onTap: () async {
                    UserNav userLoad = await loadSharedPrefs();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return NormalDenotationScreen();
                        },
                      ),
                    );
                  }, // handle your onTap here
                  child: Center(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 2 / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green[800],
                      ),
                      child: Center(
                        child: Text(
                          "اطلب الآن",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }

  nested() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              backgroundColor: Colors.green,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 4 / 9,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.green.withOpacity(0.75),
                  ),
                  child: Text(
                    activityNotifier!.currentActivity.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                background: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              activityNotifier!.currentActivity.image,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    //    Positioned(
                    //   child:
                    //  ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: body(),
    );
  }
}

import 'package:market_app/models/activity.dart';
import 'package:market_app/models/user_nav.dart';
import 'package:market_app/notifiers/activity_notifier.dart';
import 'package:market_app/providers/shard_pref.dart';
import 'package:market_app/screens/activity_detail.dart';
import 'package:market_app/screens/normal_donation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class OrganizationActivity extends StatefulWidget {
  final id;

  OrganizationActivity(this.id);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<OrganizationActivity> {
  var _isLoading = false;
  var _isInit = true;
  List<Activity> _savedFav = [];
  final Set<String> _saved = Set<String>();

  var activityNotifier;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ActivityNotifier>(context,listen: false)
          .getActivites(widget.id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<ActivityNotifier>(context,listen: false)
          .fetchAndSetFavorites()
          .then((_) => {
                _savedFav = Provider.of<ActivityNotifier>(context,listen: false).favorites,
                if (_savedFav.length > 0)
                  {
                    _savedFav.forEach((element) {
                      _saved.add(element.name);
                    }),
                  }
              });

      activityNotifier = Provider.of<ActivityNotifier>(context,listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
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
            )
          : CupertinoAlertDialog(
              title: const Text('تسجيل دخول'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('ليس الأن'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('تسجيل الدخول'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.pushNamed(context, '/Login');
                  },
                )
              ],
            ),
    );
  }

  Future<UserNav?> loadSharedPrefs() async {
    UserNav? user;
    try {
      SharedPref sharedPref = SharedPref();
      user = UserNav.fromJson(await sharedPref.read("user"));
    } catch (Excepetion) {
      // do something
    }
    return user;
  }

//  @override
//  Widget build(BuildContext context) {
//    final _width = MediaQuery.of(context).size.width;
//    final _height = MediaQuery.of(context).size.height;
//
//    final body = new Scaffold(
//      appBar: new AppBar(
//        title: new Text(
//          'الانشطة',
//          style: new TextStyle(
//              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//        ),
//        centerTitle: true,
//        elevation: 0.0,
//        backgroundColor: Colors.green[900],
//        actions: <Widget>[],
//      ),
//      backgroundColor: Colors.white,
//      body: _isLoading
//          ? Center(
//              child: CircularProgressIndicator(),
//            )
//          : ListView.builder(
//              itemCount: activityNotifier.activityList.length,
//              itemBuilder: (context, index) {
//                return ClipRRect(
//                  borderRadius: BorderRadius.circular(20),
//                  child: Card(
//                    margin: EdgeInsets.all(10),
//                    color: Colors.green[400],
//                    child: new ListTile(
//                      contentPadding: EdgeInsets.all(8.0),
//                      title: new Column(
//                        children: <Widget>[
//                          new Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              new Container(
//                                height: 110.0,
//                                width: 110.0,
//                                decoration: new BoxDecoration(
//                                  shape: BoxShape.circle,
//                                  color: Colors.green[200],
//                                  boxShadow: [
//                                    new BoxShadow(
//                                        color: Colors.blueGrey.withAlpha(70),
//                                        offset: const Offset(2.0, 2.0),
//                                        blurRadius: 2.0)
//                                  ],
//                                  image: new DecorationImage(
//                                    image: activityNotifier.activityList[index]
//                                                    .image !=
//                                                null &&
//                                            activityNotifier.activityList[index]
//                                                    .image !=
//                                                ""
//                                        ? new NetworkImage(activityNotifier
//                                            .activityList[index].image)
//                                        : NetworkImage(
//                                            'https://img2.arabpng.com/20171128/5d2/gold-soccer-ball-png-clip-art-image-5a1d466b159ac0.0656563615118680110885.jpg'),
//                                    fit: BoxFit.cover,
//                                  ),
//                                ),
//                              ),
//                              new SizedBox(
//                                width: 15.0,
//                              ),
//                              new Column(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment:
//                                        MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Flexible(
//                                        child: new Text(
//                                          activityNotifier.activityList[index]
//                                                      .name !=
//                                                  null
//                                              ? activityNotifier
//                                                  .activityList[index].name
//                                              : 'no value',
//                                          style: new TextStyle(
//                                              fontSize: 19.0,
//                                              color: Colors.white,
//                                              fontWeight: FontWeight.bold),
//                                          overflow: TextOverflow.ellipsis,
//                                          maxLines: 1,
//                                        ),
//                                      ),
//                                      //  Expanded(
//                                      //      child: _buildRow(
//                                      //          activityNotifier
//                                      //                  .activityList[
//                                      //              index])),
//                                      _buildRow(
//                                          activityNotifier.activityList[index]),
//                                    ],
//                                  ),
//                                  Flexible(
//                                    child: new Text(
//                                      activityNotifier
//                                          .activityList[index].description,
//                                      overflow: TextOverflow.ellipsis,
//                                      maxLines: 1,
//                                      style: new TextStyle(
//                                          fontSize: 17.0,
//                                          // height: 0.5,
//                                          color: Colors.white,
//                                          fontWeight: FontWeight.normal),
//                                    ),
//                                  ),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      RaisedButton(
//                                        color: Colors.blue[200],
//                                        shape: RoundedRectangleBorder(
//                                          borderRadius:
//                                              new BorderRadius.circular(5.0),
//                                        ),
//                                        onPressed: () async {
//                                          activityNotifier.currentActivity =
//                                              activityNotifier
//                                                  .activityList[index];
//
//                                          UserNav userLoad =
//                                              await loadSharedPrefs();
//                                          if (userLoad == null) {
//                                            _showErrorDialog(
//                                                "برجاء تسجيل الدخول أولا ");
//                                          } else {
//                                            Navigator.of(context).push(
//                                              MaterialPageRoute(
//                                                builder:
//                                                    (BuildContext context) {
//                                                  return NormalDenotationScreen();
//                                                },
//                                              ),
//                                            );
//                                          }
//                                        },
//                                        child: Text(
//                                          'تبرع',
//                                          style: TextStyle(
//                                              fontSize: 20.0,
//                                              color: Colors.black),
//                                        ),
//                                      ),
//                                      SizedBox(
//                                        width: 10,
//                                      ),
//                                      RaisedButton(
//                                        color: Colors.blue[200],
//                                        shape: RoundedRectangleBorder(
//                                          borderRadius:
//                                              new BorderRadius.circular(5.0),
//                                        ),
//                                        onPressed: () async {
//                                          activityNotifier.currentActivity =
//                                              activityNotifier
//                                                  .activityList[index];
//                                          Navigator.of(context).push(
//                                              MaterialPageRoute(builder:
//                                                  (BuildContext context) {
//                                            return ActivityDetails();
//                                          }));
//                                        },
//                                        child: Text(
//                                          'تفاصيل ',
//                                          style: TextStyle(
//                                              fontSize: 20.0,
//                                              color: Colors.black),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                );
//              },
//            ),
//    );
//
//    return new Container(
//      decoration: new BoxDecoration(
//        color: const Color(0xFF273A48),
//      ),
//      child: new Stack(
//        children: <Widget>[
//          new CustomPaint(
//            size: new Size(_width, _height),
//          ),
//          body,
//        ],
//      ),
//    );
//  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final body = new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'المنتجات',
          style: new TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.green[900],
        actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new Container(
              child: new Stack(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: ListView.builder(
                            itemCount: activityNotifier.activityList.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Card(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.green[400],
                                  child: new ListTile(
                                    contentPadding: EdgeInsets.all(8.0),
                                    title: new Column(
                                      children: <Widget>[
                                        new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              height: 110.0,
                                              width: 110.0,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green[200],
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.blueGrey
                                                          .withAlpha(70),
                                                      offset: const Offset(
                                                          2.0, 2.0),
                                                      blurRadius: 2.0)
                                                ],
                                                image: new DecorationImage(
                                                  image: activityNotifier
                                                                  .activityList[
                                                                      index]
                                                                  .image !=
                                                              null &&
                                                          activityNotifier
                                                                  .activityList[
                                                                      index]
                                                                  .image !=
                                                              ""
                                                      ? new NetworkImage(
                                                          activityNotifier
                                                              .activityList[
                                                                  index]
                                                              .image)
                                                      : NetworkImage(
                                                          'https://img2.arabpng.com/20171128/5d2/gold-soccer-ball-png-clip-art-image-5a1d466b159ac0.0656563615118680110885.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            new SizedBox(
                                              width: 15.0,
                                            ),
                                            new Expanded(
                                              child: new Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: new Text(
                                                          activityNotifier
                                                                      .activityList[
                                                                          index]
                                                                      .name !=
                                                                  null
                                                              ? activityNotifier
                                                                  .activityList[
                                                                      index]
                                                                  .name
                                                              : 'no value',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: new TextStyle(
                                                              fontSize: 17.0,
                                                              // height: 0.5,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                      // _buildRow(activityNotifier
                                                      //     .activityList[index]),
                                                    ],
                                                  ),
                                                  new Text(
                                                    activityNotifier
                                                        .activityList[index]
                                                        .description,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: new TextStyle(
                                                        fontSize: 17.0,
                                                        // height: 0.5,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: Colors.blue[
                                                              200], // Background color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          activityNotifier
                                                                  .currentActivity =
                                                              activityNotifier
                                                                      .activityList[
                                                                  index];

                                                          UserNav? userLoad =
                                                              await loadSharedPrefs();
                                                          if (userLoad ==
                                                              null) {
                                                            _showErrorDialog(
                                                                "برجاء تسجيل الدخول أولا ");
                                                          } else {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return NormalDenotationScreen();
                                                                },
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          'اطلب',
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: Colors.blue[
                                                              200], // Background color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          activityNotifier
                                                                  .currentActivity =
                                                              activityNotifier
                                                                      .activityList[
                                                                  index];
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return ActivityDetails();
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          'تفاصيل ',
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );

    return new Container(
      decoration: new BoxDecoration(
        color: const Color(0xFF273A48),
      ),
      child: new Stack(
        children: <Widget>[
          new CustomPaint(
            size: new Size(_width, _height),
          ),
          body,
        ],
      ),
    );
  }

  Widget _buildRow(Activity activity) {
    bool alreadySaved;

    alreadySaved = _saved.contains(activity.name);

    return InkWell(
      child: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.pink : Colors.white,
        size: 32.0,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(activity.name);
            Provider.of<ActivityNotifier>(context,listen: false).deleteFavorite(activity);
          } else {
            _saved.add(activity.name);
            Provider.of<ActivityNotifier>(context,listen: false).addFavorite(activity.name,
                activity.description, activity.image, activity.id);
          }
        });
      },
    );

    // return ListTile(
    //   trailing: Icon(
    //     alreadySaved ? Icons.favorite : Icons.favorite_border,
    //     color: alreadySaved ? Colors.pink : Colors.white,
    //     size: 35.0,
    //   ),
    //   onTap: () {
    //     setState(() {
    //       if (alreadySaved) {
    //         _saved.remove(activity.name);
    //         Provider.of<ActivityNotifier>(context).deleteFavorite(activity);
    //       } else {
    //         _saved.add(activity.name);
    //         Provider.of<ActivityNotifier>(context).addFavorite(activity.name,
    //             activity.description, activity.image, activity.id);
    //       }
    //     });
    //   },
    // );
  }
}

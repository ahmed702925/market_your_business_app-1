import 'dart:async';
import 'dart:developer';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shoryanelhayat_user/Animation/FadeAnimation.dart';
import 'package:shoryanelhayat_user/models/user_nav.dart';
import 'package:shoryanelhayat_user/notifiers/campaign_notifier.dart';
import 'package:shoryanelhayat_user/notifiers/organization_notifier.dart';
import 'package:shoryanelhayat_user/providers/shard_pref.dart';
import 'package:shoryanelhayat_user/screens/campaign_details.dart';
import 'package:shoryanelhayat_user/screens/fast_donation.dart';
import 'package:shoryanelhayat_user/screens/navigation_drawer.dart';
import 'package:shoryanelhayat_user/screens/org_widgets/movie_details_page.dart';
import 'package:shoryanelhayat_user/screens/organization_activities.dart';
// import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:connectivity/connectivity.dart';
import '../background.dart';
import '../providers/auth.dart';

class OrgOverviewScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _OrgOverviewScreenState createState() => _OrgOverviewScreenState();
}

class _OrgOverviewScreenState extends State<OrgOverviewScreen> {
  StreamSubscription? connectivitySubscription;
  bool dialogShown = false;

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

  ////////////////////////////////////////////////////

  ////////////////////////////////////////////////////
  Future<UserNav> loadSharedPrefs() async {
    UserNav? user;
    try {
      SharedPref sharedPref = SharedPref();
      user = UserNav.fromJson(await sharedPref.read("user"));
    } catch (error) {
      // do something
    }
    return user!;
  }

  // Future<bool> checkinternet() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       return Future.value(true);
  //     }
  //   } on SocketException catch (_) {
  //     return Future.value(false);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // connectivitySubscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult connresult) {
    //   if (connresult == ConnectivityResult.none) {
    //     dialogShown = true;
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         child: (Platform.isAndroid)
    //             ? AlertDialog(
    //                 title: const Text('حدث خطأ ما '),
    //                 content: Text(
    //                     'فقدنا الاتصال بالانترنت  ،\n تأكد من اتصالك وحاول مرة أخرى'),
    //                 actions: <Widget>[
    //                   TextButton(
    //                       onPressed: () => {
    //                             SystemChannels.platform
    //                                 .invokeMethod('SystemNavigator.pop'),
    //                           },
    //                       child: Text(
    //                         'خروج ',
    //                         style: TextStyle(color: Colors.red),
    //                       )),
    //                   TextButton(
    //                       onPressed: () => {
    //                             AppSettings.openWIFISettings(),
    //                           },
    //                       child: Text(
    //                         ' اعدادت Wi-Fi ',
    //                         style: TextStyle(color: Colors.blue),
    //                       )),
    //                   TextButton(
    //                       onPressed: () => {
    //                             AppSettings.openDataRoamingSettings(),
    //                           },
    //                       child: Text(
    //                         ' اعدادت الباقه ',
    //                         style: TextStyle(
    //                           color: Colors.blue,
    //                         ),
    //                       ))
    //                 ],
    //               )
    //             : CupertinoAlertDialog(
    //                 title: const Text('حدث خطأ ما '),
    //                 content: Text(
    //                     'فقدنا الاتصال بالانترنت  ،\n تأكد من اتصالك وحاول مرة أخرى'),
    //                 actions: <Widget>[
    //                   CupertinoDialogAction(
    //                       onPressed: () => {
    //                             AppSettings.openWIFISettings(),
    //                           },
    //                       child: Text(
    //                         ' اعدادت Wi-Fi ',
    //                         style: TextStyle(color: Colors.blue),
    //                       )),
    //                   CupertinoDialogAction(
    //                       onPressed: () => {
    //                             AppSettings.openDataRoamingSettings(),
    //                           },
    //                       child: Text(
    //                         ' اعدادت الباقه ',
    //                         style: TextStyle(
    //                           color: Colors.blue,
    //                         ),
    //                       )),
    //                   CupertinoDialogAction(
    //                       onPressed: () => {
    //                             SystemChannels.platform
    //                                 .invokeMethod('SystemNavigator.pop'),
    //                           },
    //                       child: Text(
    //                         'خروج ',
    //                         style: TextStyle(color: Colors.red),
    //                       ))
    //                 ],
    //               ));
    //   } else if (_previousResult == ConnectivityResult.none) {
    //     checkinternet().then((result) {
    //       if (result == true) {
    //         if (dialogShown == true) {
    //           dialogShown = false;

    //           getOrganizationsAndCampaign();

    //           Navigator.pop(context);
    //         }
    //       }
    //     });
    //   }
    //   _previousResult = connresult;
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // connectivitySubscription.cancel();
  }

  var _isLoading = false;
  var _isInit = true;

  var campaignNotifier;
  var orgNotifier;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      campaignNotifier = Provider.of<CampaignNotifier>(context, listen: false);
      orgNotifier = Provider.of<OrganizationNotifier>(context, listen: false);

      getOrganizationsAndCampaign();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getOrganizationsAndCampaign() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<OrganizationNotifier>(context).getOrganizations();

    await Provider.of<CampaignNotifier>(context, listen: false)
        .fetchAndSetProducts();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("userId is :"+Provider.of<Auth>(context).userData.id);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final _width = MediaQuery.of(context).size.width;
    var appBar = AppBar(
      title: new Text(
        'شركة ISES للتوريدات الكهربية',
        style: new TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
    );

    final headerList = new ListView.builder(
      itemBuilder: (context, index) {
        EdgeInsets padding = index == 0
            ? const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 5.0, bottom: 5.0)
            : const EdgeInsets.only(
                left: 20.0, right: 10.0, top: 5.0, bottom: 5.0);

        return new Padding(
          padding: padding,
          child: new InkWell(
            onTap: () {
              campaignNotifier.currentCampaign =
                  campaignNotifier.campaignList[index];

              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return CampaignDetail();
              }));
            },
            child: FadeAnimation(
              1,
              Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.green[100],
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.blueGrey.withAlpha(100),
                        offset: const Offset(3.0, 10.0),
                        blurRadius: 10.0)
                  ],
                  image: new DecorationImage(
                    image: new NetworkImage(
                        campaignNotifier.campaignList[index].imagesUrl),
                    fit: BoxFit.fill,
                  ),
                ),
                width: 150.0,
                child: new Stack(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.bottomCenter,
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                bottomLeft: new Radius.circular(10.0),
                                bottomRight: new Radius.circular(10.0))),
                        height: 35.0,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: new Container(
                                child: new Text(
                                  campaignNotifier
                                      .campaignList[index].campaignName,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: campaignNotifier.campaignList.length,
    );
    final bodyLandscape = new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'شركة ISES للتوريدات الكهربية',
          style: new TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      drawer: CustomNavigationDrawer(),
      backgroundColor: Colors.green[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 4 / 2,
                      child: new Container(
                        // height:(_height/3)<150?160: _height/3,
                        child: FlutterCarousel(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 3000),
                            // curve: Curves.fastLinearToSlowEaseIn,
                            enlargeCenterPage: true,
                            // dotSize: 4.0,
                            // dotSpacing: 15.0,
                            // dotIncreasedColor: Colors.blue,
                            // dotBgColor: Colors.transparent,
                            // indicatorBgPadding: 2.0,
                            viewportFraction: 0.9,
                          ),
                          items: [
                            Image.asset('assets/offers/ises.jpg',
                                fit: BoxFit.cover),
                            Image.asset('assets/offers/ups.jpg',
                                fit: BoxFit.cover),
                            Image.asset('assets/offers/inverter.jpg',
                                fit: BoxFit.cover),
                            Image.asset('assets/offers/battery.jpg',
                                fit: BoxFit.cover),
                            // Image.asset('assets/offers/Offer5.jpg',
                            //     fit: BoxFit.cover),
                          ],
                        ),
                      ),
                    ),
                    campaignNotifier.campaignList.length != 0
                        ? new Container(
                            height: 150.0, width: _width, child: headerList)
                        : Container(child: Text("لا يوجد حملات حايا")),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width - 50,
                      height: 50.0,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                textStyle: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //       return FastDonationScreen();
                                //     },
                                //   ),
                                // );
                              },
                              child: Text(
                                'اطلب الآن',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(height: 200,margin: EdgeInsets.only(bottom: 20),),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orgNotifier.orgList.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: new BorderRadius.circular(20),
                          child: Card(
                            margin: EdgeInsets.fromLTRB(10, 5, 40, 5),
//                            color: Colors.purple[200],
                            child: new ListTile(
                              contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                              title: new Column(
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FadeAnimation(
                                        2,
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.green[300],
                                              boxShadow: [
                                                new BoxShadow(
                                                    color: Colors.blueGrey
                                                        .withAlpha(70),
                                                    offset:
                                                        const Offset(2.0, 2.0),
                                                    blurRadius: 2.0)
                                              ],
                                              image: new DecorationImage(
                                                image: orgNotifier
                                                                .orgList[index]
                                                                .logo !=
                                                            null &&
                                                        orgNotifier
                                                                .orgList[index]
                                                                .logo !=
                                                            ""
                                                    ? new NetworkImage(
                                                        orgNotifier
                                                            .orgList[index]
                                                            .logo)
                                                    : NetworkImage(
                                                        'https://img2.arabpng.com/20171128/5d2/gold-soccer-ball-png-clip-art-image-5a1d466b159ac0.0656563615118680110885.jpg'),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      new Expanded(
                                          child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          FadeAnimation(
                                            1.3,
                                            Text(
                                              orgNotifier.orgList[index]
                                                          .orgName !=
                                                      null
                                                  ? orgNotifier
                                                      .orgList[index].orgName
                                                  : 'no value',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          FadeAnimation(
                                            1.3,
                                            Text(
                                              orgNotifier
                                                  .orgList[index].description,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.green,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 10.0,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .white, // Background color
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                  ),
                                                  textStyle: TextStyle(
                                                    color: Colors.green[
                                                        900], // Text color
                                                  ),
                                                ),
                                                onPressed: () {
                                                  orgNotifier
                                                          .currentOrganization =
                                                      orgNotifier
                                                          .orgList[index];

                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          MovieDetailsPage(
                                                              orgNotifier
                                                                      .orgList[
                                                                  index]),
                                                      transitionsBuilder: (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) =>
                                                          FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child),
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  500),
                                                    ),
                                                  );
                                                },
                                                child: Text('تفاصيل',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    )),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .white, // Background color
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                  ),
                                                  textStyle: TextStyle(
                                                    color: Colors.green[
                                                        900], // Text color
                                                  ),
                                                ),
                                                onPressed: () {
                                                  orgNotifier
                                                          .currentOrganization =
                                                      orgNotifier
                                                          .orgList[index];

                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          OrganizationActivity(
                                                              orgNotifier
                                                                  .orgList[
                                                                      index]
                                                                  .id),
                                                      transitionsBuilder:
                                                          (context,
                                                                  animation1,
                                                                  animation2,
                                                                  child) =>
                                                              FadeTransition(
                                                                  opacity:
                                                                      animation1,
                                                                  child: child),
                                                      transitionDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  500),
                                                    ),
                                                  );
                                                },
                                                child: Text("منتجاتنا"),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
    final bodyPortrait = new Scaffold(
      appBar: appBar,
      drawer: CustomNavigationDrawer(),
      backgroundColor: Colors.green[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//                  Container(
//                    width: _width,
//                    height: (MediaQuery.of(context).size.height -
//                        appBar.preferredSize.height -
//                        MediaQuery.of(context).padding.top),

                Container(
                  width: _width,
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.35,
                  child: AspectRatio(
                    aspectRatio: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.004,
                    child: new Container(
                      // height:(_height/3)<150?160: _height/3,
                      child: Container(
//                        width: MediaQuery.of(context).size.width / 2,
//                        height:
                        child: FlutterCarousel(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 3000),
                            // curve: Curves.fastLinearToSlowEaseIn,
                            enlargeCenterPage: true,
                            // dotSize: 4.0,
                            // dotSpacing: 15.0,
                            // dotIncreasedColor: Colors.blue,
                            // dotBgColor: Colors.transparent,
                            // indicatorBgPadding: 2.0,
                            viewportFraction: 0.9,
                          ),
                          items: [
                            Image.asset('assets/offers/ises.jpg',
                                fit: BoxFit.cover),
                            Image.asset('assets/offers/ups.jpg',
                                fit: BoxFit.cover),
                            Image.asset('assets/offers/inverter.jpg',
                                fit: BoxFit.cover),
                            Image.asset('assets/offers/battery.jpg',
                                fit: BoxFit.cover),
                          ],
                        ),
//                         new Carousel(
// //                          boxFit: BoxFit.cover,
//                           images: [
//                             AssetImage('assets/offers/sh2.png'),
//                             AssetImage('assets/offers/Offer2.jpg'),
//                             AssetImage('assets/offers/offer6.jpg'),
//                             AssetImage('assets/offers/offer7.jpg'),
//                           ],
//                           autoplay: true,
//                           animationCurve: Curves.fastLinearToSlowEaseIn,
//                           animationDuration: Duration(milliseconds: 5000),
//                           dotSize: 4.0,
//                           indicatorBgPadding: 2.0,
//                         ),
                      ),
                    ),
                  ),
                ),
                campaignNotifier.campaignList.length != 0
                    ? new Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.22,
                        width: _width,
                        child: headerList)
                    : Container(child: Text("لا يوجد حملات حايا")),
//                 ButtonTheme(
//                   minWidth: MediaQuery.of(context).size.width - 50,
//                   height: (MediaQuery.of(context).size.height -
//                           appBar.preferredSize.height -
//                           MediaQuery.of(context).padding.top) *
//                       0.02,
//                   child: Expanded(
//                     child: Container(
// //                    padding: EdgeInsets.only(bottom: 5),
//                       margin: EdgeInsets.only(bottom: 5),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue, // Background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                     24.0), // Border radius
//                               ),
//                               textStyle: TextStyle(
//                                 fontSize: 22.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white, // Text color
//                               ),
//                             ),
//                             onPressed: () async {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (BuildContext context) {
//                                     return FastDonationScreen();
//                                   },
//                                 ),
//                               );
//                             },
//                             child: Text('اطلب الآن'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orgNotifier.orgList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: _width * 0.98,
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.32,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: _width * 0.01,
                          ),
                          Container(
                            width: _width * 0.98,
                            height: (MediaQuery.of(context).size.height -
                                    appBar.preferredSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.32,
                            child: ClipRRect(
                              borderRadius: new BorderRadius.circular(20),
                              child: Card(
//                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                            color: Colors.purple[200],
                                child: new ListTile(
//                              contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                  title: new Column(
                                    children: <Widget>[
                                      new Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          FadeAnimation(
                                            2,
                                            Container(
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      appBar.preferredSize
                                                          .height -
                                                      MediaQuery.of(context)
                                                          .padding
                                                          .top) *
                                                  0.27,
                                              width: _width * .38,
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.blueGrey
                                                          .withAlpha(70),
                                                      offset: const Offset(
                                                          2.0, 2.0),
                                                      blurRadius: 2.0)
                                                ],
                                                image: DecorationImage(
                                                  image: orgNotifier
                                                                  .orgList[
                                                                      index]
                                                                  .logo !=
                                                              null &&
                                                          orgNotifier
                                                                  .orgList[
                                                                      index]
                                                                  .logo !=
                                                              ""
                                                      ? NetworkImage(orgNotifier
                                                              .orgList[index]
                                                              .logo)
                                                          as ImageProvider
                                                      : Container()
                                                          as ImageProvider,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          new SizedBox(
                                            height: (MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    appBar
                                                        .preferredSize.height -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top) *
                                                0.3,
                                            width: _width / 30,
                                          ),
                                          new Expanded(
                                            child: new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  height: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height -
                                                          appBar.preferredSize
                                                              .height -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .top) *
                                                      0.06,
                                                  width: _width * .58,
                                                  child: FadeAnimation(
                                                    1.3,
                                                    Text(
                                                      orgNotifier.orgList[index]
                                                                  .orgName !=
                                                              null
                                                          ? orgNotifier
                                                              .orgList[index]
                                                              .orgName
                                                          : 'no value',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: new TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                new SizedBox(
                                                  height: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height -
                                                          appBar.preferredSize
                                                              .height -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .top) *
                                                      0.01,
//                                          width: _width / 30,
                                                ),
                                                Container(
                                                  child: Container(
                                                    height: (MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height -
                                                            appBar.preferredSize
                                                                .height -
                                                            MediaQuery.of(
                                                                    context)
                                                                .padding
                                                                .top) *
                                                        0.05,
                                                    width: _width * .58,
                                                    child: FadeAnimation(
                                                      1.3,
                                                      Text(
                                                        orgNotifier
                                                            .orgList[index]
                                                            .description,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: new TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                new SizedBox(
                                                  height: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height -
                                                          appBar.preferredSize
                                                              .height -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .top) *
                                                      0.02,
//                                          width: _width / 30,
                                                ),
                                                Container(
                                                  height: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height -
                                                          appBar.preferredSize
                                                              .height -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .top) *
                                                      0.06,
                                                  width: _width * .58,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
//                                            spacing: _width / 11,
//                                            crossAxisAlignment:
//                                                WrapCrossAlignment.center,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white, // Background color
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24.0),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                orgNotifier
                                                                        .currentOrganization =
                                                                    orgNotifier
                                                                            .orgList[
                                                                        index];

                                                                Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    pageBuilder: (context,
                                                                            animation1,
                                                                            animation2) =>
                                                                        MovieDetailsPage(
                                                                      orgNotifier
                                                                              .orgList[
                                                                          index],
                                                                    ),
                                                                    transitionsBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation,
                                                                            child) =>
                                                                        FadeTransition(
                                                                            opacity:
                                                                                animation,
                                                                            child:
                                                                                child),
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                500),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                'تفاصيل',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 9.0,
                                                                  color: Colors
                                                                          .green[
                                                                      900],
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor: Colors
                                                                .white, // Background color
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            orgNotifier
                                                                    .currentOrganization =
                                                                orgNotifier
                                                                        .orgList[
                                                                    index];
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                    animation1,
                                                                    animation2) {
                                                                  return OrganizationActivity(
                                                                      orgNotifier
                                                                          .orgList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                transitionsBuilder:
                                                                    (context,
                                                                        animation1,
                                                                        animation2,
                                                                        child) {
                                                                  return FadeTransition(
                                                                    opacity:
                                                                        animation1,
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                                transitionDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            500),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            'منتجاتنا',
                                                            style: TextStyle(
                                                              fontSize: 9.0,
                                                              color: Colors
                                                                  .green[900],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.01,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.01,
                ),
              ],
            ),
    );

    return new Container(
      width: _width,
//      height: _height,
      height: (MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: new Stack(
        children: <Widget>[
          new CustomPaint(
//            size: new Size(_width / 2, _height / 4),
            painter: new Background(),
          ),
          if (isLandscape) bodyLandscape else bodyPortrait,
        ],
      ),
    );
  }
}

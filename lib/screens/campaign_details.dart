import 'package:shoryanelhayat_user/models/user_nav.dart';
import 'package:shoryanelhayat_user/notifiers/campaign_notifier.dart';
import 'package:shoryanelhayat_user/providers/shard_pref.dart';
import 'package:shoryanelhayat_user/screens/PreviousCampaignsDetails.dart';
import 'package:shoryanelhayat_user/screens/campaigns_donation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class CampaignDetail extends StatefulWidget {
  @override
  _CampaignDetailState createState() => _CampaignDetailState();
}

class _CampaignDetailState extends State<CampaignDetail> {
  bool isFirstTime = true;
  var more = true;

  CampaignNotifier campaignNotifier;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
              title: const Text('تسجيل دخول'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: const Text('ليس الآن'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
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
                  child: const Text("تسجيل الدخول"),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(ctx).pop();

                    Navigator.pushNamed(context, '/Login');
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('ليس الآن'),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ),
    );
  }

  Future<UserNav> loadSharedPrefs() async {
    UserNav user;
    try {
      SharedPref sharedPref = SharedPref();
      user = UserNav.fromJson(await sharedPref.read("user"));
    } catch (Excepetion) {
      // do something
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    if (isFirstTime) {
      campaignNotifier = Provider.of<CampaignNotifier>(context, listen: false);
      isFirstTime = false;
    }
    var appBar = AppBar(
      title: Text(campaignNotifier.currentCampaign.campaignName),
      backgroundColor: Colors.green,
    );
    return Scaffold(
      appBar: appBar,
      body:

          //   child: Column(
          Card(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
        elevation: 8, shadowColor: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),

        // child: Column(
        //  children: <Widget>[
//            Expanded(
//                child:
//                    Image.network(campaignNotifier.currentCampaign.imagesUrl)),
        //   Expanded(

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              Expanded(
//                child: Container(
//                  decoration: BoxDecoration(
//                    image: DecorationImage(
//                      image: NetworkImage(
//                        campaignNotifier.currentCampaign.imagesUrl,
//                      ),
//                      fit: BoxFit.fill,
//                    ),
//                  ),
//                ),
//              ),
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.5,
                  child: Image.network(
                      campaignNotifier.currentCampaign.imagesUrl)),

              Flexible(
                child: Text(campaignNotifier.currentCampaign.campaignName,
                    style:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              ),

              SizedBox(height: 2),
              more == true &&
                      campaignNotifier
                              .currentCampaign.campaignDescription.length >=
                          60
                  ? Flexible(
                      child: Text(
                        campaignNotifier.currentCampaign.campaignDescription,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      ),
                    )
                  : Flexible(
                      child: Text(
                        campaignNotifier.currentCampaign.campaignDescription,
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
                    Text(
                      more &&
                              campaignNotifier.currentCampaign
                                      .campaignDescription.length >=
                                  60
                          ? 'المزيد'
                          : '',
                      style: textTheme.body1
                          .copyWith(fontSize: 18.0, color: theme.accentColor),
                    ),
                    Text(
                      more == false &&
                              campaignNotifier.currentCampaign
                                      .campaignDescription.length >=
                                  60
                          ? 'اقل'
                          : '',
                      style: textTheme.body1
                          .copyWith(fontSize: 18.0, color: theme.accentColor),
                    ),
                    Icon(
                      more &&
                              campaignNotifier.currentCampaign
                                      .campaignDescription.length >=
                                  60
                          ? Icons.keyboard_arrow_down
                          : more == false &&
                                  campaignNotifier.currentCampaign
                                          .campaignDescription.length >=
                                      60
                              ? Icons.keyboard_arrow_down
                              : null,
                      size: 20.0,
                      color: theme.accentColor,
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
              RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                child: Text(
                  'صور لحملات سابقة',
                  style: TextStyle(fontSize: 21.0, color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                onPressed: () {
                  print(campaignNotifier.currentCampaign.id);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return PreviousCampaignsDetails();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              RaisedButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                onPressed: () async {
                  UserNav userLoad = await loadSharedPrefs();
                  if (userLoad == null) {
                    print("user is not here");
                    _showErrorDialog("برجاء تسجيل الدخول أولا");
                  } else {
                    print("user is  here");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CampaignDenotationScreen();
                    }));
                  }
                },
                child: Text(
                  'تبرع الآن',
                  style: TextStyle(fontSize: 21.0, color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              ),
              SizedBox(height: 10),

//                      Row(
//
//                        children: <Widget>[
//                          Spacer(),
//                          //Spacer(),
//                          Transform.translate(
//                            offset: Offset(120 , -15),
//                            child:           RaisedButton(
//                              color: Colors.green,
//                              shape: RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(5.0),
//
//                              ),
//                              onPressed: () async {
//                                UserNav userLoad = await loadSharedPrefs();
//                                if (userLoad == null) {
//                                  print("user is not here");
//                                  _showErrorDialog("برجاء تسجيل الدخول أولا");
//                                } else {
//                                  print("user is  here");
//                                  Navigator.of(context).push(
//                                      MaterialPageRoute(builder: (BuildContext context) {
//                                        return CampaignDenotationScreen();
//                                      }));
//                                }
//                              },
//                              child: Text(
//                                'تبرع الآن',
//                                style: TextStyle(fontSize: 21.0, color: Colors.white),
//                              ),
//                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
//                            ),
//                          ),
//                          SizedBox(width: 16),
//                        ],
//                      )
            ],
          ),
        ),
      ),
    );
    //);
    //      ], )
    //  ),
    //),

    //),
    // ),
    //  );
  }
}

//import 'package:flutter/material.dart';
//
//import 'PreviousCampaignsDetails.dart';
//
//class PreviousCampaigns extends StatefulWidget {
//  @override
//  _PreviousCampaignsState createState() => _PreviousCampaignsState();
//}
//
//class _PreviousCampaignsState extends State<PreviousCampaigns> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: new AppBar(
//        title: new Text(
//          'الحملات السابقة',
//          style: new TextStyle(
//              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//        ),
//        centerTitle: true,
//        elevation: 0.0,
//        backgroundColor: Colors.green[900],
//        actions: <Widget>[],
//      ),
//      backgroundColor: Colors.white,
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          RaisedButton(
//            color: Colors.green,
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(5.0),
//            ),
//            child: Text('حملة رمضان الخير 2020'),
//            onPressed: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (BuildContext context) {
//                    return PreviousCampaignsDetails();
//                  },
//                ),
//              );
//            },
//          ),
//          RaisedButton(
//            color: Colors.green,
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(5.0),
//            ),
//            child: Text('صور لحملات سابقة'),
//            onPressed: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (BuildContext context) {
//                    return PreviousCampaigns();
//                  },
//                ),
//              );
//            },
//          ),
//          RaisedButton(
//            color: Colors.green,
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(5.0),
//            ),
//            child: Text('صور لحملات سابقة'),
//            onPressed: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (BuildContext context) {
//                    return PreviousCampaigns();
//                  },
//                ),
//              );
//            },
//          ),
//          RaisedButton(
//            color: Colors.green,
//            shape: RoundedRectangleBorder(
//              borderRadius: new BorderRadius.circular(5.0),
//            ),
//            child: Text('صور لحملات سابقة'),
//            onPressed: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (BuildContext context) {
//                    return PreviousCampaigns();
//                  },
//                ),
//              );
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}

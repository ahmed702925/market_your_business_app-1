import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoryanelhayat_user/notifiers/campaign_notifier.dart';
//import 'package:shoryanelhayat_user/Animation/FadeAnimation.dart';

class PreviousCampaignsDetails extends StatefulWidget {
  @override
  _PreviousCampaignsDetailsState createState() =>
      _PreviousCampaignsDetailsState();
}

class _PreviousCampaignsDetailsState extends State<PreviousCampaignsDetails> {
  var _isInit = true;
  var _isLoading = false;
  var prevCampaignNotifier;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      prevCampaignNotifier =
          Provider.of<CampaignNotifier>(context, listen: false);
//      orgNotifier = Provider.of<OrganizationNotifier>(context, listen: false);

      getPrevCampaigns();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getPrevCampaigns() async {
    setState(() {
      _isLoading = true;
    });

//    await Provider.of<OrganizationNotifier>(context).getOrganizations();

    await Provider.of<CampaignNotifier>(context).fetchPreviousCampaigns();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: new Text(
        'صور لبعض الحملات السابقة',
        style: new TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
    );
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Container(
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
                          prevCampaignNotifier.prevCampaignList[index].url),
                      fit: BoxFit.fill,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      (0.5),
                );
              },
              itemCount: prevCampaignNotifier.prevCampaignList.length,
            ),
    );
  }
}

//  Container(
//  color: Colors.green[100],
//  child: SizedBox(
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.005),
//  ),
//  ),
//  Container(
//  decoration: new BoxDecoration(
//  borderRadius: new BorderRadius.circular(10.0),
//  color: Colors.green[100],
//  boxShadow: [
//  new BoxShadow(
//  color: Colors.blueGrey.withAlpha(100),
//  offset: const Offset(3.0, 10.0),
//  blurRadius: 10.0)
//  ],
//  image: new DecorationImage(
//  image: new NetworkImage(
//  prevCampaignNotifier.prevCampaignList[1].url),
//  fit: BoxFit.fill,
//  ),
//  ),
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.33),
//  ),
//  Container(
//  color: Colors.green[100],
//  child: SizedBox(
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.005),
//  ),
//  ),
//  Container(
//  decoration: new BoxDecoration(
//  borderRadius: new BorderRadius.circular(10.0),
//  color: Colors.green[100],
//  boxShadow: [
//  new BoxShadow(
//  color: Colors.blueGrey.withAlpha(100),
//  offset: const Offset(3.0, 10.0),
//  blurRadius: 10.0)
//  ],
//  image: new DecorationImage(
//  image: new NetworkImage(
//  prevCampaignNotifier.prevCampaignList[2].url),
//  fit: BoxFit.fill,
//  ),
//  ),
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.33),
//  ),
//  Container(
//  color: Colors.green[100],
//  child: SizedBox(
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.005),
//  ),
//  ),
//  Container(
//  decoration: new BoxDecoration(
//  borderRadius: new BorderRadius.circular(10.0),
//  color: Colors.green[100],
//  boxShadow: [
//  new BoxShadow(
//  color: Colors.blueGrey.withAlpha(100),
//  offset: const Offset(3.0, 10.0),
//  blurRadius: 10.0)
//  ],
//  image: new DecorationImage(
//  image: new NetworkImage(
//  prevCampaignNotifier.prevCampaignList[3].url),
//  fit: BoxFit.fill,
//  ),
//  ),
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.33),
//  ),
//  Container(
//  color: Colors.green[100],
//  child: SizedBox(
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.005),
//  ),
//  ),
//  Container(
//  decoration: new BoxDecoration(
//  borderRadius: new BorderRadius.circular(10.0),
//  color: Colors.green[100],
//  boxShadow: [
//  new BoxShadow(
//  color: Colors.blueGrey.withAlpha(100),
//  offset: const Offset(3.0, 10.0),
//  blurRadius: 10.0)
//  ],
//  image: new DecorationImage(
//  image:
//  new NetworkImage("https://i.imgur.com/5xFZM4o.jpg"),
//  fit: BoxFit.fill,
//  ),
//  ),
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.33),
//  ),
//  Container(
//  color: Colors.green[100],
//  child: SizedBox(
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.005),
//  ),
//  ),
//  Container(
//  decoration: new BoxDecoration(
//  borderRadius: new BorderRadius.circular(10.0),
//  color: Colors.green[100],
//  boxShadow: [
//  new BoxShadow(
//  color: Colors.blueGrey.withAlpha(100),
//  offset: const Offset(3.0, 10.0),
//  blurRadius: 10.0)
//  ],
//  image: new DecorationImage(
//  image:
//  new NetworkImage("https://i.imgur.com/5xFZM4o.jpg"),
//  fit: BoxFit.fill,
//  ),
//  ),
//  width: MediaQuery.of(context).size.width,
//  height: (MediaQuery.of(context).size.height -
//  appBar.preferredSize.height -
//  MediaQuery.of(context).padding.top) *
//  (0.33),
//  ),
//  ],

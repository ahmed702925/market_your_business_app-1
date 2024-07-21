import 'package:shoryanelhayat_user/notifiers/organization_notifier.dart';

import 'package:shoryanelhayat_user/screens/email_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailOrganization extends StatefulWidget {
  static const routeName = '/emailOrg';

  @override
  _EmailOrganizationState createState() => _EmailOrganizationState();
}

class _EmailOrganizationState extends State<EmailOrganization> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<OrganizationNotifier>(context)
          .getOrganizations()
          .then((_) => {
                setState(() {
                  _isLoading = false;
                }),
              });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final allOrg = Provider.of<OrganizationNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدعم بواسطة البريد الإلكتروني'),
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: Stack(
          children: <Widget>[
            Container(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(15.0),
                      itemBuilder: (context, index) => buildItem(
                          context,
                          allOrg.orgList[index].orgName,
                          allOrg.orgList[index].email,
                          allOrg.orgList[index].logo),
                      itemCount: allOrg.orgList.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      BuildContext context, String orgName, String email, String img) {
    if (orgName == null) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                child: Material(
                  child: Image.network(img),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  clipBehavior: Clip.hardEdge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          orgName,
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmailScreen(email)));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: const EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

import 'package:shoryanelhayat_user/notifiers/organization_notifier.dart';
import 'package:shoryanelhayat_user/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpOrganization extends StatefulWidget {
  static const routeName = '/helpOrg';
  @override
  _HelpOrganizationState createState() => _HelpOrganizationState();
}

class _HelpOrganizationState extends State<HelpOrganization> {
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
    final allUsers = Provider.of<OrganizationNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
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
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => buildItem(
                          context,
                          allUsers.orgList[index].orgName,
                          allUsers.orgList[index].id,
                          allUsers.orgList[index].logo),
                      itemCount: allUsers.orgList.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      BuildContext context, String orgName, String orgId, String img) {
    return Container(
      child: TextButton(
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(orgId: orgId)));
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}

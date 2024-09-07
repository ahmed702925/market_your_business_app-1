import 'dart:convert';

import 'package:market_app/models/activity.dart';
import 'package:market_app/models/organization.dart';
import 'package:flutter/material.dart';

import 'package:market_app/screens/org_widgets/story_line.dart';
import 'package:market_app/screens/org_widgets/actor_scroller.dart';

import 'package:market_app/screens/org_widgets/movie_detail_header.dart';

import 'package:http/http.dart' as http;

class MovieDetailsPage extends StatefulWidget {
  MovieDetailsPage(this.currentOrg);
  final Organization currentOrg;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  List<Activity> _activitesList = [];

  @override
  void initState() {
    super.initState();
    this.getActivites(widget.currentOrg.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //  title: const Text('تبرعاتي'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MovieDetailHeader(widget.currentOrg),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Storyline(widget.currentOrg),
            ),
            // PhotoScroller(movie.photoUrls),
            // SizedBox(height: 20.0),

            ActorScroller(_activitesList),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Future<void> getActivites(String orgId) async {
    // _loading = true;

    _activitesList = [];
    // selectedActivity = null;
    final url =
        'https://dailykoot-default-rtdb.firebaseio.com/activities/$orgId.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Activity> loadedOrganizations = [];
      extractedData.forEach((prodId, prodData) {
//        if(selectedOraginzaton.id==prodData['org_id'])
//        if(  _orgList[selectedOraginzaton].id==prodData['org_id'])
//        {
        loadedOrganizations.add(Activity(
            id: prodId,
//            orgId: prodData['org_id'],
            name: prodData['name'],
            image: prodData['image'],
            description: prodData['description']));
//        }
      });

      // _loading = false;
      setState(() {
        _activitesList = loadedOrganizations;
      });
      // notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}

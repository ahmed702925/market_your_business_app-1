import 'package:shoryanelhayat_user/models/activity.dart';
import 'package:shoryanelhayat_user/notifiers/activity_notifier.dart';
import 'package:shoryanelhayat_user/screens/activity_detail.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ActorScroller extends StatelessWidget {
  ActorScroller(this.actors);
  final List<Activity> actors;

  ActivityNotifier? activityNotifier;

  Widget _buildActor(BuildContext ctx, int index) {
    var actor = actors[index];

    return InkWell(
      onTap: () {
        activityNotifier!.currentActivity = actor;
        Navigator.of(ctx).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ActivityDetails();
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(actor.image),
              radius: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(actor.name),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    activityNotifier = Provider.of<ActivityNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'الأنشطة',
            style: textTheme.titleMedium!.copyWith(fontSize: 18.0),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: actors.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildActor,
          ),
        ),
      ],
    );
  }
}

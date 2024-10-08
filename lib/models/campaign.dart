import 'package:flutter/foundation.dart';

class Campaign with ChangeNotifier {
  final String id;
  final String campaignName;
  final String campaignDescription;
  final String orgName;
  final String orgId;
  final String imagesUrl;
  final String time;

  Campaign({
    required this.id,
    required this.campaignName,
    required this.campaignDescription,
    required this.orgId,
    required this.orgName,
    required this.imagesUrl,
    required this.time,
  });
}
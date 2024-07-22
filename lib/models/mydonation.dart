import 'package:flutter/foundation.dart';

class MyDonation with ChangeNotifier {
  final String? id;
  final String donationType;
  final String donationItems;
  final String donationAmount;
  final String donationDate;
  final String image;
  final String orgName;
  final String actName;
  final String status;
  final String userId;
  final String donatorAddress;
  final String donatorMobileNo;
  final String availableOn;
  final String donatorName;

  MyDonation({
    required this.id,
    required this.donatorName,
    required this.availableOn,
    required this.donationType,
    required this.donationItems,
    required this.donationAmount,
    required this.donationDate,
    required this.image,
    required this.orgName,
    required this.actName,
    required this.status,
    required this.userId,
    required this.donatorMobileNo,
    required this.donatorAddress,
  });
}

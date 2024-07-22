import 'package:flutter/foundation.dart';

class Organization with ChangeNotifier {
  final String id;
  final String orgName;
  final String logo;
  final String address;
  final String description;
  final String licenseNo;
  final String landLineNo;
  final String mobileNo;
  final String bankAccounts;
  final String webPage;
  final String? email;
  final String? orgLocalId;

  Organization(
      {required this.id,
       this.orgLocalId,
      required this.orgName,
      required this.logo,
      required this.address,
      required this.description,
      required this.licenseNo,
       this.email,
      required this.landLineNo,
      required this.mobileNo,
      required this.bankAccounts,
      required this.webPage});
}
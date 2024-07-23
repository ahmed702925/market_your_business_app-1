import 'dart:convert';
import 'dart:developer';
import 'package:shoryanelhayat_user/models/organization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrganizationNotifier with ChangeNotifier {
  List<Organization> _orgList = [];

  Organization? _currentOrg;

  Organization get currentOrg => _currentOrg!;

  set currentOrganization(Organization organization) {
    _currentOrg = organization;
    notifyListeners();
  }

  List<Organization> get orgList {
    return [..._orgList];
  }

  Future<void> getOrganizations() async {
    log('get orgs called');
    final url =
        'https://marketbusinessapp-8a624-default-rtdb.firebaseio.com/CharitableOrganizations.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Organization> loadedOrganizations = [];
      extractedData.forEach((prodId, prodData) {
        loadedOrganizations.add(
          Organization(
          id: prodId,
          orgName: prodData['orgName'],
          address: prodData['address'],
          logo: prodData['logo'],
          email: prodData['email'],
          description: prodData['description'],
          landLineNo: prodData['landLineNo'],
          licenseNo: prodData['licenseNo'],
          mobileNo: prodData['mobileNo'],
          bankAccounts: prodData['bankAccounts'],
          webPage: prodData['webPage'],
        ));
      });

      _orgList = loadedOrganizations;
      log(loadedOrganizations.toString());
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}

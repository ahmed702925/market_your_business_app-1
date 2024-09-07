import 'dart:io';
import 'package:market_app/models/mydonation.dart';
import 'package:market_app/models/organization.dart';
import 'package:market_app/models/user_nav.dart';
import 'package:market_app/providers/shard_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyDonationsProvider with ChangeNotifier {
  UserNav? userLoad;
  List<Organization> _orgList = [];
  List<MyDonation> _items = [];

  List<MyDonation> get items {
    return [..._items];
  }

  MyDonation findById(String id) {
    return _items.firstWhere((donation) => donation.id == id);
  }

  loadSharedPrefs() async {
    try {
      SharedPref sharedPref = SharedPref();
      UserNav user = UserNav.fromJson(await sharedPref.read("user"));
      userLoad = user;
    } catch (error) {
      // do something
    }
  }

  Future<void> fetchAndSetDonations(String userId) async {
    await loadSharedPrefs();
    userId = userLoad!.id!;
    final url =
        'https://dailykoot-default-rtdb.firebaseio.com/MyDonations/$userId.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<MyDonation> loadedDonations = [];
      extractedData.forEach((donationId, donationData) {
        print(donationData['donatorName']);
        loadedDonations.add(MyDonation(
          id: donationId,
          orgName: donationData['orgName'],
          actName: donationData['activityName'],
          donationAmount: donationData['donationAmount'],
          donationDate: donationData['donationDate'],
          donationItems: donationData['donationItems'],
          donationType: donationData['donationType'],
          image: donationData['donationImage'],
          status: donationData['status'],
          donatorName: donationData['donatorName'],
          donatorAddress: donationData['donatorAddress'],
          availableOn: donationData['availableOn'],
          donatorMobileNo: donationData['donatorMobile'],
          userId: donationData['userId'],
        ));
      });
      _items = loadedDonations;

      notifyListeners();
        } catch (error) {
      throw (error);
    }
  }

  Future<void> updateMyDonation(String id, MyDonation newDonation) async {
    final donationIndex = _items.indexWhere((donation) => donation.id == id);
    String userId = newDonation.userId;
    if (donationIndex >= 0) {
      final url =
          'https://dailykoot-default-rtdb.firebaseio.com/MyDonations/$userId/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'activityName': newDonation.actName,
            'availableOn': newDonation.availableOn,
            'donationAmount': newDonation.donationAmount,
            'donationDate': newDonation.donationDate,
            'donationImage': newDonation.image,
            'donationItems': newDonation.donationItems,
            'donationType': newDonation.donationType,
            'donatorAddress': newDonation.donatorAddress,
            'donatorMobile': newDonation.donatorMobileNo,
            'donatorName': newDonation.donatorName,
            'orgName': newDonation.orgName,
            'status': newDonation.status,
            'userId': newDonation.userId,
          }));
      _items[donationIndex] = newDonation;
      notifyListeners();
    }
  }

  Future<void> deleteMyDonation({String? id, String? userId}) async {
    await loadSharedPrefs();
    userId = userLoad!.id;
    final url =
        'https://dailykoot-default-rtdb.firebaseio.com/MyDonations/$userId.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    MyDonation? existingProduct = _items[existingProductIndex];
    _items.removeWhere((activity) => activity.id == id);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<String> uploadImage(File image) async {
    String? _downloadUrl;
    Reference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    UploadTask uploadTask = storageReference.putFile(image);
   uploadTask.then((res) async {
       _downloadUrl = await storageReference.getDownloadURL();
    });
    
    return _downloadUrl!;
  }

  Future deleteImage(String imgUrl) async {
    Reference myStorageReference =
        await FirebaseStorage.instance.refFromURL(imgUrl);
    await myStorageReference.delete();
  }

  Future<void> updateDonationReq(MyDonation donationReq, String orgId) async {
    print('*************\n***************\n***************\n' +
        donationReq.donatorName);
    final reqIndex =
        _items.indexWhere((request) => request.id == donationReq.id);
    if (reqIndex >= 0) {
      var reqId = donationReq.id;
      final url =
          'https://dailykoot-default-rtdb.firebaseio.com/DonationRequests/$orgId/$reqId.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'activityName': donationReq.actName,
            'availableOn': donationReq.availableOn,
            'donationAmount': donationReq.donationAmount,
            'donationDate': donationReq.donationDate,
            'donationImage': donationReq.image,
            'donationItems': donationReq.donationItems,
            'donationType': donationReq.donationType,
            'donatorAddress': donationReq.donatorAddress,
            'donatorMobile': donationReq.donatorMobileNo,
            'donatorName': donationReq.donatorName,
            'orgName': donationReq.orgName,
            'status': donationReq.status,
            'userId': donationReq.userId,
          }));
      _items[reqIndex] = donationReq;
      notifyListeners();
    }
  }

  Future<Organization> fetchAndSetOrg(String orgName) async {
    final url =
        'https://dailykoot-default-rtdb.firebaseio.com/CharitableOrganizations.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Organization> loadedActivities = [];
      extractedData.forEach((autoOrgId, orgData) {
        loadedActivities.add(Organization(
            id: autoOrgId,
            orgName: orgData['orgName'],
            address: orgData['address'],
            bankAccounts: orgData['bankAccounts'],
            landLineNo: orgData['landLineNo'],
            description: orgData['description'],
            licenseNo: orgData['licenseNo'],
            mobileNo: orgData['mobileNo'],
            webPage: orgData['webPage'],
            logo: orgData['logo'],
            orgLocalId: orgData['orgLocalId']));
      });
      _orgList = loadedActivities;
      notifyListeners();
      var organization = _orgList.firstWhere((org) => org.orgName == orgName);
      return organization;
        } catch (error) {
      throw (error);
    }
  }
}

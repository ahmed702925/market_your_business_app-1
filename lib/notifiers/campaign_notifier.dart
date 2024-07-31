import 'dart:convert';
import 'package:market_app/models/campaign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CampaignNotifier with ChangeNotifier {
  List<Campaign> _campaignList = [];
  List<PreviousCampaign> _prevCampaignList = [];

  Campaign? _currentCampaign;

  Campaign get currentCampaign => _currentCampaign!;

  set currentCampaign(Campaign campaign) {
    _currentCampaign = campaign;
    notifyListeners();
  }

  List<Campaign> get campaignList {
    return [..._campaignList];
  }

  List<PreviousCampaign> get prevCampaignList {
    return [..._prevCampaignList];
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://marketbusinessapp-8a624-default-rtdb.firebaseio.com/Campaigns.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Campaign> loadedCampaigns = [];
      if (extractedData != null) {
        extractedData.forEach((prodId, prodData) {
          loadedCampaigns.add(Campaign(
            id: prodId,
            campaignName: prodData['name'],
            campaignDescription: prodData['description'],
            orgId: prodData['orgId'],
            orgName: prodData['orgName'],
            imagesUrl: prodData['image'],
            time: prodData['time'],
          ));
        });
      }
      _campaignList = loadedCampaigns;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchPreviousCampaigns() async {
    const url =
        'https://marketbusinessapp-8a624-default-rtdb.firebaseio.com/PreviousCampaigns.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<PreviousCampaign> loadedCampaigns = [];
      if (extractedData != null) {
        extractedData.forEach((prodId, prodData) {
          loadedCampaigns.add(PreviousCampaign(
            id: prodId,
            url: prodData['imageUrl'],
          ));
        });
      }
      _prevCampaignList = loadedCampaigns;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}

class PreviousCampaign {
  String? url;
  String? id;

  PreviousCampaign({
    this.id,
    this.url,
  });
}

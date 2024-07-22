import 'package:flutter/foundation.dart';

class Chat with ChangeNotifier{
  final String? id;
  final String text;
  final String userName;
  final String userId;
  final String? time;
  final String img;

  Chat({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
     this.time,
    required this.img,
  });
}
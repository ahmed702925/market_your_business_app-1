import 'package:flutter/foundation.dart';

class UserChat with ChangeNotifier {
  final String id;
  final String email;
  UserChat({
    required this.id,
    required this.email,
  });
}

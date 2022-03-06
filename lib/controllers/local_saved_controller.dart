import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class LocalSavedController {
  User user;
  BuildContext context;

  LocalSavedController(this.context, this.user);

  checkOfflineData() async {}
  syncData() async {}
}

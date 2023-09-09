import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:flutter/material.dart';

class FireBaseClientProvider extends ChangeNotifier {
  final FireBaseClient _fireBaseClient = FireBaseClient();

  FireBaseClient get client => _fireBaseClient;
}

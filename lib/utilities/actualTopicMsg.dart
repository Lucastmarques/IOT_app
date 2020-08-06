import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class DataFromMQTT extends ChangeNotifier {
  String actualTopic = "-/feeds/L1";
  String actualTemp = "20";
  String actualUmid = "50";
  List<String> Topics = [
    ktopicTemp,
    ktopicUmid,
  ];

  void changeTopic(String newTopic) {
    actualTopic = newTopic;
    notifyListeners();
  }

  void changeTemperature(String newMsg) {
    actualTemp = newMsg;
    notifyListeners();
  }

  void changeHumidity(String newMsg) {
    actualUmid = newMsg;
    notifyListeners();
  }
}

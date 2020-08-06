import 'package:flutter/material.dart';
import 'package:flutter_app/screens/mainScreen.dart';
import 'package:flutter_app/utilities/actualTopicMsg.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataFromMQTT(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.white,
          accentColor: Colors.white,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

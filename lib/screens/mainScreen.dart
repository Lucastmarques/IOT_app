import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_app/widgets/LampController.dart';
import 'package:flutter_app/widgets/gaugeWidget.dart';
import 'package:flutter_app/MQTT/MQTTClientWrapper.dart';
import 'package:flutter_app/widgets/ACcontrollerWidget.dart';
import 'package:flutter/material.dart';


String clientID = "XXXXX";

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper(context, clientID);
    setup(mqttClientWrapper);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meu Quarto APP",
          style: TextStyle(color: kTextColor),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.8,
              children: <Widget>[
                CostumizedGauge(
                  topic: ktopicTemp,
                  mqttClientWrapper: mqttClientWrapper,
                ),
                CostumizedGauge(
                  topic: ktopicUmid,
                  mqttClientWrapper: mqttClientWrapper,
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverGrid.count(
              crossAxisCount: 1,
              childAspectRatio: 3 / 4,
              children: <Widget>[
                ControllerCard(
                  mqttClientWrapper: mqttClientWrapper,
                ),
                LampController(
                  mqttClientWrapper,
                ),
              ],
            ),
          ),
          /*SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              childAspectRatio: 5,
              children: <Widget>[
                FlatButton(
                  child: Text('Tap to Disconnect'),
                  onPressed: () {
                    disconnectClient(mqttClientWrapper);
                  },
                ),
                FlatButton(
                  child: Text('Tap to Connect'),
                  onPressed: () {
                    setup(mqttClientWrapper);
                  },
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}

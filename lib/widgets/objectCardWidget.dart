import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_app/MQTT/MQTTClientWrapper.dart';

class ObjectCard extends StatefulWidget {
  final name;
  final icon;
  final topic;
  final mqttClientWrapper;

  ObjectCard({
    @required this.name,
    @required this.icon,
    @required this.topic,
    @required this.mqttClientWrapper,
  });

  @override
  _ObjectCardState createState() => _ObjectCardState();
}

class _ObjectCardState extends State<ObjectCard> {
  bool buttonState = false;
  String status = 'OFF';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: 200,
      width: 180.0,
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 18.0,
        color: Colors.grey[50],
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Card(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(
                      widget.icon,
                      size: 30.0,
                      color: kIconColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${widget.name}',
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 17.0),
                ),
                Text(
                  'Status: $status',
                  style: kHelpTextStyle,
                ),
                Switch(
                  value: buttonState,
                  onChanged: (isPressed) {
                    setState(() {
                      buttonState = isPressed;
                      if (status == 'OFF') {
                        status = 'ON';
                        _turnOn(widget.topic, widget.mqttClientWrapper);
                      } else {
                        status = 'OFF';
                        _turnOff(widget.topic, widget.mqttClientWrapper);
                      }
                    });
                  },
                  activeColor: Colors.deepOrange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _turnOn(String topic, MQTTClientWrapper mqttClientWrapper) {
  print("on");
  publishMessage(
    topic: topic,
    msg: "1",
    mqttClientWrapper: mqttClientWrapper,
  );
}

void _turnOff(String topic, MQTTClientWrapper mqttClientWrapper) {
  print("off");
  publishMessage(
    topic: topic,
    msg: "0",
    mqttClientWrapper: mqttClientWrapper,
  );
}

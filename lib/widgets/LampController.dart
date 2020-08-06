import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_app/MQTT/MQTTClientWrapper.dart';

class LampController extends StatefulWidget {
  final mqttClientWrapper;

  LampController(this.mqttClientWrapper);

  @override
  _LampControllerState createState() => _LampControllerState();
}

class _LampControllerState extends State<LampController> {
  String powerStatus = '0';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: 400,
      width: 300,
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 18.0,
        color: Colors.grey[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    child: FloatingActionButton(
                      shape: CircleBorder(),
                      elevation: 15.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.brightness_low,
                        size: 30.0,
                        color: kIconColor,
                      ),
                      onPressed: () {
                        _increaseIntensity(widget.mqttClientWrapper, '0');
                      },
                    ),
                  ),
                  Image(
                    image: AssetImage('images/mobile_signal.png'),
                    height: 43,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    child: FloatingActionButton(
                      shape: CircleBorder(),
                      elevation: 15.0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.brightness_high,
                        size: 30.0,
                        color: kIconColor,
                      ),
                      onPressed: () {
                        _decreaseIntensity(widget.mqttClientWrapper, '1');
                      },
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButton.extended(
              label: Text('          '),
              elevation: 5.0,
              backgroundColor: Colors.yellow,
              onPressed: () {
                _colorSwitch(widget.mqttClientWrapper, '3');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton.extended(
                  label: Text('          '),
                  elevation: 5.0,
                  backgroundColor: Colors.green,
                  onPressed: () {
                    _colorSwitch(widget.mqttClientWrapper, '1');
                  },
                ),
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.power_settings_new,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _powerSwitch(
                      mqttClientWrapper: widget.mqttClientWrapper,
                      msg: powerStatus,
                    );
                    //setState(() {
                    if (powerStatus == '0') {
                      powerStatus = '1';
                    } else {
                      powerStatus = '0';
                    }
                    //});
                  },
                ),
                FloatingActionButton.extended(
                  label: Text('          '),
                  elevation: 5.0,
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _colorSwitch(widget.mqttClientWrapper, '2');
                  },
                ),
              ],
            ),
            FloatingActionButton.extended(
              label: Text('          '),
              elevation: 5.0,
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                _colorSwitch(widget.mqttClientWrapper, '4');
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.party_mode,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _modeSwitch(widget.mqttClientWrapper, '3');
                  },
                ),
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.bubble_chart,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _modeSwitch(widget.mqttClientWrapper, '5');
                  },
                ),
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.school,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _modeSwitch(widget.mqttClientWrapper, '1');
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _modeSwitch(widget.mqttClientWrapper, '5');
                  },
                ),
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.brightness_3,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _modeSwitch(widget.mqttClientWrapper, '2');
                  },
                ),
                FloatingActionButton(
                  shape: CircleBorder(),
                  elevation: 15.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.data_usage,
                    size: 35.0,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    _modeSwitch(widget.mqttClientWrapper, '6');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _powerSwitch(
    {@required MQTTClientWrapper mqttClientWrapper, @required String msg}) {
  publishMessage(
    topic: ktopicPower,
    msg: msg,
    mqttClientWrapper: mqttClientWrapper,
  );
}

void _modeSwitch(MQTTClientWrapper mqttClientWrapper, String msg) {
  publishMessage(
    topic: ktopicMode,
    msg: msg,
    mqttClientWrapper: mqttClientWrapper,
  );
}

void _colorSwitch(MQTTClientWrapper mqttClientWrapper, String msg) {
  publishMessage(
    topic: ktopicColor,
    msg: msg,
    mqttClientWrapper: mqttClientWrapper,
  );
}

void _increaseIntensity(MQTTClientWrapper mqttClientWrapper, String msg) {
  publishMessage(
    topic: ktopicIntensity,
    msg: msg,
    mqttClientWrapper: mqttClientWrapper,
  );
}

void _decreaseIntensity(MQTTClientWrapper mqttClientWrapper, String msg) {
  publishMessage(
    topic: ktopicIntensity,
    msg: msg,
    mqttClientWrapper: mqttClientWrapper,
  );
}

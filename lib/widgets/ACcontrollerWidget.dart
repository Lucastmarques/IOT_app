import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_app/MQTT/MQTTClientWrapper.dart';

class ControllerCard extends StatefulWidget {
  final mqttClientWrapper;

  ControllerCard({
    @required this.mqttClientWrapper,
  });

  @override
  _ControllerCardState createState() => _ControllerCardState();
}

const int minTemp = 17;
const int maxTemp = 30;

class _ControllerCardState extends State<ControllerCard> {
  bool buttonState = false;
  String status = 'OFF';
  int temperature = 24;
  bool powerAC = false;
  String modeAC = '1';
  String fanAC = '0';
  IconData iconModeButton = Icons.ac_unit;
  String fanTextButton = "MAX";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: 300,
      width: 300,
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
                      Icons.ac_unit,
                      size: 30.0,
                      color: kIconColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'AC Remote Control',
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 17.0),
                ),
                Text(
                  'Status: $status',
                  style: kHelpTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FloatingActionButton(
                                elevation: 18.0,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    temperature = _increaseTemp(
                                      temperature: temperature,
                                      mqttClientWrapper:
                                          widget.mqttClientWrapper,
                                    );
                                  });
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 30.0,
                                  color: kIconColor,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 15,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    "$temperature ºC",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FloatingActionButton(
                                elevation: 18.0,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    temperature = _decreaseTemp(
                                      temperature: temperature,
                                      mqttClientWrapper:
                                          widget.mqttClientWrapper,
                                    );
                                  });
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30.0,
                                  color: kIconColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FloatingActionButton(
                                elevation: 18.0,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    if (!powerAC) {
                                      _turnACOn(
                                        mqttClientWrapper:
                                            widget.mqttClientWrapper,
                                      );
                                      status = 'ON';
                                    } else {
                                      _turnACOff(
                                        mqttClientWrapper:
                                            widget.mqttClientWrapper,
                                      );
                                      status = 'OFF';
                                    }
                                    powerAC = !powerAC;
                                  });
                                },
                                child: Icon(
                                  Icons.power_settings_new,
                                  size: 30.0,
                                  color:
                                      powerAC ? Colors.blue[900] : kIconColor,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FloatingActionButton(
                                    elevation: 18.0,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (modeAC == "0") {
                                          iconModeButton = Icons.ac_unit;
                                          modeAC = "1";
                                        } else if (modeAC == "1") {
                                          iconModeButton =
                                              Icons.format_color_reset;
                                          modeAC = "2";
                                        } else if (modeAC == "2") {
                                          iconModeButton = Icons.autorenew;
                                          modeAC = "3";
                                        } else if (modeAC == "3") {
                                          iconModeButton = Icons.toys;
                                          modeAC = "0";
                                        }
                                        _switchMode(
                                            widget.mqttClientWrapper, modeAC);
                                      });
                                    },
                                    child: Icon(
                                      iconModeButton,
                                      size: 30.0,
                                      color: kIconColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FloatingActionButton(
                                      elevation: 18.0,
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          if (fanAC == '0') {
                                            fanAC = '1';
                                            fanTextButton = "LOW";
                                          } else if (fanAC == '1') {
                                            fanAC = '2';
                                            fanTextButton = "HIGH";
                                          } else if (fanAC == '2') {
                                            fanAC = '3';
                                            fanTextButton = "MAX";
                                          } else if (fanAC == '3') {
                                            fanAC = '0';
                                            fanTextButton = "MIN";
                                          }
                                          _switchFAN(
                                              widget.mqttClientWrapper, fanAC);
                                        });
                                      },
                                      child: Text(
                                        fanTextButton,
                                        style: TextStyle(color: kIconColor),
                                      )),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _turnACOn({
  @required MQTTClientWrapper mqttClientWrapper,
}) {
  publishMessage(
    topic: ktopicACPower,
    msg: "1",
    mqttClientWrapper: mqttClientWrapper,
  );
}

void _turnACOff({
  @required MQTTClientWrapper mqttClientWrapper,
}) {
  publishMessage(
    topic: ktopicACPower,
    msg: "0",
    mqttClientWrapper: mqttClientWrapper,
  );
}

int _increaseTemp({
  @required int temperature,
  @required MQTTClientWrapper mqttClientWrapper,
}) {
  if (temperature == maxTemp) {
    publishMessage(
      topic: ktopicACtemp,
      msg: "$temperature",
      mqttClientWrapper: mqttClientWrapper,
    );
  } else {
    temperature++;
    publishMessage(
      topic: ktopicACtemp,
      msg: "$temperature",
      mqttClientWrapper: mqttClientWrapper,
    );
  }
  return temperature;
}

int _decreaseTemp({
  @required int temperature,
  @required MQTTClientWrapper mqttClientWrapper,
}) {
  if (temperature == minTemp) {
    publishMessage(
      topic: ktopicACtemp,
      msg: "$temperature",
      mqttClientWrapper: mqttClientWrapper,
    );
  } else {
    temperature--;
    publishMessage(
      topic: ktopicACtemp,
      msg: "$temperature",
      mqttClientWrapper: mqttClientWrapper,
    );
  }
  return temperature;
}

void _switchMode(MQTTClientWrapper mqttClientWrapper, String strMSG) {
  publishMessage(
      topic: ktopicACMode, msg: strMSG, mqttClientWrapper: mqttClientWrapper);
}

void _switchFAN(MQTTClientWrapper mqttClientWrapper, String strMSG) {
  publishMessage(
      topic: ktopicACFan, msg: strMSG, mqttClientWrapper: mqttClientWrapper);
}

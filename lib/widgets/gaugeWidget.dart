import 'package:flutter_app/utilities/actualTopicMsg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/utilities/constants.dart';

class CostumizedGauge extends StatelessWidget {
  final topic;
  final mqttClientWrapper;

  CostumizedGauge({@required this.topic, @required this.mqttClientWrapper});

  @override
  Widget build(BuildContext context) {
    //justSubscribe(mqttClientWrapper, topic);

    String value = topic == ktopicTemp
        ? Provider.of<DataFromMQTT>(context).actualTemp
        : Provider.of<DataFromMQTT>(context).actualUmid;

    double aux = double.parse(value);
    value = '${aux.round()}';

    return SfRadialGauge(
      title: GaugeTitle(
        text: topic == ktopicTemp ? "Temperatura" : "Umidade",
        textStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: topic == ktopicTemp ? 60 : 100,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 20,
                color:
                    topic == ktopicTemp ? Colors.blue[700] : Colors.blue[100],
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 20,
                endValue: 40,
                color: topic == ktopicTemp ? Colors.orange : Colors.blue,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 40,
                endValue: topic == ktopicTemp ? 60 : 100,
                color: topic == ktopicTemp ? Colors.red : Colors.blue[900],
                startWidth: 10,
                endWidth: 10)
          ],
          pointers: <GaugePointer>[NeedlePointer(value: double.parse(value))],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                  child: Text(topic == ktopicTemp ? "$value ºC" : "$value%",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        ),
      ],
    );
  }
}

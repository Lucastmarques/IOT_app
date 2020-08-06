import 'package:flutter/cupertino.dart';
import 'package:flutter_app/utilities/actualTopicMsg.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

///First of all, you have to initialize on your main code, or wherever you want
///to use this class, the instance MQTTClientWrapper. Than you just have to pass
///all the parameters needed and be happy.

enum MqttCurrentConnectionState {
  //just to make debug easier
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}
enum MqttSubscriptionState { IDLE, SUBSCRIBED } //just to make debug easier

///Create a Class to connect
class MQTTClientWrapper {
  final context;
  final clientID;

  MQTTClientWrapper(this.context, this.clientID);

  String broker = 'io.adafruit.com'; //Just change if you use another broker tcp
  int port = 1883; //By default, port = 1883. Change it if you need it
  String username = 'XXXXXX'; //Here you have to put your Broker Username
  String passwd = 'XXXXX'; // Broker Password

  MqttServerClient client; //initialize MqttServerClient as client

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  //final Function(String) onMessageReceived;
  //final VoidCallback onConnectedCallback;

  void _setupMqttClient() {
    //Setup the Server Client
    client = MqttServerClient.withPort(broker, clientID, port);
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.onUnsubscribed = _onUnsubscribed;
    client.pongCallback = _pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientID)
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('MQTTClientWrapper::Adafruit client connecting....');
    client.connectionMessage = connMess;
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Adafruit client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect(
          username, passwd); //Connect the client to the server client
    } on Exception catch (e) {
      //Catch any exception
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
    //Check if client is connected to the server client
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::Adafruit client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Adafruit client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _subscribeToTopic(String topicName) async {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    if (subscriptionState == MqttSubscriptionState.IDLE) {
      client.subscribe(topicName, MqttQos.atMostOnce);
      subscriptionState = MqttSubscriptionState.SUBSCRIBED;
      await MqttUtilities.asyncSleep(2);
    }
  }

  ///Important if you are working with multiple feeds
  void _unsubscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Unsubscribing');
    try {
      client.unsubscribe(topicName);
    } catch (e) {
      print(
          'MQTTClientWrapper::ERROR:: Unable to unsubscribe, exception <-$e->');
    }
  }

  void _checkMessage() {
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final String topicMsg = c[0].topic;
      print(
          'MQTTClientWrapper::Change notification:: topic is <$topicMsg>, payload is <-- $message -->');
      print('');

      if (topicMsg == 'Slempty/feeds/temp') {
        Provider.of<DataFromMQTT>(context)
            .changeTemperature(message.toString());
      } else if (topicMsg == 'Slempty/feeds/umidade') {
        Provider.of<DataFromMQTT>(context).changeHumidity(message.toString());
      }
    });
  }

  ///onConnected callback function
  void _onConnected() {
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
  }

  ///onDisconnected callback function
  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode ==
        MqttConnectReturnCode.connectionAccepted) {
      print(
          'MQTTClientWrapper::OnDisconnected callback is solicited, this is correct');
    }
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  ///onSubscribed callback function
  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  ///onUnsubscribed callback function
  void _onUnsubscribed(String topic) {
    print('MQTTClientWrapper::Unsubscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.IDLE;
  }

  ///pong callback function
  void _pong() {
    print('MQTTClientWrapper::Ping response client callback invoked');
  }
}

///Function to be used in main code - Setup and connect to MQTT server client
void setup(MQTTClientWrapper mqttClientWrapper) async {
  mqttClientWrapper._setupMqttClient();
  if (mqttClientWrapper.connectionState ==
          MqttCurrentConnectionState.DISCONNECTED ||
      mqttClientWrapper.connectionState == MqttCurrentConnectionState.IDLE) {
    mqttClientWrapper._setupMqttClient();
    await mqttClientWrapper._connectClient();

    for (int t = 0;
        t < Provider.of<DataFromMQTT>(mqttClientWrapper.context).Topics.length;
        t++) {
      mqttClientWrapper._subscribeToTopic(
          Provider.of<DataFromMQTT>(mqttClientWrapper.context).Topics[t]);
    }
    mqttClientWrapper._checkMessage();
  }
}

///Function to be used in main code - Publish a message on a topic
void publishMessage({
  @required String topic,
  @required String msg,
  @required MQTTClientWrapper mqttClientWrapper,
}) async {
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  builder.addString(msg);

  print('MQTTClientWrapper::Publishing message $msg to topic $topic');
  mqttClientWrapper.client
      .publishMessage(topic, MqttQos.exactlyOnce, builder.payload);

  builder.clear();

  //Wait for subscribe message from the broker
  await MqttUtilities.asyncSleep(2);
}

void disconnectClient(MQTTClientWrapper mqttClientWrapper) async {
  for (int t = 0;
      t < Provider.of<DataFromMQTT>(mqttClientWrapper.context).Topics.length;
      t++) {
    String topic =
        Provider.of<DataFromMQTT>(mqttClientWrapper.context).Topics[t];
    print("MQTTClientWrapper::Unsubscribing from topic $topic");
    mqttClientWrapper._unsubscribeToTopic(topic);
    await MqttUtilities.asyncSleep(1);
  }
  print('MQTTClientWrapper::Disconnecting...');

  try {
    mqttClientWrapper.client.disconnect();
    await MqttUtilities.asyncSleep(2);
  } catch (e) {
    print('MQTTClientWrapper::Unable to disconnected. Cautch Exception:: $e');
  }
  if (mqttClientWrapper.client.connectionStatus.state ==
      MqttConnectionState.disconnected) {
    print('MQTTClientWrapper::Succesfully Disconnected');
    mqttClientWrapper.connectionState = MqttCurrentConnectionState.DISCONNECTED;
  } else {
    print('MQTTClientWrapper::Unable to disconnect');
    mqttClientWrapper.connectionState = MqttCurrentConnectionState.IDLE;
  }
}

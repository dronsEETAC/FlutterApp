import 'dart:io';

//import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

class MQTTClientManager {
  //MqttServerClient internal_client =
  //    MqttServerClient.withPort('127.0.0.1', 'Phone_internal', 1884);

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  MqttServerClient internal_client =
      MqttServerClient.withPort('classpip.upc.edu', 'flutter_client', 1884);
  Future<void> connect() async {
    internal_client.logging(on: true);
    internal_client.keepAlivePeriod = 60;
    internal_client.onConnected = onConnected;
    internal_client.onDisconnected = onDisconnected;
    internal_client.onSubscribed = onSubscribed;
    internal_client.pongCallback = pong;
    internal_client.port = 1884;

    final internal_connMessage =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    internal_client.connectionMessage = internal_connMessage;

    try {
      await internal_client.connect("dronsEETAC", "mimara1456.");
    } on NoConnectionException catch (e) {
      print('MQTTClient::Client exception - $e');
      internal_client.disconnect();
    } on SocketException catch (e) {
      print('MQTTClient::Socket exception - $e');
      internal_client.disconnect();
    }
  }

  void disconnect() {
    //external_client.disconnect();
    internal_client.disconnect();
  }

  void subscribe(String topic) {
    print('Subscribing to the $topic topic');
    //external_client.subscribe(topic, MqttQos.atLeastOnce);
    internal_client.subscribe(topic, MqttQos.atLeastOnce);
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void onConnected() {
    print('MQTTClient::Connected');
    connectionState = MqttCurrentConnectionState.CONNECTED;
    internal_client.connectionStatus!.state == MqttConnectionState.connected;
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTTClient::Ping response received');
  }

  bool isConnected() {
    //return external_client.connectionStatus!.state ==
    //    MqttConnectionState.connected;
    return internal_client.connectionStatus!.state ==
        MqttConnectionState.connected;
  }

  void publishMessage(String topic, String message) {
    //if (isConnected()) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    //Solo para hacer el primer test
    internal_client.publishMessage(
        topic, MqttQos.exactlyOnce, builder.payload!);

    //external_client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    //internal_client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    //} else {
    //  print("You are not connected");
    //}
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    //return external_client.updates;
    return internal_client.updates;
  }
}

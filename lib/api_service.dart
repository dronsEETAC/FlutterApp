import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {
  static final ApiService _singleton = ApiService._internal();

  factory ApiService() {
    return _singleton;
  }

  ApiService._internal();

  bool isConnected = false;
  var ipAddrGround = '147.83.249.79:8105'; //localhost of emulator
  var ipAddrAir = '192.168.208.6:9000';

  // This next 3 functions are used to send the flight plan to RESTAPI which then in turn send it to the external broker, and the autopilot service
  // Its not the optimal way of doing it since it should be sent to the external broker through MQTT directly but i couldnt get it to work
  // This should be changed in the future you can try to follow this example https://github.com/shamblett/mqtt_client/blob/master/example/mqtt_server_client_websocket.dart
  Future<void> disconnectBroker() async {
    var url = Uri.parse('http://$ipAddrGround/disconnect');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      debugPrint('Successfully disconnected from the broker.');
      isConnected = false;
    } else {
      debugPrint(
          'Failed to disconnect from the broker: ${response.statusCode}: ${response.body}}');
    }
  }

  Future<void> connectBroker() async {
    var url = Uri.parse('http://$ipAddrGround/connect');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      debugPrint('Successfully connected to the broker.');
      isConnected = true;
    } else {
      debugPrint(
          'Failed to connect to the broker: ${response.statusCode}: ${response.body}');
    }
  }

  Future<String> getFlightPlan(String title) async {
    var url = Uri.parse('http://$ipAddrAir/get_flight_plan/$title');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      var data = "No flightPlan";
      return data;
    }
  }

  Future<bool> callApiFlightPlan(List waypoints) async {
    var url = Uri.parse('http://$ipAddrGround/executeFlightPlan');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(waypoints),
    );

    if (response.statusCode == 200) {
      debugPrint('Successfully posted waypoints.');
      return true;
    } else {
      debugPrint(
          'Failed to post waypoints: ${response.statusCode}: ${response.body}');
      return false;
    }
  }

  Future<List<dynamic>> fetchFlightPlans() async {
    // Voy a los planes de vuelos que ya están cargados en la bbdd de aire
    final response =
        await http.get(Uri.parse('http://$ipAddrAir/get_all_flightPlans'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['Waypoints'];
    } else {
      throw Exception('Failed to load flight plans');
    }
  }

  Future<List<dynamic>> fetchPastFlights() async {
    final response =
        await http.get(Uri.parse('http://$ipAddrGround/get_all_flights'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load flight plans');
    }
  }

  Future<List<dynamic>> fetchPastFlightsData(var flightplan_id) async {
    final response = await http.get(
        Uri.parse('http://$ipAddrGround/get_results_flight/' + flightplan_id));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load flight plans');
    }
  }

  Future<void> checkConnection() async {
    var url = Uri.parse('http://$ipAddrGround/connection_status');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      isConnected = data['is_connected'];
    }
  }

  String getImageUrl(String imagePath) {
    return 'http://$ipAddrGround/media/pictures/$imagePath';
  }

  String getVideoUrl(String videoPath) {
    return 'http://$ipAddrGround/media/videos/$videoPath';
  }

  String getThumbnailUrl(String videoPath) {
    return 'http://$ipAddrGround/thumbnail/$videoPath';
  }

  // Add other API calls here
}

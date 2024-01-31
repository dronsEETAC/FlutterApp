import 'package:flutter/material.dart';
import 'custom_drawer.dart';
import 'main_screen.dart';
import 'api_service.dart';
import 'MQTTClientManager.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'navigation_origin.dart';
import 'dart:async';

class SelectFlight extends StatefulWidget {
  const SelectFlight({Key? key}) : super(key: key);

  @override
  SelectFlightState createState() => SelectFlightState();
}

class SelectFlightState extends State<SelectFlight> {
  Future<List<dynamic>>? _flightPlans;
  ApiService apiService = ApiService();
  MQTTClientManager mqttClientManager = MQTTClientManager();
  bool _isConnecting = false;
  final String pubTopic = "+/mobileApp/#";

  @override
  void initState() {
    super.initState();
    _flightPlans = apiService.fetchFlightPlans();
    //apiService.checkConnection();
  }

  void changeScreen(Map flightPlan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          flightPlan: flightPlan,
          origin: NavigationOrigin.selectFlights,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Flight Page'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<dynamic>>(
        future: _flightPlans,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isConnecting = true;
                        });
                        if (apiService.isConnected) {
                          apiService.disconnectBroker().then((_) {
                            setState(() {
                              _isConnecting = false;
                            });
                          });
                        } else {
                          setupMqttClient();
                          setupUpdatesListener();
                          setState(() {
                            _isConnecting = false;
                          });
                          apiService.isConnected = true;
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            apiService.isConnected ? Colors.green : Colors.red),
                      ),
                      child: Text(
                          apiService.isConnected ? 'Disconnect' : 'Connect'),
                    ),
                    if (_isConnecting)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
                DataTable(
                  showCheckboxColumn: false,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(label: Text('Title')),
                    DataColumn(
                      label: Text('Waypoints'),
                    ),
                  ],
                  rows: snapshot.data!.map((flightPlan) {
                    var date = DateTime.fromMillisecondsSinceEpoch(
                        flightPlan['DateAdded']['\$date']);
                    return DataRow(
                      selected: false,
                      cells: <DataCell>[
                        DataCell(
                            Text('${date.day}-${date.month}-${date.year}')),
                        DataCell(Text(flightPlan['Title'].toString())),
                        DataCell(Text(flightPlan['NumWaypoints'].toString())),
                      ],
                      // When a row is clicked, send its flight plan
                      onSelectChanged: (_) {
                        if (apiService.isConnected) {
                          changeScreen(flightPlan);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not connected to the broker.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(pubTopic);
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }
}

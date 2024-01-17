import 'package:flutter/material.dart';
import 'custom_drawer.dart';
import 'main_screen.dart';
import 'api_service.dart';
import 'navigation_origin.dart';
import 'dart:async';

class PastFlights extends StatefulWidget {
  const PastFlights({Key? key}) : super(key: key);

  @override
  PastFlightsState createState() => PastFlightsState();
}

class PastFlightsState extends State<PastFlights> {
  Future<List<dynamic>>? _pastFlights;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _pastFlights = apiService.fetchPastFlights();
  }

  void changeScreen(Map flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          flight: flight,
          origin: NavigationOrigin.pastFlights,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Flights'),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<dynamic>>(
        future: _pastFlights,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Pics')),
                  DataColumn(label: Text('Vids')),
                  DataColumn(label: Text('Waypoints')),
                ],
                rows: List<DataRow>.generate(
                  snapshot.data.length,
                  (int index) {
                    var flight = snapshot.data[index];
                    var date = DateTime.fromMillisecondsSinceEpoch(
                        flight["Date"]["\$date"]);
                    String dateString =
                        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
                    return DataRow(
                      cells: [
                        DataCell(Text(dateString)),
                        DataCell(Text(flight["NumPics"].toString())),
                        DataCell(Text(flight["NumVids"].toString())),
                        DataCell(Text(
                            flight["FlightPlan"]["NumWaypoints"].toString())),
                      ],
                      onSelectChanged: (_) => changeScreen(flight),
                    );
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

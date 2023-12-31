import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibus2/Database/DatabaseFunctions.dart';
import 'package:ibus2/Database/DatabaseModel.dart';
import 'package:ibus2/Screens/ScreenBus.dart';
import 'package:ibus2/core/Colors.dart';
import 'package:intl/intl.dart';

class ScreenResults extends StatelessWidget {
  const ScreenResults({
    super.key,
    required String fromLocation,
    required String toLocation,
    required DateTime selectedDateTime,
  })  : _selectedDateTime = selectedDateTime,
        _toLocation = toLocation,
        _fromLocation = fromLocation;

  final String _fromLocation;
  final String _toLocation;
  final DateTime _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: height * 0.4,
            decoration: const BoxDecoration(
              color: themeColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 80, left: 15, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " 🚍 $_fromLocation",
                    // textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    " 🚍 $_toLocation",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    " 🚍 ${_selectedDateTime.day}-${_selectedDateTime.month}-${_selectedDateTime.year}",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: busNotifier,
              builder: (context, busList, _) {
                if (busList.isNotEmpty) {
                  final List<BusModel> sortedBuses = [];

                  if (_selectedDateTime.day != DateTime.now().day) {
                    sortedBuses.addAll(busList);
                    sortedBuses.sort((a, b) => a.time.compareTo(b.time));
                  } else {
                    final now = DateTime.now();
                    for (final bus in busList) {
                      if (bus.time.hour > now.hour) {
                        sortedBuses.add(bus);
                        sortedBuses.sort((a, b) => a.time.compareTo(b.time));
                      }
                    }
                  }

                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        String formattedTime = DateFormat('hh:mm a')
                            .format(sortedBuses[index].time);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            child: ListTile(
                              leading: const Text(
                                "🚍 ",
                                style: TextStyle(fontSize: 23),
                              ),
                              title: Text(
                                sortedBuses[index].name,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: themeColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Text(sortedBuses[index].number),
                              trailing: Text(
                                formattedTime,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ScreenBus(
                                          busName: sortedBuses[index].name,
                                          busNumber: sortedBuses[index].number,
                                          time: sortedBuses[index].time,
                                          whereFrom: _fromLocation,
                                          whereTo: _toLocation,
                                        )));
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: sortedBuses.length,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "🚍 No Buses\nAvailable right now,\ntry refreshing?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:textformfield_filtering_data/data.dart';

import 'textformfield_reusable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TextFormFieldFilteringData());
  }
}

class TextFormFieldFilteringData extends StatelessWidget {
  final zoneController = TextEditingController();

  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  TextFormFieldFilteringData({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        // backgroundColor: AppColors.lightSilver,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Add Your Details"),
          centerTitle: false,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "State/Province",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('.*'), // This denies all input
                    ),
                  ],
                  controller: stateController,
                  decoration: InputDecoration(
                    hintText: "Enter Your State/Province",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        stateController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return locationData
                            .map<PopupMenuItem<String>>((location) {
                          final String locationName =
                              location["name"] as String;
                          return PopupMenuItem<String>(
                            value: locationName,
                            child: Text(locationName),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "City",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('.*'), // This denies all input
                    ),
                  ],
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: "Enter Your City",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        cityController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        // Find the selected state based on stateController text
                        var selectedState = locationData.firstWhere(
                          (element) => element["name"] == stateController.text,
                        );

                        // Check if selectedState is null or doesn't contain a valid 'city' field
                        if (selectedState["city"] == null) {
                          return []; // Return empty list if no state or cities are found
                        }

                        // Get the list of cities for the selected state and ensure it's a List
                        List<dynamic> cities =
                            selectedState["city"] as List<dynamic>;

                        // Map over the cities to create PopupMenuItems
                        return cities.map<PopupMenuItem<String>>((city) {
                          final String cityName = city["city_name"] as String;
                          return PopupMenuItem<String>(
                            value: cityName,
                            child: Text(cityName),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Zone",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('.*'), // This denies all input
                    ),
                  ],
                  controller: zoneController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Zone",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xffAEAEAE),
                      ),
                    ),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        zoneController.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        // Ensure a state is selected
                        var selectedState = locationData.firstWhere(
                          (element) => element["name"] == stateController.text,
                          orElse: () =>
                              {}, // Return empty map if no state is found
                        );

                        // If no state is selected or the state has no cities, return empty list
                        if (selectedState.isEmpty ||
                            selectedState["city"] == null) {
                          return [];
                        }

                        // Find the selected city from the selected state
                        var selectedCity =
                            (selectedState["city"] as List).firstWhere(
                          (city) => city["city_name"] == cityController.text,
                          // orElse: () =>
                          //     {}, // Return empty map if no city is found
                        );

                        // If no city is selected or the city has no zones, return empty list
                        if (selectedCity.isEmpty ||
                            selectedCity["zones"] == null) {
                          return [];
                        }

                        // Extract the list of zones for the selected city
                        List<dynamic> zones =
                            selectedCity["zones"] as List<dynamic>;

                        // Map the zones to PopupMenuItems
                        return zones.map<PopupMenuItem<String>>((zone) {
                          final String zoneName = zone as String;
                          return PopupMenuItem<String>(
                            value: zoneName,
                            child: Text(zoneName),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

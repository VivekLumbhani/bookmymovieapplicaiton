import 'dart:convert';


import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:nookmyseatapplication/pages/navbar.dart';
import '../models/moviesget.dart';




class AddTheater extends StatefulWidget {
  const AddTheater({Key? key}) : super(key: key);

  @override
  State<AddTheater> createState() => _AddTheaterState();
}

class _AddTheaterState extends State<AddTheater> {
  final username = FirebaseAuth.instance.currentUser;
  final _upperRowController = TextEditingController();
  final _upperColumnController = TextEditingController();
  final _upperPriceController = TextEditingController();

  final _lowerRowController = TextEditingController();
  final _lowerColumnController = TextEditingController();
  final _lowerPriceController = TextEditingController();
  String? _cinemaNameError;
  String? _selectedCityError;
  String? _selectedMovieError;
  String? _upperRowError;
  String? _upperColumnError;
  String? _upperPriceError;
  String? _lowerRowError;
  String? _lowerColumnError;
  String? _lowerPriceError;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _cinemaNameController = TextEditingController();
  String selectedCity = "";
  List<String> allCities = ["surat", "navsari", "mumbai", "tapi", "delhi"];
  List<TimeOfDay> selectedShowTimes = [TimeOfDay.now()];
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey = GlobalKey();
  List<dynamic> theaters = [];

  String selectedMovieName = "";
  String selectedMovieId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: navbar(email: username!.email.toString()),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: Firebaseapitest().getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Map<String, dynamic>> data = snapshot.data!;
                        List movieNames =
                            data.map((doc) => doc['movieName']).toList();

                        if (selectedMovieId.isEmpty && data.isNotEmpty) {
                          selectedMovieId = data.first['documentID'];
                        }

                        return DropdownButton(
                          value: selectedMovieId,
                          items: data.map((doc) {
                            String movieDocumentId = doc['documentID'];
                            String movieName = doc['movieName'];

                            return DropdownMenuItem(
                              value: movieDocumentId,
                              child: Text(movieName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMovieId = value.toString();

                              selectedMovieName = data.firstWhere((doc) =>
                                  doc['documentID'] ==
                                  selectedMovieId)['movieName'];

                              var theatersDecode = data.firstWhere((doc) =>
                                  doc['documentID'] ==
                                  selectedMovieId)['theaters'];

                              theaters = List<Map<String, dynamic>>.from(
                                  jsonDecode(theatersDecode));
                              print("Decoded Theaters: $theaters");
                            });
                          },
                          hint: Text('Select Movie'),
                        );
                      }
                    },
                  ),
                  TextFormField(
                    controller: _cinemaNameController,
                    decoration: InputDecoration(
                      hintText: 'Cinema Name',
                      errorText: _cinemaNameError,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {                        _cinemaNameError = null;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          _cinemaNameError = 'Please enter the cinema name';
                        });
                        return 'Please enter the cinema name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  AutoCompleteTextField<String>(
                    key: autoCompleteKey,
                    clearOnSubmit: false,
                    suggestions: allCities,
                    decoration: InputDecoration(
                      hintText: 'Select City',
                      errorText: _selectedCityError,
                      border: OutlineInputBorder(),
                    ),
                    itemBuilder: (BuildContext context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    itemFilter: (String suggestion, String query) {
                      return suggestion
                          .toLowerCase()
                          .startsWith(query.toLowerCase());
                    },
                    itemSorter: (String a, String b) {
                      return a.compareTo(b);
                    },
                    itemSubmitted: (String value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                    textChanged: (String value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },

                  ),
                  SizedBox(height: 8),
                  Text(
                    'Show Times:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  for (int i = 0; i < selectedShowTimes.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedShowTimes[i],
                              );
                              if (picked != null &&
                                  picked != selectedShowTimes[i]) {
                                setState(() {
                                  selectedShowTimes[i] = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Show Time ${i + 1}',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                selectedShowTimes[i].format(context),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              selectedShowTimes.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedShowTimes.add(TimeOfDay.now());
                      });
                    },
                    child: Text('Add More Shows'),
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upper Part",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('Row'),
                        TextFormField(
                          key: Key('upper_row'),
                          controller: _upperRowController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the row';
                            }
                            final row = int.tryParse(value);
                            if (row == null || row < 20) {
                              return 'Row should be at least 20';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Column'),
                        TextFormField(
                          key: Key('upper_column'),
                          controller: _upperColumnController,
                          validator: (value) {
                            // Add validation logic if needed
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Price'),
                        TextFormField(
                          key: Key('upper_price'),
                          controller: _upperPriceController,
                          validator: (value) {
                            // Add validation logic if needed
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lower Part",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('Row'),
                        TextFormField(
                          key: Key('lower_row'),
                          controller: _lowerRowController,
                          validator: (value) {

                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Column'),
                        TextFormField(
                          key: Key('lower_column'),
                          controller: _lowerColumnController,
                          validator: (value) {
                            // Add validation logic if needed
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Price'),
                        TextFormField(
                          key: Key('lower_price'),
                          controller: _lowerPriceController,
                          validator: (value) {
                            // Add validation logic if needed
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    print('seatings: {'
        'upperPart: {'
        'row: ${_upperRowController.text}, '
        'column: ${_upperColumnController.text}, '
        'price: ${_upperPriceController.text}, '
        '}, '
        'lowerPart: {'
        'row: ${_lowerRowController.text}, '
        'column: ${_lowerColumnController.text}, '
        'price: ${_lowerPriceController.text}, '
        '}, '
        '}');

    List<Map<String, int?>> dynamicTimes = selectedShowTimes
        .map((time) => {'hour': time.hour, 'minute': time.minute})
        .toList();

    dynamicTimes.sort((a, b) {
      int aHour = a['hour'] ?? 0;
      int bHour = b['hour'] ?? 0;

      int aMinute = a['minute'] ?? 0;
      int bMinute = b['minute'] ?? 0;

      if (aHour != bHour) {
        return aHour.compareTo(bHour);
      } else {
        return aMinute.compareTo(bMinute);
      }
    });

    Map<String, dynamic> submittedData = {
      'cinemaName': _cinemaNameController.text,
      'city': selectedCity,
      'dynamicTimes': dynamicTimes,
      'seatings': {
        'upperPart': {
          'row': _upperRowController.text,
          'column': _upperColumnController.text,
          'price': _upperPriceController.text,
        },
        'lowerPart': {
          'row': _lowerRowController.text,
          'column': _lowerColumnController.text,
          'price': _lowerPriceController.text,
        },
      }
    };

    setState(() {
      theaters.add(submittedData);
    });

    try {
      String theatersJson = jsonEncode(theaters);

      await FirebaseFirestore.instance
          .collection('buscollections')
          .doc(selectedMovieId)
          .update({
        'theaters': theatersJson,
      });

      print(submittedData);
      print('Theaters: $theatersJson');
    } catch (e) {
      print('Error updating theaters: $e');
    }
  }
}

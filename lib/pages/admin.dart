import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nookmyseatapplication/pages/navbar.dart';
import 'package:nookmyseatapplication/pages/serv.dart';

class admin extends StatefulWidget {
  admin({Key? key}) : super(key: key);

  @override
  _admin createState() => _admin();
}

class _admin extends State<admin> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController movieName = TextEditingController();
  final TextEditingController movieprice = TextEditingController();
  final TextEditingController seatscontrol = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController imgname = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();
  List<String> categories = [];

  List<Map<String, dynamic>> castList = [];

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedExpiry = DateTime.now();

  List<Map<String, dynamic>> theaters = [];
  var imgpath;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        dateController.text = _dateFormat.format(_selectedDate);
      });
  }

  Future<void> _selectExpiry(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiry,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedExpiry)
      setState(() {
        _selectedExpiry = picked;
        expiryDateController.text = _dateFormat.format(_selectedExpiry);
      });
  }

  Future<void> _selectDynamicTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        theaters[index]['dynamicTime'] = picked;
      });
    }
  }

  void addTheatre() {
    setState(() {
      theaters.add({
        'cinemaName': '',
        'dynamicTime': null,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String formattedExpiryDate =
        DateFormat('yyyy-MM-dd').format(_selectedExpiry);
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: navbar(email: user!.email.toString()),
      appBar: AppBar(title: Text('Admin'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  'Movie Name*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Movie Name',
                    border:OutlineInputBorder(),
                  ), // Add an asterisk (*) to indicate required
                  controller: movieName,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a movie name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Select Release Date*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200, // Adjust the width as needed
                      child: Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_today),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pick Poster for Movie*',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.upload),
                      onPressed: () async {
                        final source = ImageSource.gallery;
                        final pickedImage =
                            await ImagePicker().pickImage(source: source);

                        if (pickedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No image selected')),
                          );
                        } else {
                          final path = pickedImage.path;
                          final fileName = pickedImage.name;
                          imgpath = fileName;
                          final serve = serv();
                          await serve.uploadfile(path, fileName);

                          print('Path is $path and filename is $fileName');
                        }
                      },

                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Select Expiry Date*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: expiryDateController,
                        decoration: InputDecoration(
                          hintText: 'Select Date',
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => _selectExpiry(context),
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ],
                ),

                SizedBox(height: 8,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              castList.add({"name": "", "image": ""});
                            });
                          },
                          child: Text("Add a Cast"),
                        ),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: castList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Cast Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      castList[index]["name"] = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                onPressed: () async {
                                  final source = ImageSource.gallery;
                                  final pickedImage = await ImagePicker().pickImage(source: source);

                                  if (pickedImage != null) {
                                    final path = pickedImage.path;
                                    final fileName = pickedImage.name;

                                    setState(() {
                                      castList[index]["image"] = fileName;
                                    });

                                    try {
                                      await serv().uploadCastImage(path, fileName);
                                      print('Cast image uploaded successfully');
                                    } catch (e) {
                                      print('Error uploading cast image: $e');
                                      // Handle the error, display a message, or log it
                                    }
                                  }
                                },
                                icon: Icon(Icons.upload),
                              ),

                            ],
                          );
                        },
                      ),
                    ],
                  ),
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
                      Row(
                        children: [
                          Expanded(
                            child: Flexible(
                              child: TextFormField(
                                controller: categoryController, // Updated to use categoryController
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Handle onChanged if needed
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                categories.add(categoryController.text);
                                categoryController.clear();
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        children: categories.map((categoryItem) {
                          Color randomColor =
                          Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                              .withOpacity(1.0);

                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: randomColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    categoryItem,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        categories.remove(categoryItem);
                                      });
                                      print("Category removed: $categoryItem");
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),


                Text(
                  'Movie Description*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Movie Description',
                    border: OutlineInputBorder(),
                  ),
                  controller: descriptionController,
                  maxLines: null, // Allows multiple lines for the description
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a movie description';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 5,),
                Text(
                  'Movie Trailer Link*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Trailer Link',
                    border:OutlineInputBorder(),
                  ),
                  controller: linkController,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a movie name';
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      String movieNameValue = movieName.text;
                      String dateValue = dateController.text;
                      String expiryDateValue = expiryDateController.text;
                      String movieDescriptionValue = descriptionController.text;
                      String trailerLinkValue = linkController.text;
                      List category=categories;
                      List<Map<String, dynamic>> castData = [];
                      castList.forEach((cast) {
                        castData.add({
                          'name': cast['name'],
                          'image': cast['image'],
                        });
                      });
                      String castDataJson = jsonEncode(castData);

                      // Theaters information
                      List<Map<String, dynamic>> theatersData = [];
                      theaters.forEach((theater) {
                        theatersData.add({
                          'cinemaName': theater['cinemaName'],
                          'dynamicTime': {
                            'hour': theater['dynamicTime'] != null
                                ? theater['dynamicTime'].hour
                                : 0,
                            'minute': theater['dynamicTime'] != null
                                ? theater['dynamicTime'].minute
                                : 0,
                          },
                        });
                      });
                      String theatersDataJson = jsonEncode(theatersData);

                      try {
                        await FirebaseFirestore.instance
                            .collection('buscollections')
                            .add({
                          'movieName': movieNameValue,
                          'date': dateValue,
                          'expiryDate': expiryDateValue,
                          'imgname': imgpath,
                          'theaters': theatersDataJson,
                          'descriptionOfMovie': movieDescriptionValue,
                          'link': trailerLinkValue,
                          'casts': castDataJson,
                          'categories':category
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data inserted successfully')),
                        );
                      } catch (e) {
                        print('Error inserting data: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error inserting data')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Validation failed')),
                      );
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change the button color as needed
                    onPrimary: Colors.white, // Change the text color as needed
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

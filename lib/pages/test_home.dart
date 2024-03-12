import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nookmyseatapplication/pages/explore.dart';
import 'package:nookmyseatapplication/pages/navbar.dart';
import 'package:nookmyseatapplication/pages/profile.dart';
import 'package:nookmyseatapplication/pages/something.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../movies.dart';
import 'mainScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<MovieModel> foryouItemList = List.of(forYouImages);
  final List<MovieModel> popularItemList = List.of(popularImages);
  final List<MovieModel> genresItemList = List.of(genresList);

  final username = FirebaseAuth.instance.currentUser;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final PageController pageController =
  PageController(initialPage: 0, viewportFraction: 1);

  int currentIndex = 0;

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.house),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.compass),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.video),
      label: 'Something',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.user),
      label: 'Profile',
    ),
  ];

  String selectedCity = '';

  @override
  void initState() {

    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    startTimer(15);

    loadSelectedCity();
  }

  Future<void> loadSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCity = prefs.getString("selectedCity") ?? "";
    });
  }

  Future<void> saveSelectedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedCity", city);
  }

  void startTimer(int durationInSeconds) async {
    await Future.delayed(Duration(seconds: durationInSeconds), () async {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1, // Unique ID for the notification
          channelKey: 'timer_channel',
          title: 'Timer Completed!',
          body: 'Your timer of $durationInSeconds seconds has finished.',
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(email: username!.email.toString()),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            final selected = await showSearch(
              context: context,
              delegate: CustomDelegate(),
            );
            if (selected != null && selected is String) {
              setState(() {
                selectedCity = selected;
              });
              saveSelectedCity(selected);
            }
          },
          child: Row(
            children: [
              Text(selectedCity.isNotEmpty ? selectedCity : 'Select City'),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onIconClicked,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        items: bottomNavBarItems,
      ),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          MainScreen(),
          something(),
          explore(),
          profile(),
        ],
      ),
    );
  }

  void onIconClicked(int index) {
    setState(() {
      currentIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class CustomDelegate extends SearchDelegate<String> {
  List<String> allCities = ["surat", "navsari", "mumbai", "tapi", "delhi"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "null");
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var city in allCities) {
      if (city.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(city);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result);
          },
        );
      },
    );
  }
}

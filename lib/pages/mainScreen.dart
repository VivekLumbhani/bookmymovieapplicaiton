
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/models/getuser.dart';
import 'package:nookmyseatapplication/pages/booking.dart';
import 'package:nookmyseatapplication/pages/chats.dart';
import 'package:nookmyseatapplication/pages/navbar.dart';
import 'package:nookmyseatapplication/pages/seat_demo_layout.dart';
import 'package:nookmyseatapplication/pages/seatstest.dart';
import 'package:nookmyseatapplication/pages/widgets/custom_card_normal.dart';
import 'package:nookmyseatapplication/pages/widgets/custom_card_thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../colors.dart';
import '../movies.dart';
import 'choose.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseGetUserApi api = FirebaseGetUserApi();

  final List<MovieModel> foryouItemList = List.of(forYouImages);
  final List<MovieModel> popularItemList = List.of(popularImages);
  final List<MovieModel> genresItemList = List.of(genresList);

  String localname="";
  String userNamee="";
  String phoneNumber="";
  String email="";
  final username = FirebaseAuth.instance.currentUser;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.9);
  @override
  void initState() {
    super.initState();
    loadSelectedCity();
  }
  Future<void> loadSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      localname = prefs.getString("USERNAMEKEY") ?? "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(email: username!.email.toString()),
      body: Stack(
        children: [
          FutureBuilder<Map<String, String>>(
            future: api.getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {

                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Future encountered an error, show error message
                return Text('Error: ${snapshot.error}');
              } else {
                // Future completed successfully, use the data
                var userData = snapshot.data;

                print("user data $userData");
                // You can access the user data here
                 userNamee = userData?['name'] ?? 'Unknown';
                 phoneNumber = userData?['phoneNumber'] ?? 'Unknown';
                 email = userData?['email'] ?? 'Unknown';

                // Now you can use these values in your widget
                return Container();
              }
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hi,${localname.toString()}",
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                      "For You",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  foryoucardsLayout(context, foryouItemList),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  movieListBuilder(context, popularItemList),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Genre",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  genreBuilder(context, genresList),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget foryoucardsLayout(BuildContext context, List<MovieModel> movieList) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      child: PageView.builder(
        physics: ClampingScrollPhysics(),
        controller: pageController,
        itemCount: 1,
        itemBuilder: (context, index) {
          return CustomCardThumnail();
        },
      ),
    );
  }

  Widget movieListBuilder(BuildContext context, List<MovieModel> movieList) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.27,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index) {
          return CustomCardNormal();
        },
      ),
    );
  }

  Widget genreBuilder(BuildContext context, List<MovieModel> genresList) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.30,
      child: ListView.builder(
        itemCount: genresList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  chatsScreen(),
                ),
              )
            },
            child: Stack(
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(
                        genresList[index].imageAsset.toString(),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 30),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Text(
                    genresList[index].movieName.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nookmyseatapplication/pages/test_home.dart';



class MyAppIntroductionScreen extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  List<PageViewModel> getPages(BuildContext context) {
    return [
      _buildPage(
        context,
        "images/users.jpeg",
        'Get Started',
        "Movie app with all sorts of facilities provided from end-to-end",
      ),
      _buildPage(
        context,
        "images/que.jpeg",
        'Hassle free',
        "Never worry to stand in long queue at box office..",
      ),
      _buildPage(
        context,
        "images/rush.jpeg",
        'Third Page',
        "Don't worry to rush for last minute show book early and hassle free from your app",
      ),
      _buildPage(
        context,
        "images/getready.png",
        "Let's Go",
        "Start your movie journey with us! and don't forget to take you snacks & coldrinks 😜",
      ),
    ];
  }
  PageViewModel _buildPage(
      BuildContext context, String imagePath, String title, String body) {
    return PageViewModel(
      image: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * 0.5,
        alignment:const Alignment(0, 0.5), // Center horizontally, move down 50%
      ),
      title: title,
      body: body,
      footer: Text("Book my movie", textAlign: TextAlign.center),
      decoration: PageDecoration(
          titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
          bodyTextStyle: TextStyle(fontSize: 19.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        done: Text("Done", style: TextStyle(color: Colors.black)),
        onDone: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        },
        pages: getPages(context),
        globalBackgroundColor: Colors.white,
        showNextButton: true,
        showBackButton: false,
        showSkipButton: true,


        infiniteAutoScroll: false,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),

            ),
          ),
        ),



        skip: const Text("Skip",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        next: const Icon(Icons.arrow_forward),
        back: const Icon(Icons.arrow_back),

      ),
    );
  }
}

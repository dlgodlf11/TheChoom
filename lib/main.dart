import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:thechoom/login/loginmain.dart';
import 'package:thechoom/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoContext.clientId = "0d012ecadffcc9a0edc37b9a5707485a";
  //KakaoContext.clientId = "11d629d8d183fba7172604100112ff1c";
  KakaoContext.javascriptClientId = "c59eb0bd52a033711ba49186d8f5397e";
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        unselectedWidgetColor: Color(0xff707070),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Screen size;
  @override
  void initState() {
    //UserApi.instance.logout();
    //updatefirebase();
    Timer splashdelay = new Timer(Duration(seconds: 3), () {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (context) => Loginmain());
      Navigator.push(context, route);
    });

    super.initState();
  }

  updatefirebase() {
    var data = [
      {
        "category": ["Choreography"],
        "dancer": "Maria",
        "dancerprofile":
            "https://firebasestorage.googleapis.com/v0/b/thechoom-b1953.appspot.com/o/dancerpfofile%2FMARIA.jpg?alt=media&token=641c3576-183c-4674-bc38-5c16d1913dc4",
        "insta": "____mariaaaaaa",
        "isAI": false,
        "level": "중급",
        "musicname": "Pookie",
        "runtime": "10:34",
        "singer": "Aya Nakamura",
        "studio": "GIRLS HIPHOP",
        "teachcategory": "Choreography",
        "thumb":
            "https://firebasestorage.googleapis.com/v0/b/thechoom-b1953.appspot.com/o/Thumb%2Fthumb_swag_pok.png?alt=media&token=62124ada-3c7e-4135-92f8-6d4734e4d3cf",
        "timeline": [],
        "title": "라틴 풍의 blah blah blah pookie~",
        "url": "7vytBqX1NL8"
      }
    ];
    FirebaseFirestore.instance
        .collection('Dance')
        .doc("스웩넘치는 창작 안무!")
        .set({"element": FieldValue.arrayUnion(data)}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Container(
        color: Colors.black,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: Container(
            width: size.getWidthPx(180),
            height: size.getWidthPx(90),
            child: SvgPicture.asset('assets/images/splash_tcm.svg'),
          )),
        )));
  }
}

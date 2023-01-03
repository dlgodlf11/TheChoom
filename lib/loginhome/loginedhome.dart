import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:thechoom/login/loginmain.dart';
import 'package:thechoom/loginhome/bottomnavbar.dart';
import 'package:thechoom/mychoom/mychoom.dart';
import 'package:thechoom/profile/profile.dart';
import 'package:thechoom/ui_home/home.dart';
import 'package:thechoom/utils/utils.dart';

_HomePageState homeState;

class HomePage extends StatefulWidget {
  final String currentuserUid;
  final String name;
  HomePage({this.currentuserUid, this.name}) {
    homeState = new _HomePageState(currentuserUid: currentuserUid, name: name);
  }

  @override
  _HomePageState createState() => homeState;
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final String currentuserUid;
  final String name;
  int currentTab = 0;
  PageController pageController = new PageController();
  String appbartitle = 'The Choom';
  Screen size;

  _HomePageState({this.currentuserUid, this.name});
  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);

    return Container(
      color: Color(0xff191919),
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.grey[900],
              appBar: appbar(),
              body: bodyView(currentTab),
              bottomNavigationBar:
                  BottomNavBar(changeCurrentTab: changeCurrentTab))),
    );
  }

  changeCurrentTab(int tab) {
    //Changing tabs from BottomNavigationBar
    setState(() {
      currentTab = tab;
      pageController.jumpToPage(0);
      switch (currentTab) {
        case 0:
          //Dashboard Page
          appbartitle = "HOME";
          break;
        case 1:
          //Search Page
          appbartitle = "MY CHOOM";
          break;
        case 2:
          //Profile Page
          appbartitle = "PROFILE";
          break;
      }
    });
  }

  bodyView(currentTab) {
    List<Widget> tabView = [];
    //Current Tabs in Home Screen...
    switch (currentTab) {
      case 0:
        //Dashboard Page
        tabView = [UiHome()];
        break;
      case 1:
        //Search Page
        tabView = [MyChoomMain()];
        break;
      case 2:
        //Profile Page
        tabView = [ProfileMenu()];
        break;
    }
    return PageView(controller: pageController, children: tabView);
  }

  appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xff191919),
        title: Container(
          padding: EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffcb0ccc), width: 6))),
          child: Text(
            appbartitle,
            textScaleFactor: 1.0,
            style: TextStyle(
              color: const Color(0xffcb0ccc),
              fontFamily: "w700",
              fontStyle: FontStyle.normal,
              fontSize: size.getWidthPx(17),
            ),
          ),
        ),
        centerTitle: false,
      ),
    );
  }
}

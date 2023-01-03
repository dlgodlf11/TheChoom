import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/ui_home/danceclass/useaiwidget/checklist.dart';
import 'package:thechoom/ui_home/home.dart';
import 'package:thechoom/utils/utils.dart';

class ViewScore extends StatefulWidget {
  final double score;
  final String url;
  final String title;
  final int start;
  final int end;
  final int bpm;

  ViewScore({this.score, this.url, this.title, this.bpm, this.end, this.start});
  @override
  _ViewScoreState createState() => _ViewScoreState();
}

class _ViewScoreState extends State<ViewScore> {
  Screen size;
  bool up = false;
  var scorebackground;
  var scorechar;
  var profileimg;
  var ranktext = {
    "S": "와우! 혹시 본인이세요? 대단해요!",
    "A": "이야! 노래와 춤이 찰떡인걸요?",
    "B": "조금만 더 노력하면 당신은 A !",
    "C": "안타까워요. 한 번더 해볼까요?",
    "D": "연습이 많이 필요한 것 같네요."
  };
  @override
  void initState() {
    print(FirebaseAuth.instance.currentUser);
    var firebaseuser = FirebaseAuth.instance.currentUser;

    if (firebaseuser == null) {
      var kakaouser = UserApi.instance.me();
      kakaouser.then((value) {
        setState(() {
          profileimg = value.kakaoAccount.profile.profileImageUrl.toString();
          print(profileimg);
        });
      });
    } else {
      setState(() {
        profileimg = firebaseuser.photoURL;
      });
      print('시발유야이디는');
    }
    print(profileimg);
    if (widget.score >= 85) {
      setState(() {
        scorebackground = "assets/lottiejson/rank_S.json";
        scorechar = "S";
      });
    } else if (widget.score >= 80) {
      setState(() {
        scorebackground = "assets/lottiejson/rank_AtoD.json";
        scorechar = "A";
      });
    } else if (widget.score >= 70) {
      setState(() {
        scorebackground = "assets/lottiejson/rank_AtoD.json";
        scorechar = "B";
      });
    } else if (widget.score >= 60) {
      setState(() {
        scorebackground = "assets/lottiejson/rank_AtoD.json";
        scorechar = "C";
      });
    } else {
      setState(() {
        scorebackground = "assets/lottiejson/rank_AtoD.json";
        scorechar = "D";
      });
    }
    delay();
    super.initState();
  }

  delay() {
    Timer timer = new Timer(Duration(milliseconds: 800), () {
      setState(() {
        up = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
        color: Colors.black,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    top: up ? 0 : size.screenSize.height,
                    child: SafeArea(
                      child: Container(
                          margin: EdgeInsets.only(top: size.getWidthPx(120)),
                          padding: EdgeInsets.only(
                              top: size.getWidthPx(94),
                              bottom: size.getWidthPx(0),
                              left: size.getWidthPx(20),
                              right: size.getWidthPx(20)),
                          width: size.screenSize.width,
                          height: size.screenSize.height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("춤신춤왕",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xff817d7d),
                                          fontFamily: "w500",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(15)),
                                      textAlign: TextAlign.center),
                                  Text("Dancing level",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xff4b4b4b),
                                          fontFamily: "w100",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(23)),
                                      textAlign: TextAlign.left),
                                  Container(
                                      height: size.getWidthPx(220),
                                      padding:
                                          EdgeInsets.all(size.getWidthPx(0)),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Lottie.asset(
                                            scorebackground,
                                            height: size.getWidthPx(220),
                                          ),
                                          Text(scorechar,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xffdd1dde),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "SpoqaHanSansNeo",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize:
                                                      size.getWidthPx(145)),
                                              textAlign: TextAlign.center)
                                        ],
                                      )),
                                  Text(
                                      "당신의 정확도는 " +
                                          widget.score.round().toString() +
                                          "% 입니다.",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xff4b4b4b),
                                          fontFamily: "w100",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(23)),
                                      textAlign: TextAlign.left),
                                  SizedBox(
                                    height: size.getWidthPx(20),
                                  ),
                                  Text(ranktext[scorechar],
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xff4b4b4b),
                                          fontFamily: "w100",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(15)),
                                      textAlign: TextAlign.left),
                                ],
                              ),
                              SizedBox(height: size.getWidthPx(20)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Route route = MaterialPageRoute(
                                          builder: (context) => ChecklistWidget(
                                                url: widget.url,
                                                title: widget.title,
                                                start: widget.start,
                                                end: widget.end,
                                                bpm: widget.bpm,
                                              ));
                                      Navigator.push(context, route);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.getWidthPx(151),
                                      height: size.getWidthPx(55),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color(0x34000000),
                                                offset: Offset(5, 5),
                                                blurRadius: 10,
                                                spreadRadius: 0)
                                          ],
                                          color: const Color(0xffffffff)),
                                      child: Text("다시하기",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              color: const Color(0xffdd1dde),
                                              fontFamily: "w700",
                                              fontStyle: FontStyle.normal,
                                              fontSize: size.getWidthPx(16)),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.getWidthPx(151),
                                      height: size.getWidthPx(55),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color(0x34000000),
                                                offset: Offset(5, 5),
                                                blurRadius: 10,
                                                spreadRadius: 0)
                                          ],
                                          color: const Color(0xffffffff)),
                                      child: Text("끝내기",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              color: const Color(0xffdd1dde),
                                              fontFamily: "w700",
                                              fontStyle: FontStyle.normal,
                                              fontSize: size.getWidthPx(16)),
                                          textAlign: TextAlign.center),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                  ),
                  AnimatedPositioned(
                      top: up
                          ? 0 + size.getWidthPx(50)
                          : size.screenSize.height + size.getWidthPx(50),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.green,
                        backgroundImage: profileimg == null
                            ? AssetImage('assets/images/logo@4x-8.png')
                            : NetworkImage(profileimg),
                      ))
                ],
              )),
        ));
  }
}

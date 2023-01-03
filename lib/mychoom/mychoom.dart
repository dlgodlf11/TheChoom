import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/mychoom/suggestion.dart';
import 'package:thechoom/ui_home/danceclass/noneAI.dart';
import 'package:thechoom/ui_home/danceclass/useaiwidget/checklist.dart';
import 'package:thechoom/ui_home/minivideo.dart';
import 'package:thechoom/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MyChoomMain extends StatefulWidget {
  @override
  _MyChoomMainState createState() => _MyChoomMainState();
}

class _MyChoomMainState extends State<MyChoomMain> {
  Screen size;
  String uid;
  bool hasYourChoom = false;
  var c1 = [];
  List<Widget> suggestionList = [];
  var suggestionname = [];
  var suggestscore = [];
  @override
  void initState() {
    print('sfsdfdfsaadsfasdfsadfdasfasdffdsa');
    checkCurrentUser();
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        hasYourChoom = null;
      });
      UserApi.instance.me().then((value) {
        FirebaseFirestore.instance.collection('Users').doc(value.id.toString()).get().then((value) {
          if (value.data()['age'] != null && value.data()['category'] != null) {
            changeGenreToDouble(value.data()['category']);
            changeAgeToDouble(value.data()['age']);
            checkYourChoom();
          } else {
            setState(() {
              hasYourChoom = false;
            });
          }
        });
      });
    } else {
      setState(() {
        hasYourChoom = null;
      });
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
        if (value.data()['age'] != null && value.data()['category'] != null) {
          changeGenreToDouble(value.data()['category']);
          changeAgeToDouble(value.data()['age']);
          checkYourChoom();
        } else {
          setState(() {
            hasYourChoom = false;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
        color: Color(0xff191919),
        child: SafeArea(
          child: Scaffold(
              floatingActionButton: hasYourChoom != null && hasYourChoom && suggestionList.length != 0
                  ? FloatingActionButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(builder: (context) => SuggestionMain());
                        Navigator.push(context, route).then((value) {
                          print(value);
                          if (value != null) {
                            setState(() {
                              c1 = value;
                              suggestionList = [];

                              checkYourChoom();
                            });
                          }
                        });
                      },
                      tooltip: "MyChoom 다시받기",
                      backgroundColor: Color(0xffdd1dde),
                      child: Text(
                        "MyChoom\n다시받기",
                        textScaleFactor: 1,
                        style: TextStyle(fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : null,
              backgroundColor: Color(0xff191919),
              body: hasYourChoom == null
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("LOADING",
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: const Color(0xffffffff),
                              fontFamily: "w500",
                              fontStyle: FontStyle.normal,
                              fontSize: size.getWidthPx(17),
                            ),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: size.getWidthPx(30),
                        ),
                        Lottie.asset('assets/lottiejson/progress_AI.json', width: size.getWidthPx(120)),
                        SizedBox(
                          height: size.getWidthPx(30),
                        ),
                        Text("취향을 분석하여 \n당신의 심장을 저격할 \n댄스를 추천합니다.",
                            textScaleFactor: 1,
                            style: TextStyle(color: const Color(0xffffffff), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                            textAlign: TextAlign.center)
                      ],
                    ))
                  : hasYourChoom && suggestionList.length != 0
                      ? Container(
                          child: ListView(
                          children: suggestionList,
                        ))
                      : Container(
                          width: size.screenSize.width,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "내가 좋아하는 춤을 찾기",
                                textScaleFactor: 1,
                                style:
                                    TextStyle(color: const Color(0xffffffff), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                              ),
                              SizedBox(
                                height: size.getWidthPx(15),
                              ),
                              Text(
                                "아직 My Choom에서 추천 받은 영상이 없습니다.",
                                textScaleFactor: 1,
                                style:
                                    TextStyle(color: const Color(0xffffffff), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(10)),
                              ),
                              SizedBox(
                                height: size.getWidthPx(15),
                              ),
                              InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(builder: (context) => SuggestionMain());
                                  Navigator.push(context, route).then((value) {
                                    print(value);
                                    if (value != null) {
                                      setState(() {
                                        c1 = value;

                                        checkYourChoom();
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: size.getWidthPx(177),
                                  height: size.getWidthPx(45),
                                  decoration: BoxDecoration(border: Border.all(color: const Color(0xffffffff), width: 1)),
                                  child: Text("My Choom 추천받기",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "SpoqaHanSansNeo",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(16)),
                                      textAlign: TextAlign.left),
                                ),
                              )
                            ],
                          ),
                        )),
        ));
  }

  checkYourChoom() {
    setState(() {
      hasYourChoom = null;
    });
    Timer timer = new Timer(Duration(seconds: 2), () {
      FirebaseFirestore.instance.collection("Data").doc("KmeanElements").get().then((kmeanselement) {
        for (int i = 0; i < 10; i++) {
          double disx = 0;
          double disy = 0;
          double ess = 0;
          double xc = 0;
          double yc = 0;

          for (var item in kmeanselement.data()['element']) {
            if ((c1[0] - item['x']).abs() <= 0.08) {
              disx += (c1[0] - item['x']);
              xc += 1;
            }
            if ((c1[1] - item['y']).abs() <= 0.08) {
              disy += (c1[1] - item['y']);
              yc += 1;
            }

            ess += (c1[0] - item['x']).abs() + (c1[1] - item['y']).abs();
          }
          if (xc != 0) {
            disx = disx / xc;
          }
          if (yc != 0) {
            disy = disy / yc;
          }
          xc = 0;
          yc = 0;
          c1[0] -= disx;
          c1[1] -= disy;
          print(disx);
          print("ess : " + ess.toString());
          ess = 0;
          disx = 0;
          disy = 0;
          print(c1);
        }
        for (var item in kmeanselement.data()['element']) {
          if ((c1[0] - item['x']).abs() <= 0.15) {
            if ((c1[1] - item['y']).abs() <= 0.15) {
              suggestionname.add({"name": item['name'], "score": (c1[1] - item['y']).abs()});
              print(item);
              print('????');
              print((c1[1] - item['y']).abs());
            }
          }
        }

        setState(() {
          FirebaseFirestore.instance.collection("Dance").get().then((value) {
            var c = 0;
            value.docs.forEach((element) {
              element.data()['element'].forEach((data) {
                print(data['musicname']);
                print(suggestionname.indexWhere((element) => element['name'] == data['musicname']));
                if (suggestionname.indexWhere((element) => element['name'] == data['musicname']) != -1) {
                  setState(() {
                    //print();

                    suggestionList.add(Container(
                        padding: EdgeInsets.symmetric(vertical: size.getWidthPx(0)),
                        width: size.screenSize.width,
                        height: size.getWidthPx(230),
                        child: CarouselSlider.builder(
                            options: CarouselOptions(
                              onPageChanged: (index, reason) {},
                              height: double.infinity,
                              enableInfiniteScroll: false,
                              viewportFraction: 1.0,
                            ),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(20), vertical: size.getWidthPx(10)),
                                    child: Text(
                                      '당신과 찰떡궁합 지수 ' +
                                          ((100 -
                                                      (suggestionname[suggestionname.indexWhere((element) => element['name'] == data['musicname'])]['score'] /
                                                              0.15) *
                                                          100)
                                                  .round())
                                              .toString() +
                                          "점",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "SpoqaHanSansNeo",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(20)),
                                    ),
                                  ),
                                  choomitem(data)
                                ],
                              );
                            })));
                    c += 1;
                  });

                  print(data);
                }
              });
            });
            hasYourChoom = true;
          });
        });
      });
    });
  }

  choomitem(element) {
    return InkWell(
        onTap: () {
          showbottomsheet(element);
        },
        child: FutureBuilder(
          future: DefaultCacheManager().getSingleFile(element['thumb']),
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: size.getWidthPx(20)),
              padding: EdgeInsets.all(10),
              width: size.screenSize.width,
              height: size.getWidthPx(180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.getWidthPx(10)),
                color: Colors.black,
                image: DecorationImage(image: snapshot.hasData ? FileImage(snapshot.data) : NetworkImage(element['thumb']), fit: BoxFit.fitHeight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(element['title'],
                              textScaleFactor: 1.0,
                              style: TextStyle(color: const Color(0xffffffff), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(16)),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Text(element['level'].toString(),
                              textScaleFactor: 1.0,
                              style: TextStyle(color: const Color(0xffffffff), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(14)),
                              textAlign: TextAlign.left)
                        ],
                      ),
                      element['isAI']
                          ? Container(
                              width: size.getWidthPx(32),
                              height: size.getWidthPx(32),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.getWidthPx(10)),
                                color: Color(0xffdd1dde),
                              ),
                              child: Text("AI",
                                  textScaleFactor: 1.0,
                                  style:
                                      TextStyle(color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(15)),
                                  textAlign: TextAlign.center),
                            )
                          : SizedBox()
                    ],
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        style: TextStyle(
                            color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(12), height: 1.5),
                        text: element['category'][0] + "\n"),
                    TextSpan(
                        style: TextStyle(
                            color: const Color(0xffffffff), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(12), height: 1.5),
                        text: element['musicname'] + "\n"),
                    TextSpan(
                        style: TextStyle(
                            color: const Color(0xffffffff), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(12), height: 1.5),
                        text: element['singer'])
                  ]))
                ],
              ),
            );
          },
        ));
  }

  showbottomsheet(element) {
    var dancer_ref = {"studio": "SWRV", "profileimage": ""};
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.getWidthPx(20))),
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(size.getWidthPx(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        element['category'][0],
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.166666507720947)), color: const Color(0xffe0e0e0)),
                          width: size.getWidthPx(20),
                          height: size.getWidthPx(20),
                          child: SvgPicture.asset(
                            'assets/images/icons/cancel_btn.svg',
                            width: size.getWidthPx(20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.screenSize.width,
                  height: size.getWidthPx(200),
                  color: Colors.red,
                  child: MiniVideo(
                    url: element['url'],
                    end: element['timeline'][1]['pos'],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(size.getWidthPx(15)),
                  width: size.screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(element['title'],
                          textScaleFactor: 1,
                          style: TextStyle(color: const Color(0xff000000), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: size.getWidthPx(15),
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            style: TextStyle(color: const Color(0xff5c5c5c), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                            text: element['musicname'] + "\n"),
                        TextSpan(
                            style: TextStyle(color: const Color(0xff5c5c5c), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(13)),
                            text: element['singer'])
                      ]))
                    ],
                  ),
                ),
                Container(
                  width: size.screenSize.width,
                  padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(15)),
                  child: Row(
                    children: [
                      FutureBuilder(
                          future: DefaultCacheManager().getSingleFile(element['dancerprofile']),
                          builder: (context, snapshot) {
                            return CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: size.getWidthPx(35),
                              backgroundImage: snapshot.hasData ? FileImage(snapshot.data) : NetworkImage(element['dancerprofile']),
                            );
                          }),
                      SizedBox(
                        width: size.getWidthPx(15),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(element['dancer'].toUpperCase(),
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff000000), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: size.getWidthPx(11),
                          ),
                          Text(element['studio'],
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff5c5c5c), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(13)),
                              textAlign: TextAlign.left),
                          InkWell(
                            onTap: () => launch('https://www.instagram.com/' + element['insta'] + '/'),
                            child: Text("@" + element['insta'],
                                textScaleFactor: 1,
                                style: TextStyle(color: Colors.blue, fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(13)),
                                textAlign: TextAlign.left),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.getWidthPx(15), horizontal: size.getWidthPx(20)),
                  width: size.screenSize.width,
                  height: size.getWidthPx(75),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Color(0xffededed)), bottom: BorderSide(color: Color(0xffededed)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("레벨",
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff817d7d), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(10)),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Text(element['level'].toString(),
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff000000), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                              textAlign: TextAlign.center)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("강의장르",
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff817d7d), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(10)),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Text(element['teachcategory'],
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff000000), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                              textAlign: TextAlign.center)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("강의시간",
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff817d7d), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(10)),
                              textAlign: TextAlign.left),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Text(element['runtime'],
                              textScaleFactor: 1,
                              style: TextStyle(color: const Color(0xff000000), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                              textAlign: TextAlign.center)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.getWidthPx(20), vertical: size.getWidthPx(10)),
                  width: size.screenSize.width,
                  height: size.getWidthPx(75),
                  child: element['isAI'] == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  listenBasicClass(element);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: size.getWidthPx(150),
                                  height: size.getWidthPx(55),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(size.getWidthPx(10))),
                                      boxShadow: [
                                        BoxShadow(color: const Color(0x34000000), offset: Offset(5, 5), blurRadius: size.getWidthPx(10), spreadRadius: 0)
                                      ],
                                      color: const Color(0xffffffff)),
                                  child: Text("클래스 수강하기",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xffdd1dde),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "SpoqaHanSansNeo",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(14)),
                                      textAlign: TextAlign.center),
                                )),
                            FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  print('object');
                                  Navigator.pop(context);
                                  // Route route = MaterialPageRoute(
                                  //     builder: (context) => AiCladssView(
                                  //           url: element['aiurl'],
                                  //           title: element['musicname'],
                                  //           start: element['start'],
                                  //           end: element['end'],
                                  //           bpm: element['bpm'],
                                  //         ));
                                  // Navigator.push(context, route);

                                  Route route = MaterialPageRoute(
                                      builder: (context) => ChecklistWidget(
                                            url: element['aiurl'],
                                            title: element['musicname'],
                                            start: element['start'],
                                            end: element['end'],
                                            bpm: element['bpm'],
                                          ));
                                  Navigator.pushReplacement(context, route);
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: size.getWidthPx(150),
                                    height: size.getWidthPx(55),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(size.getWidthPx(10))),
                                        boxShadow: [
                                          BoxShadow(color: const Color(0x34000000), offset: Offset(5, 5), blurRadius: size.getWidthPx(10), spreadRadius: 0)
                                        ],
                                        color: const Color(0xffffffff)),
                                    child: Text("The Choom AI",
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: const Color(0xffdd1dde),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "SpoqaHanSansNeo",
                                            fontStyle: FontStyle.normal,
                                            fontSize: size.getWidthPx(14)),
                                        textAlign: TextAlign.center)))
                          ],
                        )
                      : FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            listenBasicClass(element);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.screenSize.width,
                            height: size.getWidthPx(55),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(size.getWidthPx(10))),
                                boxShadow: [BoxShadow(color: const Color(0x34000000), offset: Offset(5, 5), blurRadius: size.getWidthPx(10), spreadRadius: 0)],
                                color: const Color(0xffffffff)),
                            child: Text("클래스 수강하기",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: const Color(0xffdd1dde),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "SpoqaHanSansNeo",
                                    fontStyle: FontStyle.normal,
                                    fontSize: size.getWidthPx(14)),
                                textAlign: TextAlign.center),
                          )),
                ),
              ],
            ),
          );
        });
  }

  changeGenreToDouble(String string) {
    if (string == "K-POP") {
      c1.add(0.25);
    } else if (string == "HIP HOP") {
      c1.add(0.5);
    } else if (string == "Choreography") {
      c1.add(0.75);
    }
  }

  changeAgeToDouble(String string) {
    if (string == "10대") {
      c1.add(0.25);
    } else if (string == "20대") {
      c1.add(0.5);
    } else if (string == "30대") {
      c1.add(0.75);
    } else if (string == "40대 이상") {
      c1.add(1);
    }
  }

  checkCurrentUser() {
    print(FirebaseAuth.instance.currentUser);
    var firebaseuser = FirebaseAuth.instance.currentUser;

    if (firebaseuser == null) {
      var kakaouser = UserApi.instance.me();
      kakaouser.then((value) {
        setState(() {
          uid = value.id.toString();
        });
      });
    } else {
      setState(() {
        uid = firebaseuser.uid;
      });
    }
  }

  listenBasicClass(element) {
    print("씨발fffffffffffffffffffffffffffffff");
    print(element['runtime']);
    int time = (int.parse(element['runtime'].split(':')[0]) * 60) + int.parse(element['runtime'].split(':')[1]);
    FirebaseFirestore.instance.collection('Users').doc(uid).get().then((value) {
      int index = value.data()['listeningclass'].indexWhere((item) => item['title'] == element['title']);
      if (index != -1) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(
            builder: (context) => BasicClassView(
                url: element['url'],
                timeline: element['timeline'],
                title: element['title'],
                end: time,
                bookmark: value.data()['listeningclass'][index]['bookmark']));
        Navigator.push(context, route);
      } else {
        FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'listeningclass': FieldValue.arrayUnion([
            {"title": element['title'], "bookmark": 0}
          ])
        }, SetOptions(merge: true)).then((value) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(
              builder: (context) => BasicClassView(url: element['url'], timeline: element['timeline'], title: element['title'], end: time, bookmark: 0));
          Navigator.push(context, route);
        });
      }
    });
  }
}

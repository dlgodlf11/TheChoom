import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/ui_home/danceclass/noneAI.dart';
import 'package:thechoom/ui_home/danceclass/useAI.dart';
import 'package:thechoom/ui_home/danceclass/useaiwidget/checklist.dart';
import 'package:thechoom/ui_home/minivideo.dart';
import 'package:thechoom/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UiHome extends StatefulWidget {
  @override
  _UiHomeState createState() => _UiHomeState();
}

class _UiHomeState extends State<UiHome> {
  Screen size;
  String uid;
  List<Map<String, dynamic>> choom_ref;
  var current = [0, 0, 0, 0];
  @override
  void initState() {
    print('object');
    choom_ref = [];
    FirebaseFirestore.instance.collection('Dance').get().then((documents) {
      print("Asdf");

      documents.docs.forEach((element) {
        print(element);
        var dancedata = {element.id: element.data()['element']};
        choom_ref.add(dancedata);
        print(choom_ref);
      });
    });
    checkCurrentUser();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Scaffold(
      backgroundColor: Color(0xff191919),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Dance').snapshots(),
        builder: (context, snapshot) {
          print('tlqk');
          if (snapshot.hasData) {
            print(snapshot.data.docs);
          }
          return !snapshot.hasData
              ? Center(
                  child: Lottie.asset(
                    'assets/lottiejson/progress_nor.json',
                    width: size.getWidthPx(110),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(size.getWidthPx(15)),
                  child: ListView(
                    children: [
                      for (int di = 0; di < snapshot.data.docs.length; di++) items(snapshot.data.docs[di], di)
                      // for (var item in snapshot.data.docs)
                    ],
                  ));
        },
      ),
    );
  }

  items(var item, docindex) {
    return Container(
      margin: EdgeInsets.only(bottom: size.getWidthPx(0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.id,
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                  fontFamily: "SpoqaHanSansNeo",
                  fontStyle: FontStyle.normal,
                  fontSize: size.getWidthPx(20)),
              textAlign: TextAlign.left),
          Container(
              padding: EdgeInsets.symmetric(vertical: size.getWidthPx(10)),
              width: size.screenSize.width,
              height: size.getWidthPx(200),
              child: Stack(
                children: [
                  Positioned(
                    child: CarouselSlider.builder(
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              current[docindex] = index;
                            });
                          },
                          height: double.infinity,
                          enableInfiniteScroll: true,
                          viewportFraction: 1.0,
                        ),
                        itemCount: item.data()['element'].length,
                        itemBuilder: (context, index) {
                          return choomitem(item.data()['element'][index]);
                        }),
                  ),
                  Positioned(
                      bottom: size.getWidthPx(0),
                      right: size.getWidthPx(10),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        width: size.screenSize.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: item.data()['element'].map<Widget>((url) {
                            print('씨발');
                            print(item.data()['element'].indexWhere((element) => element['url'] == url['url']));
                            int index = item.data()['element'].indexWhere((element) => element['url'] == url['url']);

                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: current[docindex] == index ? Color(0xffce1bcf) : Colors.white.withOpacity(0.5),
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ],
              ))
        ],
      ),
    );
  }

  choomitem(element) {
    print(element);
    return InkWell(
        onTap: () {
          showbottomsheet(element);
        },
        child: FutureBuilder(
          future: DefaultCacheManager().getSingleFile(element['thumb']),
          builder: (context, snapshot) {
            print(snapshot.data);
            return Container(
              margin: EdgeInsets.symmetric(horizontal: size.getWidthPx(2)),
              padding: EdgeInsets.all(12),
              width: size.screenSize.width,
              height: size.getWidthPx(180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.getWidthPx(10)),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
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
                                            bpm: ((60 / element['bpm']) * 1000).round().toInt(),
                                          ));
                                  Navigator.push(context, route);
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

  listenBasicClass(element) {
    print(uid);
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
            {
              "title": element['title'],
              "bookmark": 0,
              "url": element["url"],
              "timeline": element['timeline'],
              "end": time,
              "isfinish": false,
              "duration": 0,
              'profile': element['dancerprofile']
            }
          ])
        }, SetOptions(merge: true)).then((value) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(
              builder: (context) => BasicClassView(
                    url: element['url'],
                    timeline: element['timeline'],
                    title: element['title'],
                    end: time,
                    bookmark: 0,
                  ));
          Navigator.push(context, route);
        });
      }
    });
  }
}

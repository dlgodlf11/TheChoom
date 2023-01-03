import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/loginhome/loginedhome.dart';
import 'package:thechoom/ui_home/danceclass/noneAI.dart';
import 'package:thechoom/utils/utils.dart';

class FinishClass extends StatefulWidget {
  @override
  _FinishClassState createState() => _FinishClassState();
}

class _FinishClassState extends State<FinishClass> {
  Screen size;
  String uid = null;

  checkCurrentUser() {
    var firebaseuser = FirebaseAuth.instance.currentUser;

    if (firebaseuser == null) {
      var kakaouser = UserApi.instance.me();
      kakaouser.then((value) {
        setState(() {
          uid = value.id.toString();
        });
        print(uid);
      });
    } else {
      setState(() {
        uid = firebaseuser.uid;
        print(uid);
      });
    }
  }

  @override
  void initState() {
    checkCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
      color: Color(0xff191919),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff191919),
          appBar: appbar(),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data['listeningclass'].length);
                if (snapshot.data['listeningclass']
                        .indexWhere((element) => element['isfinish'] == true) ==
                    -1) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontFamily: "w100",
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.getWidthPx(17)),
                                  text: "춤쟁이로 거듭나 볼까요?\n\n\n"),
                              TextSpan(
                                  style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontFamily: "w500",
                                      fontStyle: FontStyle.normal,
                                      fontSize: size.getWidthPx(10)),
                                  text: "아직 시청하신 영상이 없습니다.\n\n\n")
                            ])),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              homeState.changeCurrentTab(0);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.getWidthPx(176),
                              height: size.getWidthPx(45),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffffffff),
                                      width: 1)),
                              child: Text("더춤 영상보러가기",
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "SpoqaHanSansNeo",
                                    fontStyle: FontStyle.normal,
                                    fontSize: size.getWidthPx(17),
                                  ),
                                  textAlign: TextAlign.left),
                            ))
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data['listeningclass'].length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => BasicClassView(
                                  url: snapshot.data['listeningclass'][index]
                                      ['url'],
                                  timeline: snapshot.data['listeningclass']
                                      [index]['timeline'],
                                  title: snapshot.data['listeningclass'][index]
                                      ['title'],
                                  end: 0,
                                  bookmark: snapshot.data['listeningclass']
                                      [index]['bookmark']));
                          Navigator.push(context, route);
                        },
                        child: Column(
                          children: [
                            snapshot.data['listeningclass'][index]['isfinish']
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getWidthPx(15)),
                                    width: size.screenSize.width,
                                    height: size.getWidthPx(60),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FutureBuilder(
                                                future: DefaultCacheManager()
                                                    .getSingleFile(snapshot
                                                                .data[
                                                            'listeningclass']
                                                        [index]['profile']),
                                                builder: (context, snapshot) {
                                                  return Container(
                                                      width:
                                                          size.getWidthPx(40),
                                                      height:
                                                          size.getWidthPx(40),
                                                      decoration: BoxDecoration(
                                                          image: snapshot
                                                                  .hasData
                                                              ? DecorationImage(
                                                                  image: FileImage(
                                                                      snapshot
                                                                          .data))
                                                              : null,
                                                          color: Colors.black));
                                                }),
                                            SizedBox(
                                              width: size.getWidthPx(20),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data[
                                                          'listeningclass']
                                                      [index]['title'],
                                                  textScaleFactor: 1,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xffffffff),
                                                      fontFamily: "w100",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize:
                                                          size.getWidthPx(14)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                : SizedBox(),
                          ],
                        ),
                      );
                    },
                  );
                }
              } else {
                return Lottie.asset('assets/lottiejson/progress_nor.json',
                    width: size.getWidthPx(130), height: size.getWidthPx(130));
              }
            },
          ),
        ),
      ),
    );
  }

  appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        iconTheme: new IconThemeData(
          color: Colors.black,
          size: 24,
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/images/icons/back_btn.svg',
              color: Color(0xffcb1acc),
              width: size.getWidthPx(26),
            ),
          );
        }),
        elevation: 0,
        backgroundColor: Color(0xff191919),
        title: Text(
          "수강 완료한 클래스",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: const Color(0xffcb0ccc),
              fontFamily: "w700",
              fontStyle: FontStyle.normal,
              fontSize: size.getWidthPx(17)),
        ),
        centerTitle: false,
      ),
    );
  }
}

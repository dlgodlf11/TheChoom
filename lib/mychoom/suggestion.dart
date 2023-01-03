import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:thechoom/utils/utils.dart';

class SuggestionMain extends StatefulWidget {
  @override
  _SuggestionMainState createState() => _SuggestionMainState();
}

class _SuggestionMainState extends State<SuggestionMain> {
  Screen size;
  var age = "나이대가 어떻게 되시나요?";
  var gender = "성별은 어떻게 되시나요?";
  var genre = "선호하는 춤의 장르가 있으신가요?";
  var lev = "당신의 댄스 레벨은 몇 단계라고 생각하세요?";
  var c1 = [];
  // @override
  // void initState() {
  //   if (FirebaseAuth.instance.currentUser == null) {
  //     UserApi.instance.me().then((value) {});
  //   } else {
  //     FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get()
  //         .then((value) {
  //       setState(() {

  //       });
  //     });
  //   }
  //   super.initState();
  // }
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

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
      color: Color(0xff191919),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xff191919),
            appBar: appbar(),
            body: Container(
                padding: EdgeInsets.all(size.getWidthPx(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        items(
                            ontap: () {
                              showAgebottomsheet(['10대', '20대', '30대', '40대 이상']);
                            },
                            text: age),
                        SizedBox(
                          height: size.getWidthPx(16),
                        ),
                        items(
                            ontap: () {
                              showGenderbottomsheet(['남', '여']);
                            },
                            text: gender),
                        SizedBox(
                          height: size.getWidthPx(16),
                        ),
                        items(
                            ontap: () {
                              showGenrebottomsheet(
                                ['K-POP', 'HIP HOP', 'Choreography'],
                              );
                            },
                            text: genre),
                        SizedBox(
                          height: size.getWidthPx(16),
                        ),
                        items(
                            ontap: () {
                              showLevbottomsheet(
                                ["입문", "초급", "중급", "고급"],
                              );
                            },
                            text: lev),
                        SizedBox(
                          height: size.getWidthPx(16),
                        ),
                        Container(
                            padding: EdgeInsets.all(
                              size.getWidthPx(10),
                            ),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  style:
                                      TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(10)),
                                  text: "About\n"),
                              TextSpan(
                                  style:
                                      TextStyle(color: const Color(0xffffffff), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(13)),
                                  text: "My Choom은 간단한 질문으로 당신에게 꼭 맞는 댄스 강의를 추천하는 인공지능 컨텐츠입니다.")
                            ]))),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (age == "나이대가 어떻게 되시나요?" || gender == "성별은 어떻게 되시나요?" || genre == "선호하는 춤의 장르가 있으신가요?" || lev == "당신의 댄스 레벨은 몇 단계라고 생각하세요?") {
                        } else {
                          print('너머간다');
                          if (FirebaseAuth.instance.currentUser == null) {
                            print('너머간다2');
                            UserApi.instance.me().then((value) {
                              print('너머간다4');
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(value.id.toString())
                                  .set({"age": age, "gender": gender, "category": genre, "level": lev}, SetOptions(merge: true)).then((value) {
                                changeGenreToDouble(genre);
                                changeAgeToDouble(age);
                                Navigator.pop(context, c1);
                              });
                            });
                          } else {
                            print('너머간다3');
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .set({"age": age, "gender": gender, "category": genre, "level": lev}, SetOptions(merge: true)).then((value) {
                              changeGenreToDouble(genre);
                              changeAgeToDouble(age);
                              Navigator.pop(context, c1);
                            });
                          }
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        alignment: Alignment.center,
                        width: size.screenSize.width,
                        height: size.getWidthPx(50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: age == "나이대가 어떻게 되시나요?" || gender == "성별은 어떻게 되시나요?" || genre == "선호하는 춤의 장르가 있으신가요?" || lev == "당신의 댄스 레벨은 몇 단계라고 생각하세요?"
                                ? const Color(0xff707070)
                                : Color(0xffdd1dde)),
                        child: Text("My Choom 시작하기",
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: const Color(0xff191919),
                                fontWeight: FontWeight.w700,
                                fontFamily: "SpoqaHanSansNeo",
                                fontStyle: FontStyle.normal,
                                fontSize: size.getWidthPx(17)),
                            textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  items({ontap, text}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(15)),
        width: size.screenSize.width,
        height: size.getWidthPx(45),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: text == "나이대가 어떻게 되시나요?" || text == "성별은 어떻게 되시나요?" || text == "선호하는 춤의 장르가 있으신가요?" || text == "당신의 댄스 레벨은 몇 단계라고 생각하세요?"
                    ? const Color(0xff707070)
                    : Color(0xffdd1dde),
                width: 2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                textScaleFactor: 1,
                style: TextStyle(
                    color: text == "나이대가 어떻게 되시나요?" || text == "성별은 어떻게 되시나요?" || text == "선호하는 춤의 장르가 있으신가요?" || text == "당신의 댄스 레벨은 몇 단계라고 생각하세요?"
                        ? const Color(0xff707070)
                        : Color(0xffdd1dde),
                    fontFamily: "w300",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(13)),
                textAlign: TextAlign.left),
            Icon(Icons.arrow_drop_up, color: Color(0xff707070), size: size.getWidthPx(30))
          ],
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
            color: Color(0xffcb0ccc),
          );
        }),
        elevation: 0,
        backgroundColor: Color(0xff191919),
        title: Text(
          "My Choom 추천받기",
          textScaleFactor: 1.0,
          style: TextStyle(color: const Color(0xffcb0ccc), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
        ),
        centerTitle: false,
      ),
    );
  }

  showLevbottomsheet(element) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xff191919),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.getWidthPx(20))),
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                Container(
                  width: size.screenSize.width,
                  padding: EdgeInsets.all(size.getWidthPx(20)),
                  child: Text("댄스레벨 선택하기",
                      textScaleFactor: 1,
                      style: TextStyle(color: const Color(0xff707070), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      lev = element[0];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[0].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      lev = element[1];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[1].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      lev = element[2];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[2].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      lev = element[3];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[3].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text("닫기",
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showGenrebottomsheet(element) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xff191919),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.getWidthPx(20))),
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                Container(
                  width: size.screenSize.width,
                  padding: EdgeInsets.all(size.getWidthPx(20)),
                  child: Text("선호하는 장르",
                      textScaleFactor: 1,
                      style: TextStyle(color: const Color(0xff707070), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      genre = element[0];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[0].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      genre = element[1];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[1].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      genre = element[2];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[2].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text("닫기",
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showGenderbottomsheet(element) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xff191919),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.getWidthPx(20))),
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                Container(
                  width: size.screenSize.width,
                  padding: EdgeInsets.all(size.getWidthPx(20)),
                  child: Text("성별 선택하기",
                      textScaleFactor: 1,
                      style: TextStyle(color: const Color(0xff707070), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gender = element[0];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[0].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gender = element[1];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[1].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text("닫기",
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showAgebottomsheet(element) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xff191919),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.getWidthPx(20))),
        builder: (context) {
          return Container(
            child: Wrap(
              children: [
                Container(
                  width: size.screenSize.width,
                  padding: EdgeInsets.all(size.getWidthPx(20)),
                  child: Text("나이 선택하기",
                      textScaleFactor: 1,
                      style: TextStyle(color: const Color(0xff707070), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      age = element[0];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[0].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      age = element[1];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[1].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      age = element[2];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[2].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      age = element[3];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text(element[3].toString(),
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.screenSize.width,
                    padding: EdgeInsets.all(size.getWidthPx(20)),
                    child: Text("닫기",
                        textScaleFactor: 1,
                        style: TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

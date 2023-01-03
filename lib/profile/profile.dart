import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_version/get_version.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:thechoom/login/loginmain.dart';
import 'package:thechoom/profile/dropuser.dart';
import 'package:thechoom/profile/finishclasslist.dart';
import 'package:thechoom/profile/listenclasslist.dart';
import 'package:thechoom/profile/notice.dart';
import 'package:thechoom/profile/qna.dart';
import 'package:thechoom/utils/showalert.dart';
import 'package:thechoom/utils/utils.dart';

class ProfileMenu extends StatefulWidget {
  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  Screen size;
  var appversion = "확인중";
  ShowAlert showAlert;

  @override
  void initState() {
    // TODO: implement initState

    // UserApi.instance.me().then((value) {
    //   print(value.id);
    // });
    GetVersion.projectVersion.then((value) {
      setState(() {
        appversion = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    showAlert = new ShowAlert();
    return Scaffold(
      body: Container(
        width: size.screenSize.width,
        color: Color(0xff191919),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
              alignment: Alignment.centerLeft,
              width: size.screenSize.width,
              height: size.getWidthPx(45),
              child: Text("히스토리",
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: const Color(0xffdd1dde),
                      fontFamily: "w700",
                      fontStyle: FontStyle.normal,
                      fontSize: size.getWidthPx(17)),
                  textAlign: TextAlign.left),
            ),
            InkWell(
              onTap: () {
                Route route =
                    MaterialPageRoute(builder: (context) => ListeningClass());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/now_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("수강중인 클래스",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Route route =
                    MaterialPageRoute(builder: (context) => FinishClass());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/finish_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("수강 완료한 클래스",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
              alignment: Alignment.centerLeft,
              width: size.screenSize.width,
              height: size.getWidthPx(45),
              child: Text("앱 설정",
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: const Color(0xffdd1dde),
                      fontFamily: "w700",
                      fontStyle: FontStyle.normal,
                      fontSize: size.getWidthPx(17)),
                  textAlign: TextAlign.left),
            ),
            InkWell(
              onTap: () {
                showAlert.showalert(
                    context: context,
                    title: "더춤 고객센터",
                    text:
                        '궁금한 점은 자주묻는 질문에서\n먼저 확인해 주세요. 이외 문의 사항은\ncontact@swerve.kr로 문의해 주세요.',
                    size: size);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/Counseling_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("고객센터",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Route route = MaterialPageRoute(builder: (context) => Notice());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/notice_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("공지사항",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Route route = MaterialPageRoute(builder: (context) => QnA());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/FQA_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("자주묻는 질문",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showAlert.showalert(
                    context: context,
                    istwobutton: true,
                    size: size,
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        UserApi.instance.logout().then((value) {
                          AccessTokenStore.instance.clear();

                          Route route = MaterialPageRoute(
                              builder: (context) => Loginmain());
                          Navigator.pushReplacement(context, route);
                        });
                      } else {
                        FirebaseAuth.instance.signOut().then((value) {
                          Route route = MaterialPageRoute(
                              builder: (context) => Loginmain());
                          Navigator.pushReplacement(context, route);
                        });
                      }
                    },
                    secondbuttontext: "로그아웃",
                    text:
                        "정말 로그아웃 하시겠습니까?\n다시 로그인 하실 때, 가입한 계정으로\n로그인 하시길 바랍니다.",
                    title: "The Choom 로그아웃");

                // if (FirebaseAuth.instance.currentUser == null) {
                //   UserApi.instance.logout().then((value) {
                //     AccessTokenStore.instance.clear();

                //     Route route =
                //         MaterialPageRoute(builder: (context) => Loginmain());
                //     Navigator.pushReplacement(context, route);
                //   });
                // } else {
                //   FirebaseAuth.instance.signOut().then((value) {
                //     Route route =
                //         MaterialPageRoute(builder: (context) => Loginmain());
                //     Navigator.pushReplacement(context, route);
                //   });
                // }

                // UserApi.instance.logout().then((value) {
                //   AccessTokenStore.instance.clear();

                //   Route route =
                //       MaterialPageRoute(builder: (context) => Loginmain());
                //   Navigator.pushReplacement(context, route);
                // }).catchError((e) {
                //   print(e);
                //   FirebaseAuth.instance.signOut().then((value) {
                //     Route route =
                //         MaterialPageRoute(builder: (context) => Loginmain());
                //     Navigator.pushReplacement(context, route);
                //   });
                // });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/logout_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("로그아웃",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Route route =
                    MaterialPageRoute(builder: (context) => DeleteUserPage());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icons/withdrawal_img.svg',
                      color: Color(0xffcb1acc),
                      width: size.getWidthPx(16),
                    ),
                    SizedBox(
                      width: size.getWidthPx(16),
                    ),
                    Text("회원탈퇴",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w300",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                width: size.screenSize.width,
                height: size.getWidthPx(45),
                decoration: BoxDecoration(color: const Color(0xff222222)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/ver_img.svg',
                          color: Color(0xffcb1acc),
                          width: size.getWidthPx(16),
                        ),
                        SizedBox(
                          width: size.getWidthPx(16),
                        ),
                        Text("The Choom 버젼",
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: const Color(0xffffffff),
                                fontFamily: "w300",
                                fontStyle: FontStyle.normal,
                                fontSize: size.getWidthPx(13)),
                            textAlign: TextAlign.left)
                      ],
                    ),
                    Text(appversion,
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w700",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(13)),
                        textAlign: TextAlign.left)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

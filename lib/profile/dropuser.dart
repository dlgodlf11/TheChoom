import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/all.dart';

import 'package:thechoom/login/loginmain.dart';
import 'package:thechoom/loginhome/loginedhome.dart';
import 'package:thechoom/utils/showalert.dart';
import 'package:thechoom/utils/utils.dart';

class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  Screen size;
  String reason = "";
  TextEditingController typereason = new TextEditingController();
  ShowAlert showAlert;
  @override
  Widget build(BuildContext context) {
    showAlert = new ShowAlert();
    size = Screen(MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
        color: Color(0xff191919),
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Color(0xff191919),
            appBar: appbar(),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                padding: EdgeInsets.all(size.getWidthPx(30)),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(children: [
                              TextSpan(
                                  style:
                                      TextStyle(color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                                  text: homeState.name + "???!\n"),
                              TextSpan(
                                  style:
                                      TextStyle(color: const Color(0xff707070), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(20)),
                                  text: "????????? ?????? ??????????????????????")
                            ])),
                        SizedBox(
                          height: size.getWidthPx(20),
                        ),
                        Text("????????? ??????????????? ???????????? ?????????, My Choom ????????? ???, ???????????? ???????????? ??????????????? ???????????????. ???????????? ?????? ?????? ??? 14?????? ?????? ????????? ??? ?????????. ",
                            textScaleFactor: 1.0,
                            style: TextStyle(color: const Color(0xff707070), fontFamily: "w400", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(12)),
                            textAlign: TextAlign.left),
                        SizedBox(
                          height: size.getWidthPx(20),
                        ),
                        reasonWidget()
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showAlert.showalert(
                            context: context,
                            title: 'The Choom ????????????',
                            text: '?????? ?????? ?????????, ??????????????? ?????????\n?????? ?????? ?????????????\n?????? ?????? ???????????????????',
                            istwobutton: true,
                            secondbuttontext: '????????????',
                            onPressed: () {
                              Navigator.pop(context);
                              if (FirebaseAuth.instance.currentUser == null) {
                                UserApi.instance.me().then((value) {
                                  FirebaseFirestore.instance.collection('Users').doc(value.id.toString()).delete().then((value) {
                                    UserApi.instance.logout().then((value) {
                                      AccessTokenStore.instance.clear().then((value) {
                                        showAlert
                                            .showalert(
                                                context: context,
                                                title: 'The Choom ???????????? ??????',
                                                text: '?????? ????????? ?????????????????? ??????\n??????????????? ????????? ????????????????',
                                                istwobutton: false,
                                                size: size)
                                            .then((value) {
                                          Route route = MaterialPageRoute(builder: (context) => Loginmain());
                                          Navigator.pushReplacement(context, route);
                                        });
                                      });
                                    });
                                  });
                                });
                              } else {
                                FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.uid).delete().then((value) {
                                  FirebaseAuth.instance.currentUser.delete().then((value) {
                                    showAlert
                                        .showalert(
                                            context: context,
                                            title: 'The Choom ???????????? ??????',
                                            text: '?????? ????????? ?????????????????? ??????\n??????????????? ????????? ????????????????',
                                            istwobutton: false,
                                            size: size)
                                        .then((value) {
                                      Route route = MaterialPageRoute(builder: (context) => Loginmain());
                                      Navigator.pushReplacement(context, route);
                                    });
                                  });
                                });
                              }
                            },
                            size: size);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: size.getWidthPx(60),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: const Color(0xffdd1dde)),
                          child: Text("The Choom ????????????",
                              textScaleFactor: 1.0,
                              style: TextStyle(color: Color(0xff191919), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                              textAlign: TextAlign.center)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        iconTheme: new IconThemeData(
          color: Color(0xffdd1dde),
          size: 24,
        ),
        elevation: 0,
        backgroundColor: Color(0xff191919),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/icons/back_btn.svg',
            color: Color(0xffcb1acc),
            width: size.getWidthPx(26),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          '????????????',
          textScaleFactor: 1.0,
          style: TextStyle(color: Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(21)),
        ),
        centerTitle: false,
      ),
    );
  }

  Widget reasonWidget() {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.getWidthPx(20))),
              builder: (context) {
                return Container(
                  child: Wrap(
                    children: [
                      ListTile(
                        title: Text(
                          '?????? ?????? ????????????',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: const Color(0xff707070), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            reason = '????????? ????????? ????????????.';
                            Navigator.pop(context);
                          });
                        },
                      ),
                      ListTile(
                        title: Text(
                          '????????? ????????? ????????????.',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            reason = '????????? ????????? ????????????.';
                            Navigator.pop(context);
                          });
                        },
                      ),
                      ListTile(
                        title: Text(
                          '?????? ?????? ?????? ??? ???????????????.',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: const Color(0xff707070), fontFamily: "w100", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            reason = '?????? ?????? ?????? ??? ???????????????.';
                            Navigator.pop(context);
                          });
                        },
                      ),
                      ListTile(
                        title: Text(
                          '??????',
                          textScaleFactor: 1.0,
                          style: TextStyle(color: const Color(0xffdd1dde), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reason == "" ? '????????? ????????? ??????????????????.' : reason,
                    textScaleFactor: 1.0,
                    style:
                        TextStyle(color: const Color(0xff707070), fontFamily: "AppleSDGothicNeoUL", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(13)),
                  ),
                  // SvgPicture.asset(
                  //   'assets/signuppage/img_bottomesheet.svg',
                  //   width: size.getWidthPx(14),
                  // ),
                ],
              ),
              SizedBox(
                height: size.getWidthPx(5),
              ),
              Divider(
                thickness: 1,
                color: Color(0xff898989),
              ),
              reason == "??????"
                  ? TextField(
                      controller: typereason,
                      decoration: InputDecoration(hintText: '??????????????? ??????????????????'),
                      style: TextStyle(
                          color: const Color(0xff707070),
                          fontFamily: "AppleSDGothicNeoUL",
                          fontStyle: FontStyle.normal,
                          fontSize: size.getWidthPx(13) * size.textscale),
                    )
                  : SizedBox()
            ],
          ),
        ));
  }
}

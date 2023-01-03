import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_id_request.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/login/forgotpassword.dart';
import 'package:thechoom/loginhome/loginedhome.dart';
import 'package:thechoom/signin/signinmain.dart';
import 'package:thechoom/tutorial/tutorial.dart';
import 'package:thechoom/utils/responsive_size.dart';
import 'package:thechoom/utils/showalert.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class Loginmain extends StatefulWidget {
  @override
  _LoginmainState createState() => _LoginmainState();
}

class _LoginmainState extends State<Loginmain> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  Screen size;
  ShowAlert showAlert;
  ScrollController scrollController = new ScrollController();
  TextEditingController _emailcoltroller = new TextEditingController();
  TextEditingController _pwcoltroller = new TextEditingController();
  AccessTokenStore _tokenStore;
  var kakaoinstalled = false;
  var name = "";
  int current_index = 1;
  bool isFirst = false;
  bool loading = false;
  bool isios = false;
  @override
  void initState() {
    _initKakaoTalkInstalled();
    _controller = VideoPlayerController.asset('assets/videos/intro_sample.mp4');
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {});
    });
    _controller.play();
    _checklogin();
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();

    super.dispose();
  }

  scroll_to_index(index) {
    setState(() {
      current_index = index;
      scrollController.animateTo(
          (current_index) * (MediaQuery.of(context).size.width),
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    });
  }

  _goToHome({String uid, String name}) {
    if (isFirst) {
      Route route = MaterialPageRoute(
          builder: (context) => TutorialPage(
                cancelbutton: false,
              ));
      Navigator.push(context, route).then((value) {
        Route route = MaterialPageRoute(
            builder: (context) => HomePage(
                  currentuserUid: uid,
                  name: name,
                ));
        Navigator.pushReplacement(context, route);
      });
    } else {
      Route route = MaterialPageRoute(
          builder: (context) => HomePage(
                currentuserUid: uid,
                name: name,
              ));
      Navigator.pushReplacement(context, route);
    }
  }

  appleloginios() async {
    setState(() {
      loading = true;
    });

    AuthorizationRequest authorizationRequest =
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName]);
    AuthorizationResult authorizationResult =
        await AppleSignIn.performRequests([authorizationRequest]);
    //         .catchError(() {
    //   setState(() {
    //     loading = false;
    //   });
    // });
    print(authorizationResult.status);
    if (authorizationResult.status != AuthorizationStatus.cancelled) {
      AppleIdCredential appleCredential = authorizationResult.credential;

      OAuthProvider provider = new OAuthProvider("apple.com");

      AuthCredential credential = provider.credential(
        idToken: String.fromCharCodes(appleCredential.identityToken),
        accessToken: String.fromCharCodes(appleCredential.authorizationCode),
      );

      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential authResult = await auth.signInWithCredential(credential);

// 인증에 성공한 유저 정보
      var user = authResult.user;
      print(user.uid);
      var firestore = FirebaseFirestore.instance.collection('Users');
      await firestore.doc(user.uid).get().then((data) {
        print(data.data());
        if (data.data() == null) {
          isFirst = true;
          FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
            "name": "apple-" + user.uid.substring(0, 5),
            "thumbnail_image": user.photoURL,
            "profile_image": user.photoURL,
            "type": "Google",
            "ID": user.uid,
            "listeningclass": [],
            "finishedclass": [],
            "email": user.email
          });
        }
      }).then((value) {
        setState(() {
          loading = false;
        });
        _goToHome(
            uid: FirebaseAuth.instance.currentUser.uid,
            name: "apple-" + user.uid.substring(0, 5));
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  _checklogin() async {
    AccessTokenStore.instance.fromStore().then((token) async {
      if (token.refreshToken == null) {
        print('구글로는 했니?');
        print(FirebaseAuth.instance.currentUser);
        if (FirebaseAuth.instance.currentUser != null) {
          if (FirebaseAuth.instance.currentUser.displayName != null) {
            await _goToHome(
                uid: FirebaseAuth.instance.currentUser.uid,
                name: FirebaseAuth.instance.currentUser.displayName);
          } else {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get()
                .then((value) async {
              await _goToHome(
                  uid: FirebaseAuth.instance.currentUser.uid,
                  name: value.data()['name']);
            });
          }
        }
        // Navigator.of(context).pushReplacementNamed('/login');
      } else {
        print('있다고');
        //.print(token.refreshToken);

        await UserApi.instance.me().then((value) async {
          //print(value.properties['nickname']);
          var firestore = FirebaseFirestore.instance.collection('Users');
          firestore.doc(value.id.toString()).get().then((data) {
            //print(data.data());
            if (data.data() == null) {
              isFirst = true;
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(value.id.toString())
                  .set({
                "name": value.properties['nickname'],
                "age":
                    (value.kakaoAccount.ageRange.index + 1).toString() + "0대",
                "gender": value.kakaoAccount.gender.index == 1 ? "남성" : "여성",
                "thumbnail_image": value.properties['thumbnail_image'],
                "profile_image": value.properties['profile_image'],
                "type": "Kakao",
                "ID": value.id.toString()
              });
            }
          });
          print('카카오 했니?');
          print(value.properties['nickname']);
          await _goToHome(
              uid: value.id.toString(), name: value.properties['nickname']);
        }).catchError((e) {});
        //Navigator.of(context).pushReplacementNamed("/main");
      }
    }).catchError((e) {
      print('히아');
    });
  }

  _initKakaoTalkInstalled() async {
    isKakaoTalkInstalled().then((value) {
      print('카카오깔림? :' + value.toString());
      setState(() {
        kakaoinstalled = value;
      });
    });
  }

  _issueAccessToken(String authCode) async {
    setState(() {
      loading = true;
    });
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);

      // var callable =
      //     await FirebaseFunctions.instance.httpsCallable('getCustomToken');
      // var resp =
      //     await callable.call(<String, dynamic>{'uid': token.refreshToken});
      // print('결과가 머야');
      // print(resp.data);
      // print('이거네?');
      // print(resp.data);
      var aa = Gender.FEMALE;
      print(aa.index);
      await UserApi.instance.me().then((value) async {
        var firestore = FirebaseFirestore.instance.collection('Users');
        firestore.doc(value.id.toString()).get().then((data) {
          //print(data.data());
          if (data.data() == null) {
            isFirst = true;
            FirebaseFirestore.instance
                .collection('Users')
                .doc(value.id.toString())
                .set({
              "name": value.properties['nickname'],
              "age": (value.kakaoAccount.ageRange.index + 1).toString() + "0대",
              "gender": value.kakaoAccount.gender.index == 1 ? "남성" : "여성",
              "thumbnail_image": value.properties['thumbnail_image'],
              "profile_image": value.properties['profile_image'],
              "type": "Kakao",
              "ID": value.id.toString(),
              "listeningclass": [],
              "finishedclass": []
            });
          }
        }).then((f) {
          setState(() {
            loading = false;
          });
          _goToHome(
              uid: value.id.toString(), name: value.properties['nickname']);
        });
      });

      print(token.accessToken);
    } catch (e) {
      print('시발 여기냐');
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  _googleSignIn() async {
    DateTime now = new DateTime.now();
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount account = await googleSignIn.signIn();
    var headers = await googleSignIn.currentUser.authHeaders;

    GoogleSignInAuthentication authentication = await account.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    await auth.signInWithCredential(credential).then((currentUser) {
      setState(() {
        loading = true;
      });
      var firestore = FirebaseFirestore.instance.collection('Users');
      firestore.doc(currentUser.user.uid).get().then((data) {
        //print(data.data());
        if (data.data() == null) {
          isFirst = true;
          FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.user.uid)
              .set({
            "name": currentUser.user.displayName,
            "age": null,
            "gender": null,
            "thumbnail_image": currentUser.user.photoURL,
            "profile_image": currentUser.user.photoURL,
            "type": "Google",
            "ID": currentUser.user.uid,
            "listeningclass": [],
            "finishedclass": []
          });
        }
      }).then((value) {
        setState(() {
          loading = false;
        });
        _goToHome(
            uid: FirebaseAuth.instance.currentUser.uid,
            name: FirebaseAuth.instance.currentUser.displayName);
      });
    }).catchError((e) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    showAlert = new ShowAlert();
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            color: Colors.grey[900],
            child: SafeArea(
                top: false,
                bottom: false,
                child: Scaffold(
                    backgroundColor: Colors.grey[900],
                    body: Stack(
                      children: [
                        Positioned(
                            child: Align(
                          alignment: Alignment.center,
                          child: VideoPlayer(_controller),
                        )),
                        Positioned.fill(
                            child: Container(
                          color: Colors.grey[900].withOpacity(0.8),
                        )),
                        Positioned.fill(
                            child: loading
                                ? Container(
                                    padding: EdgeInsets.all(100),
                                    child: Lottie.asset(
                                      'assets/lottiejson/progress_nor.json',
                                      width: size.getWidthPx(90),
                                    ),
                                  )
                                : ListView(
                                    controller: scrollController,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: [loginright(), loginleft()],
                                  )),
                        Positioned(
                            top: MediaQuery.of(context).padding.top,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: current_index != 0 ? 1.0 : 0,
                              child: Container(
                                width: size.screenSize.width,
                                height: size.getWidthPx(30),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.home,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      scroll_to_index(0);
                                    },
                                  ),
                                ),
                              ),
                            ))
                      ],
                    )))));
  }

  loginright() {
    return Container(
      width: size.screenSize.width,
      height: size.screenSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () async {
              _googleSignIn();
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                width: size.screenSize.width,
                alignment: Alignment.center,
                height: size.getWidthPx(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // border: Border.all(
                    //   color: const Color(0xfffe2eff),
                    //   width: 3,
                    // ),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/icons/google_img.svg",
                      width: size.getWidthPx(15),
                    ),
                    SizedBox(width: size.getWidthPx(8)),
                    Text("구글 계정으로 로그인하기",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "w700",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(14)),
                        textAlign: TextAlign.center),
                  ],
                )),
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () async {
              var code = await AuthCodeClient.instance.request();
              await _issueAccessToken(code);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              width: size.screenSize.width,
              alignment: Alignment.center,
              height: size.getWidthPx(50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //border: Border.all(color: const Color(0xfffe2eff), width: 3),
                  color: Color(0xfffae300)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/icons/kakaotalk_img.svg",
                    width: size.getWidthPx(15),
                  ),
                  SizedBox(width: size.getWidthPx(8)),
                  Text("카카오 계정으로 로그인하기",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "w700",
                          fontStyle: FontStyle.normal,
                          fontSize: size.getWidthPx(14)),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          Platform.isIOS
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  width: size.screenSize.width,
                  alignment: Alignment.center,
                  height: size.getWidthPx(50),
                  child: AppleSignInButton(
                    cornerRadius: 10,
                    onPressed: () {
                      appleloginios();
                    },
                  ),
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => SigninMain());
                    Navigator.push(context, route);
                  },
                  child: Container(
                    width: size.screenSize.width / 2.5,
                    alignment: Alignment.center,
                    height: size.getWidthPx(50),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     // border: Border.all(
                    //     //   color: const Color(0xfffe2eff),
                    //     //   width: 3,
                    //     // ),
                    //     color: Colors.white),
                    child: Text("회원가입 바로가기",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontFamily: "w700",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(14),
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center),
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    scroll_to_index(1);
                  },
                  child: Container(
                    width: size.screenSize.width / 2.5,
                    alignment: Alignment.center,
                    height: size.getWidthPx(50),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     // border: Border.all(
                    //     //   color: const Color(0xfffe2eff),
                    //     //   width: 3,
                    //     // ),
                    //     color: Colors.white),
                    child: Text("일반회원 로그인",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontFamily: "w700",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(14),
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Color(0xff707070),
            endIndent: size.getWidthPx(30),
            indent: size.getWidthPx(30),
          ),
          SizedBox(
            height: size.getWidthPx(53),
          ),
        ],
      ),
    );
  }

  loginleft() {
    return Container(
      width: size.screenSize.width,
      height: size.screenSize.height,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + size.getWidthPx(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              textfield(
                  placehoder: '이메일 계정 입력해 주세요', controller: _emailcoltroller),
              textfield(
                  placehoder: '비밀번호를 입력해 주세요',
                  controller: _pwcoltroller,
                  hidetext: true),
              longinbutton(),
              SizedBox(height: size.getWidthPx(35)),
              InkWell(
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => ForgotPassword());
                  Navigator.push(context, route);
                },
                child: Text("앗! 비밀번호를 잊어버리셨나요?",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: const Color(0xff707070),
                        fontFamily: "w700",
                        fontStyle: FontStyle.normal,
                        fontSize: size.getWidthPx(11),
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center),
              )
            ],
          ),
          SizedBox(
            height: size.getWidthPx(27),
          ),
          SizedBox(
            height: size.getWidthPx(53),
          ),
        ],
      ),
    );
  }

  textfield({placehoder, controller, hidetext = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      width: size.screenSize.width,
      height: size.getWidthPx(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Color(0xff707070), width: 1),
      ),
      child: CupertinoTextField(
        padding: EdgeInsets.only(left: size.getWidthPx(14)),
        obscureText: hidetext,
        controller: controller,
        placeholder: placehoder,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
        placeholderStyle: TextStyle(
            color: const Color(0xffb4b4b4),
            fontFamily: "w300",
            fontStyle: FontStyle.normal,
            fontSize: size.getWidthPx(16) * size.textscale),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontFamily: "w300",
            fontStyle: FontStyle.normal,
            fontSize: size.getWidthPx(16) * size.textscale),
      ),
    );
  }

  longinbutton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xfffe2eff),
      ),
      width: double.infinity,
      height: size.getWidthPx(50),
      child: FlatButton(
        child: Text("로그인",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "w700",
                fontStyle: FontStyle.normal,
                fontSize: size.getWidthPx(14)),
            textAlign: TextAlign.center),
        onPressed: () {
          setState(() {
            loading = true;
          });
          if (_emailcoltroller.text.length == 0 &&
              _pwcoltroller.text.length == 0) {
            showAlert.showalert(
                context: context,
                title: '로그인 오류',
                text: '이메일 또는\n비밀번호를 확인해 주세요',
                size: size);
            setState(() {
              loading = false;
            });
          } else {
            name = "더춤 회원";
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailcoltroller.text, password: _pwcoltroller.text)
                .then((value) {
              Route route = MaterialPageRoute(
                  builder: (context) => HomePage(
                        currentuserUid: '123123',
                      ));
              Navigator.pushReplacement(context, route);
            }).catchError((e) {
              showAlert.showalert(
                  context: context,
                  title: '로그인 오류',
                  text: '이메일 또는\n비밀번호를 확인해 주세요',
                  size: size);
              setState(() {
                loading = false;
              });
            });
          }
        },
      ),
    );
  }
}

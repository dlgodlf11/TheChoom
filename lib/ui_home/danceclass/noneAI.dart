import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:thechoom/utils/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BasicClassView extends StatefulWidget {
  final String url;
  final String title;
  final dynamic timeline;
  final int bookmark;
  final int end;
  BasicClassView({this.url, this.timeline, this.title, this.bookmark, this.end});

  @override
  _BasicClassViewState createState() => _BasicClassViewState();
}

class _BasicClassViewState extends State<BasicClassView> {
  Screen size;
  bool fullscreen = true;
  bool play = false;
  bool showspeed = false;
  bool showmenu = false;
  bool showmirror = false;
  bool showtimeline = false;
  double _currentSliderValue = 1.0;
  Timer timer;
  double opacity = 1.0;
  String uid;
  YoutubePlayerController _controller;
  var cameras;
  int end = 0;
  CameraController controller;

  @override
  void initState() {
    checkCurrentUser();
    _controller = YoutubePlayerController(
      initialVideoId: widget.url,
      flags: YoutubePlayerFlags(startAt: widget.bookmark, autoPlay: true, mute: false, loop: true),
    );

    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // TODO: implement dispose

    super.dispose();
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
        print('시발유야이디는');
        print(uid);
      });
    } else {
      setState(() {
        uid = firebaseuser.uid;
      });
      print('시발유야이디는');
      print(uid);
    }
  }

  Future<dynamic> ondispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return FirebaseFirestore.instance.collection('Users').doc(uid).get().then((value) {
      print('이거했엉?');
      //       final String url;
      // final String title;
      // final dynamic timeline;
      // final int bookmark;
      // final int end;
      // 저장 할때 이것도 같이 저장하자 그래야 나중에 누르면 가지
      var data = value.data()['listeningclass'];
      int index = data.indexWhere((element) => element['title'] == widget.title);
      data[index]['bookmark'] = _controller.value.position.inSeconds;
      data[index]['duration'] = widget.end;
      FirebaseFirestore.instance.collection('Users').doc(uid).set({"listeningclass": data}, SetOptions(merge: true)).then((value) {
        print('goTsi');
      });
    });
  }

  gotopos(String position) {
    var min = 60 * int.parse(position.split(":")[0]);
    var sec = int.parse(position.split(":")[1]);
    _controller.seekTo(Duration(seconds: min + sec));
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Scaffold(
      body: Container(
          width: size.screenSize.width,
          height: size.screenSize.height,
          child: Stack(
            children: [
              Positioned(
                  child: Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: fullscreen ? MediaQuery.of(context).size.aspectRatio : 16 / 9,
                        child: Transform(
                          alignment: Alignment.center,
                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: false,
                            actionsPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            topActions: [],
                            bottomActions: [],
                          ),
                          transform: showmirror ? Matrix4.rotationY(pi) : Matrix4.rotationY(pi * 2),
                        ),
                      ))),
              Positioned(
                  top: size.getHeightPx(23),
                  right: size.getHeightPx(23),
                  child: InkWell(
                    onTap: () {
                      ondispose().then((value) => Navigator.pop(context));
                    },
                    child: Container(
                      width: size.getHeightPx(20),
                      height: size.getHeightPx(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.166666507720947)), border: Border.all(color: const Color(0xffffffff), width: 2)),
                      child: SvgPicture.asset(
                        'assets/images/icons/cancel_btn.svg',
                        color: Colors.white,
                      ),
                    ),
                  )),
              // Positioned(
              //     top: size.getHeightPx(20),
              //     left: size.getHeightPx(20),
              //     child: IconButton(
              //       icon: Icon(
              //         Icons.cancel_outlined,
              //         color: Colors.white,
              //       ),
              //       onPressed: () {
              //         ondispose().then((value) => Navigator.pop(context));
              //       },
              //     )),
              AnimatedPositioned(
                  top: showtimeline ? 0 : -size.screenSize.height,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 160),
                      width: size.screenSize.width,
                      height: size.screenSize.height,
                      color: Colors.black.withOpacity(0.3),
                      child: widget.timeline == null
                          ? Center(
                              child: Text("타임라인 정보가 없습니다.",
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getHeightPx(17)),
                                  textAlign: TextAlign.left),
                            )
                          : ShaderMask(
                              shaderCallback: (Rect rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                                  stops: [0.0, 0.0, 0.1, 0.9], // 10% purple, 80% transparent, 10% purple
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 130),
                                child: ListView.builder(
                                    itemCount: widget.timeline.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          gotopos(widget.timeline[index]['pos']);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.all(12),
                                            width: 300,
                                            height: 40,
                                            decoration: BoxDecoration(border: Border.all(color: const Color(0xffffffff), width: 1)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(widget.timeline[index]['title'],
                                                    textScaleFactor: 1,
                                                    style: TextStyle(
                                                        color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: 13),
                                                    textAlign: TextAlign.left),
                                                Text(widget.timeline[index]['pos'],
                                                    textScaleFactor: 1,
                                                    style: TextStyle(
                                                        color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: 13),
                                                    textAlign: TextAlign.left)
                                              ],
                                            )),
                                      );
                                    }),
                              ))),
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 300)),
              AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  bottom: showmenu ? -size.getHeightPx(30) : 30,
                  child: Container(
                      //color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: size.getHeightPx(70)),
                      width: size.screenSize.width,
                      height: size.getHeightPx(100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                showmenu ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                color: Colors.white,
                                size: size.getHeightPx(60),
                              ),
                              onPressed: () {
                                print('as');
                                setState(() {
                                  showmenu = !showmenu;

                                  if (showmenu) {
                                    showspeed = false;
                                    showtimeline = false;
                                  }
                                });
                              }),
                          SizedBox(height: size.getHeightPx(30)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      showspeed = !showspeed;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/images/icons/speed_btn.svg',
                                          width: size.getHeightPx(20), color: showspeed ? Colors.green : Colors.white),
                                      SizedBox(
                                        width: size.getHeightPx(6),
                                      ),
                                      Text("재생 속도",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getHeightPx(9)),
                                          textAlign: TextAlign.left)
                                    ],
                                  )),
                              SizedBox(
                                width: size.getHeightPx(32),
                              ),
                              // InkWell(
                              //     onTap: () {},
                              //     child: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.settings,
                              //           color: Colors.white,
                              //         ),
                              //         SizedBox(
                              //           width: size.getHeightPx(6),
                              //         ),
                              //         Text("품질 설정",
                              //             style: TextStyle(
                              //                 color: const Color(0xffffffff),
                              //                 fontWeight: FontWeight.w700,
                              //                 fontFamily: "SpoqaHanSansNeo",
                              //                 fontStyle: FontStyle.normal,
                              //                 fontSize: size.getWidthPx(9)),
                              //             textAlign: TextAlign.left)
                              //       ],
                              //     )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      showmirror = !showmirror;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/images/icons/mirror_btn.svg',
                                          width: size.getHeightPx(20), color: showmirror ? Colors.green : Colors.white),
                                      SizedBox(
                                        width: size.getHeightPx(6),
                                      ),
                                      Text(showmirror ? "거울모드(on)" : "거울모드(off)",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getHeightPx(9)),
                                          textAlign: TextAlign.left)
                                    ],
                                  )),
                              SizedBox(
                                width: size.getHeightPx(32),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      showtimeline = !showtimeline;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/images/icons/timeline_btn.svg',
                                          width: size.getHeightPx(20), color: showtimeline ? Colors.green : Colors.white),
                                      SizedBox(
                                        width: size.getHeightPx(6),
                                      ),
                                      Text("타임라인",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              color: const Color(0xffffffff), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getHeightPx(9)),
                                          textAlign: TextAlign.left)
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ))),
              AnimatedPositioned(
                bottom: showspeed ? size.getHeightPx(70) : -size.getHeightPx(45),
                left: size.getHeightPx(100),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                      alignment: Alignment.center,
                      width: size.getHeightPx(220),
                      height: size.getHeightPx(45),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(size.getHeightPx(10))), color: const Color(0xff191919)),
                      child: SfSliderTheme(
                          data: SfSliderThemeData(
                            activeTrackHeight: 2,
                            inactiveTrackHeight: 2,
                            activeDivisorRadius: 5,
                            activeTrackColor: Color(0xffbfbfbf),
                            activeDivisorColor: Color(0xffbfbfbf),
                            inactiveDivisorColor: Color(0xffbfbfbf),
                            inactiveTrackColor: Color(0xffbfbfbf),
                            inactiveDivisorRadius: 5,
                            thumbStrokeWidth: 2,
                            thumbStrokeColor: Color(0xffbfbfbf),
                            thumbColor: Colors.black.withOpacity(0.3),
                            activeLabelStyle: TextStyle(
                                color: const Color(0xffbfbfbf),
                                fontFamily: "w500",
                                fontStyle: FontStyle.normal,
                                fontSize: size.getHeightPx(7) * size.textscale),
                            inactiveLabelStyle: TextStyle(
                                color: const Color(0xffbfbfbf),
                                fontFamily: "w500",
                                fontStyle: FontStyle.normal,
                                fontSize: size.getHeightPx(7) * size.textscale),
                          ),
                          child: SfSlider(
                              value: _currentSliderValue,
                              max: 1.5,
                              min: 0.5,
                              interval: 0.25,
                              stepSize: 0.25,
                              showDivisors: true,
                              showLabels: true,
                              enableTooltip: true,
                              onChanged: (value) {
                                setState(() {
                                  _currentSliderValue = value;
                                  _controller.setPlaybackRate(value);
                                });
                              }))),
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              ),
            ],
          )),
    );
  }
}

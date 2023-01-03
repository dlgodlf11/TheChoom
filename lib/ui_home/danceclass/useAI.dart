import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';
import 'package:thechoom/ui_home/danceclass/camera.dart';
import 'package:thechoom/ui_home/danceclass/useaiwidget/viewscore.dart';
import 'package:thechoom/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

List<CameraDescription> cameras;
AiClassViewState ai_state;

class AiClassView extends StatefulWidget {
  final String url;
  final String title;
  final int start;
  final int end;
  final int bpm;

  AiClassView({this.url, this.title, this.bpm, this.end, this.start}) {
    ai_state = new AiClassViewState();
  }

  @override
  AiClassViewState createState() => ai_state;
}

class AiClassViewState extends State<AiClassView>
    with TickerProviderStateMixin {
  Screen size;
  List<Widget> stackChildren = [];
  var checkdata;
  int checkindex = 0;
  var position;
  bool togglecam = false;
  var stackchild;
  var youtube;
  var cam;
  int count = 3;
  String scoreasset = "assets/lottiejson/hmm.json";
  bool countview = true;
  Timer blink;

  bool blackscreen = false;
  YoutubePlayerController _controller;
  var campositionx = 20.0;
  var campositiony = 20.0;
  double average = 0;
  double avgc = 0;
  AnimationController scorecontroller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.url,
      flags: YoutubePlayerFlags(
        hideControls: true,
        hideThumbnail: true,
        disableDragSeek: true,
        enableCaption: false,
        autoPlay: false,
        mute: false,
      ),
    );
    scorecontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    FirebaseFirestore.instance
        .collection('Posedata')
        .doc(widget.title)
        .get()
        .then((value) {
      setState(() {
        checkdata = value.data()['element'];
      });
    });
    _controller.addListener(() {
      setState(() {
        position = _controller.value.position.inMilliseconds;
        if (_controller.value.playerState == PlayerState.ended) {
          setState(() {
            blackscreen = true;
            Timer timer = new Timer(Duration(seconds: 5), () {
              //Navigator.pop(context);
              Route route = MaterialPageRoute(
                  builder: (context) => ViewScore(
                        url: widget.url,
                        title: widget.title,
                        start: widget.start,
                        end: widget.end,
                        bpm: widget.bpm,
                        score: average,
                      ));
              Navigator.pushReplacement(context, route);
            });
          });
        }
      });
    });
    cam = Camera(cameras, setRecognitions,
        [for (int i = widget.start; i < widget.end; i += widget.bpm) i]);
    Tflite.loadModel(
      model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
      // useGpuDelegate: true,
    ).then((res) {
      print(res);
      initcamera();
      blinkcount();
    });

    super.initState();
  }

  initcamera() async {
    print('호출');
    setState(() {
      availableCameras().then((value) {
        setState(() {
          cameras = value;
          cam = Camera(cameras, setRecognitions,
              [for (int i = widget.start; i < widget.end; i += widget.bpm) i]);

          youtube = YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: false,
            actionsPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            topActions: [],
            bottomActions: [],
          );
        });
        print(cameras);
        if (cameras == null) {
          print('재호출');
          initcamera();
        }
      });
    });
  }

  blinkcount() {
    blink = new Timer(Duration(milliseconds: 700), () {
      setState(() {
        if (countview == false) {
          setState(() {
            count -= 1;
          });
        }
        if (count == 0) {
          _controller.play();
        }
        countview = !countview;
        if (count == -1) {
          blink.cancel();

          return;
        } else {
          blinkcount();
        }
      });
    });
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    //print(recognitions.length);
    double factorX = size.getWidthPx(120);
    double factorY = size.getWidthPx(160);
    var score = 0;
// 0	코
// 1	leftEye
// 2	오른쪽 눈
// 삼	왼쪽 귀
// 4	오른쪽 귀
// 5	left 숄더
// 6	rightShoulder
// 7	leftElbow
// 8	rightElbow
// 9	왼쪽 손목
// 10	오른쪽 손목
// 11	leftHip
// 12	rightHip
// 13	leftKnee
// 14	rightKnee
// 15	leftAnkle
// 16	rightAnkle
    if (recognitions.length != 0) {
      // var rightShoulder = calculateAngle([
      //   recognitions[0]["keypoints"][5]['x'],
      //   recognitions[0]["keypoints"][5]['y']
      // ], [
      //   recognitions[0]["keypoints"][7]['x'],
      //   recognitions[0]["keypoints"][7]['y']
      // ]);
      // var rightElbow = calculateAngle([
      //   recognitions[0]["keypoints"][7]['x'],
      //   recognitions[0]["keypoints"][7]['y']
      // ], [
      //   recognitions[0]["keypoints"][9]['x'],
      //   recognitions[0]["keypoints"][9]['y']
      // ]);

      // var leftShoulder = calculateAngle([
      //   recognitions[0]["keypoints"][6]['x'],
      //   recognitions[0]["keypoints"][6]['y']
      // ], [
      //   recognitions[0]["keypoints"][8]['x'],
      //   recognitions[0]["keypoints"][8]['y']
      // ]);
      // var leftElbow = calculateAngle([
      //   recognitions[0]["keypoints"][8]['x'],
      //   recognitions[0]["keypoints"][8]['y']
      // ], [
      //   recognitions[0]["keypoints"][10]['x'],
      //   recognitions[0]["keypoints"][10]['y']
      // ]);

      // var rightHip = calculateAngle([
      //   recognitions[0]["keypoints"][11]['x'],
      //   recognitions[0]["keypoints"][11]['y']
      // ], [
      //   recognitions[0]["keypoints"][13]['x'],
      //   recognitions[0]["keypoints"][13]['y']
      // ]);

      // var rightKnee = calculateAngle([
      //   recognitions[0]["keypoints"][13]['x'],
      //   recognitions[0]["keypoints"][13]['y']
      // ], [
      //   recognitions[0]["keypoints"][15]['x'],
      //   recognitions[0]["keypoints"][15]['y']
      // ]);

      // var leftHip = calculateAngle([
      //   recognitions[0]["keypoints"][12]['x'],
      //   recognitions[0]["keypoints"][12]['y']
      // ], [
      //   recognitions[0]["keypoints"][14]['x'],
      //   recognitions[0]["keypoints"][14]['y']
      // ]);

      // var leftKnee = calculateAngle([
      //   recognitions[0]["keypoints"][14]['x'],
      //   recognitions[0]["keypoints"][14]['y']
      // ], [
      //   recognitions[0]["keypoints"][16]['x'],
      //   recognitions[0]["keypoints"][16]['y']
      // ]);
      if (Platform.isAndroid) {
        print(
            "aisdjflksadjkflasdjlfjaskdljfklasjdklfklasdjklfjklasdjklfjkalsdjfklajslkdfjasd");
        print(recognitions[0]["keypoints"][5]['x']);
        print('들어오나?');
        var leftShoulder = calculateAngle([
          1.0 - recognitions[0]["keypoints"][5]['x'],
          recognitions[0]["keypoints"][5]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][7]['x'],
          recognitions[0]["keypoints"][7]['y']
        ]);
        var leftElbow = calculateAngle([
          1.0 - recognitions[0]["keypoints"][7]['x'],
          recognitions[0]["keypoints"][7]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][9]['x'],
          recognitions[0]["keypoints"][9]['y']
        ]);

        var rightShoulder = calculateAngle([
          1.0 - recognitions[0]["keypoints"][6]['x'],
          recognitions[0]["keypoints"][6]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][8]['x'],
          recognitions[0]["keypoints"][8]['y']
        ]);
        var rightElbow = calculateAngle([
          1.0 - recognitions[0]["keypoints"][8]['x'],
          recognitions[0]["keypoints"][8]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][10]['x'],
          recognitions[0]["keypoints"][10]['y']
        ]);

        var leftHip = calculateAngle([
          1.0 - recognitions[0]["keypoints"][11]['x'],
          recognitions[0]["keypoints"][11]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][13]['x'],
          recognitions[0]["keypoints"][13]['y']
        ]);

        var leftKnee = calculateAngle([
          1.0 - recognitions[0]["keypoints"][13]['x'],
          recognitions[0]["keypoints"][13]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][15]['x'],
          recognitions[0]["keypoints"][15]['y']
        ]);

        var rightHip = calculateAngle([
          1.0 - recognitions[0]["keypoints"][12]['x'],
          recognitions[0]["keypoints"][12]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][14]['x'],
          recognitions[0]["keypoints"][14]['y']
        ]);

        var rightKnee = calculateAngle([
          1.0 - recognitions[0]["keypoints"][14]['x'],
          recognitions[0]["keypoints"][14]['y']
        ], [
          1.0 - recognitions[0]["keypoints"][16]['x'],
          recognitions[0]["keypoints"][16]['y']
        ]);
        score = (checkdata[checkindex]['leftShoulder'] - leftShoulder)
                .round()
                .abs() +
            (checkdata[checkindex]['leftElbow'] - leftElbow).round().abs() +
            (checkdata[checkindex]['rightShoulder'] - rightShoulder)
                .round()
                .abs() +
            (checkdata[checkindex]['rightElbow'] - rightElbow).round().abs() +
            (checkdata[checkindex]['leftHip'] - leftHip).round().abs() +
            (checkdata[checkindex]['leftKnee'] - leftKnee).round().abs() +
            (checkdata[checkindex]['rightHip'] - rightHip).round().abs() +
            (checkdata[checkindex]['rightKnee'] - rightKnee).round().abs();
      } else {
        print('들어오나?');
        var leftShoulder = calculateAngle([
          recognitions[0]["keypoints"][5]['x'],
          recognitions[0]["keypoints"][5]['y']
        ], [
          recognitions[0]["keypoints"][7]['x'],
          recognitions[0]["keypoints"][7]['y']
        ]);
        var leftElbow = calculateAngle([
          recognitions[0]["keypoints"][7]['x'],
          recognitions[0]["keypoints"][7]['y']
        ], [
          recognitions[0]["keypoints"][9]['x'],
          recognitions[0]["keypoints"][9]['y']
        ]);

        var rightShoulder = calculateAngle([
          recognitions[0]["keypoints"][6]['x'],
          recognitions[0]["keypoints"][6]['y']
        ], [
          recognitions[0]["keypoints"][8]['x'],
          recognitions[0]["keypoints"][8]['y']
        ]);
        var rightElbow = calculateAngle([
          recognitions[0]["keypoints"][8]['x'],
          recognitions[0]["keypoints"][8]['y']
        ], [
          recognitions[0]["keypoints"][10]['x'],
          recognitions[0]["keypoints"][10]['y']
        ]);

        var leftHip = calculateAngle([
          recognitions[0]["keypoints"][11]['x'],
          recognitions[0]["keypoints"][11]['y']
        ], [
          recognitions[0]["keypoints"][13]['x'],
          recognitions[0]["keypoints"][13]['y']
        ]);

        var leftKnee = calculateAngle([
          recognitions[0]["keypoints"][13]['x'],
          recognitions[0]["keypoints"][13]['y']
        ], [
          recognitions[0]["keypoints"][15]['x'],
          recognitions[0]["keypoints"][15]['y']
        ]);

        var rightHip = calculateAngle([
          recognitions[0]["keypoints"][12]['x'],
          recognitions[0]["keypoints"][12]['y']
        ], [
          recognitions[0]["keypoints"][14]['x'],
          recognitions[0]["keypoints"][14]['y']
        ]);

        var rightKnee = calculateAngle([
          recognitions[0]["keypoints"][14]['x'],
          recognitions[0]["keypoints"][14]['y']
        ], [
          recognitions[0]["keypoints"][16]['x'],
          recognitions[0]["keypoints"][16]['y']
        ]);
        score = (checkdata[checkindex]['leftShoulder'] - leftShoulder)
                .round()
                .abs() +
            (checkdata[checkindex]['leftElbow'] - leftElbow).round().abs() +
            (checkdata[checkindex]['rightShoulder'] - rightShoulder)
                .round()
                .abs() +
            (checkdata[checkindex]['rightElbow'] - rightElbow).round().abs() +
            (checkdata[checkindex]['leftHip'] - leftHip).round().abs() +
            (checkdata[checkindex]['leftKnee'] - leftKnee).round().abs() +
            (checkdata[checkindex]['rightHip'] - rightHip).round().abs() +
            (checkdata[checkindex]['rightKnee'] - rightKnee).round().abs();
      }

      // FirebaseFirestore.instance.collection('Posedata').doc(widget.title).set({
      //   "element": FieldValue.arrayUnion([
      //     {
      //       "leftShoulder": leftShoulder,
      //       "leftElbow": leftElbow,
      //       "rightShoulder": rightShoulder,
      //       "rightElbow": rightElbow,
      //       "leftHip": leftHip,
      //       "leftKnee": leftKnee,
      //       "rightHip": rightHip,
      //       "rightKnee": rightKnee
      //     }
      //   ])
      // }, SetOptions(merge: true));

      // var test = {
      //   "leftShoulder":
      //       (checkdata[checkindex]['leftShoulder'] - leftShoulder).round().abs(),
      //   "leftElbow":
      //       (checkdata[checkindex]['leftElbow'] - leftElbow).round().abs(),
      //   "rightShoulder": (checkdata[checkindex]['rightShoulder'] - rightShoulder)
      //       .round()
      //       .abs(),
      //   "rightElbow":
      //       (checkdata[checkindex]['rightElbow'] - rightElbow).round().abs(),
      //   "leftHip": (checkdata[checkindex]['leftHip'] - leftHip).round().abs(),
      //   "leftKnee": (checkdata[checkindex]['leftKnee'] - leftKnee).round().abs(),
      //   "rightHip": (checkdata[checkindex]['rightHip'] - rightHip).round().abs(),
      //   "rightKnee":
      //       (checkdata[checkindex]['rightKnee'] - rightKnee).round().abs()
      // };
      //print('이건댐>');

    } else {
      FirebaseFirestore.instance.collection('Posedata').doc(widget.title).set({
        "element": FieldValue.arrayUnion([
          {
            "leftShoulder": 0,
            "leftElbow": 0,
            "rightShoulder": 0,
            "rightElbow": 0,
            "leftHip": 0,
            "leftKnee": 0,
            "rightHip": 0,
            "rightKnee": 0
          }
        ])
      }, SetOptions(merge: true));
    }
    checkindex += 1;
    print(score);
    if (score == 0) {
      setState(() {
        scoreasset = 'assets/lottiejson/hmm.json';
        scorecontroller.reset();
        scorecontroller.forward();
        calculateAvg(0);
      });
    } else if (score <= 230) {
      setState(() {
        scoreasset = 'assets/lottiejson/prefect.json';
        scorecontroller.reset();
        scorecontroller.forward();
        calculateAvg(100);
      });
    } else if (score <= 320) {
      setState(() {
        scoreasset = 'assets/lottiejson/great.json';
        scorecontroller.reset();
        scorecontroller.forward();
        calculateAvg(90);
      });
    } else if (score <= 410) {
      setState(() {
        scoreasset = 'assets/lottiejson/good.json';
        scorecontroller.reset();
        scorecontroller.forward();
        calculateAvg(80);
      });
    } else if (score <= 470) {
      setState(() {
        scoreasset = 'assets/lottiejson/bad.json';
        scorecontroller.reset();
        scorecontroller.forward();
        calculateAvg(30);
      });
    } else {
      scoreasset = 'assets/lottiejson/hmm.json';
      scorecontroller.reset();
      scorecontroller.forward();
      calculateAvg(0);
    }

    //오차 0~50이내는 퍼팩트 100
    //오차 51~80이내는 그뤠잇 80
    //오차 81~120이내는 굿 60
    //오차 121~210이내는 흠 40
    //오차 210~는 배드 0

    stackChildren.clear();
    var lists = <Widget>[];
    recognitions.forEach((re) {
      var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);
      var list = re["keypoints"].values.map<Widget>((k) {
        return Platform.isAndroid
            ? Positioned(
                left: (1.0 - k["x"]) * factorX - 6,
                top: k["y"] * factorY - 6,
                child: Text(
                  // "● ${k["part"]}",
                  "●",
                  style: TextStyle(
                    color: color,
                    fontSize: 12.0,
                  ),
                ),
              )
            : Positioned(
                left: (k["x"]) * factorX - 6,
                top: k["y"] * factorY - 6,
                child: Text(
                  // "● ${k["part"]}",
                  "●",
                  style: TextStyle(
                    color: color,
                    fontSize: 12.0,
                  ),
                ),
              );
        ;
      }).toList();
      setState(() {
        lists..addAll(list);
        stackChildren.addAll(lists);
      });
    });
    // return lists;
  }

  calculateAvg(double y) {
    print('object');
    if (average == 0) {
      average = y;
      avgc += 1;
    } else {
      avgc += 1;
      average = (((avgc - 1) / avgc) * average) + ((1 / avgc) * y);
      print(average);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  calculateAngle(from, to) {
    return (atan2(to[1] - from[1], to[0] - from[0]) * 180 / pi).round();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);

    return cameras == null
        ? Scaffold(
            body: Center(),
          )
        : SafeArea(
            child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    child: Align(
                        alignment: Alignment.center,
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Transform(
                            alignment: Alignment.center,
                            child: YoutubePlayer(
                              controlsTimeOut: Duration(microseconds: 1),
                              controller: _controller,
                              showVideoProgressIndicator: false,
                              actionsPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              topActions: [],
                              bottomActions: [],
                            ),
                            transform: Matrix4.rotationY(pi),
                          ),
                        ))),
                Positioned(
                    top: campositiony,
                    left: campositionx,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          campositionx =
                              details.globalPosition.dx - size.getWidthPx(60);
                          campositiony =
                              details.globalPosition.dy - size.getWidthPx(80);
                        });
                      },
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          campositionx =
                              details.globalPosition.dx - size.getWidthPx(60);
                          campositiony =
                              details.globalPosition.dy - size.getWidthPx(80);
                          print(campositiony);
                        });
                      },
                      child: Container(
                        // transform: Matrix4.rotationY(pi),
                        width: size.getWidthPx(120),
                        height: size.getWidthPx(160),
                        child: cam,
                      ),
                    )),
                Positioned(
                  top: 0,
                  left: 0,
                  child: count != -1
                      ? Container(
                          color: Colors.black.withOpacity(0.8),
                          width: size.screenSize.width,
                          height: size.screenSize.height,
                          child: Center(
                              child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: countview ? 1 : 0,
                            child: Text(count != 0 ? count.toString() : 'start',
                                style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontFamily: "w500",
                                    fontStyle: FontStyle.normal,
                                    fontSize: size.getWidthPx(130)),
                                textAlign: TextAlign.center),
                          )))
                      : SizedBox(),
                ),
                Positioned(
                    top: campositiony,
                    left: campositionx,
                    child: Container(
                      width: size.getWidthPx(120),
                      height: size.getWidthPx(160),
                      child: Stack(
                        children: stackChildren,
                      ),
                    )),
                Positioned(
                  child: Lottie.asset(scoreasset,
                      repeat: true, controller: scorecontroller),
                  width: size.getWidthPx(300),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    child: !blackscreen
                        ? SizedBox()
                        : AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                            opacity: blackscreen ? 1 : 0,
                            child: Container(
                              width: size.screenSize.width,
                              height: size.screenSize.height,
                              color: Colors.black,
                            ),
                          )),
                Positioned.fill(
                    child: AnimatedOpacity(
                        duration: Duration(seconds: 1),
                        opacity: blackscreen &&
                                _controller.value.playerState ==
                                    PlayerState.ended
                            ? 1
                            : 0,
                        child: Center(
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
                            Lottie.asset('assets/lottiejson/progress_AI.json',
                                width: size.getWidthPx(120)),
                            SizedBox(
                              height: size.getWidthPx(30),
                            ),
                            Text("래퍼런스 데이터와 당신의 유사도를\n측정중입니다.",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontFamily: "w100",
                                    fontStyle: FontStyle.normal,
                                    fontSize: size.getWidthPx(17)),
                                textAlign: TextAlign.center)
                          ],
                        )))),
              ],
            ),
          ));
  }
}

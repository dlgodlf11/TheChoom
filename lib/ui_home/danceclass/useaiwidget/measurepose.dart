import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';
import 'package:thechoom/ui_home/danceclass/useAI.dart';
import 'package:thechoom/ui_home/danceclass/useaiwidget/camsetload.dart';
import 'package:thechoom/utils/utils.dart';

List<CameraDescription> cameras;

class MeasurePose extends StatefulWidget {
  final String url;
  final String title;
  final int start;
  final int end;
  final int bpm;
  MeasurePose({this.url, this.title, this.bpm, this.end, this.start});
  @override
  _MeasurePoseState createState() => _MeasurePoseState();
}

class _MeasurePoseState extends State<MeasurePose> {
  Screen size;
  bool is_on = true;
  bool stopblink = false;
  double detectCount = 0.0;
  setRecognitions(recognitions, imageHeight, imageWidth) {
    if (detectCount < 100) {
      if (recognitions.length >= 1) {
        setState(() {
          detectCount += 2;
        });
        print(detectCount);
      }
    } else if (detectCount == 100) {
      detectCount += 1;
      Timer timer = new Timer(Duration(seconds: 3), () {
        Route route = MaterialPageRoute(
            builder: (context) => AiClassView(
                  url: widget.url,
                  title: widget.title,
                  start: widget.start,
                  end: widget.end,
                  bpm: widget.bpm,
                ));

        Navigator.push(context, route);
      });
    }
  }

  initcamera() async {
    print('호출');
    setState(() {
      availableCameras().then((value) {
        setState(() {
          cameras = value;
        });
        print(cameras);
        if (cameras == null) {
          print('재호출');
          initcamera();
        }
      });
    });
  }

  @override
  void initState() {
    blinkborder();
    Tflite.loadModel(
      model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
      // useGpuDelegate: true,
    ).then((res) {
      print(res);
      initcamera();
    });

    super.initState();
  }

  blinkborder() {
    if (stopblink == false) {
      Timer blink = new Timer(Duration(milliseconds: 1000), () {
        setState(() {
          is_on = !is_on;
          blinkborder();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return cameras == null
        ? Scaffold(
            body: Center(),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: Center(
                    child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Container(
                    //transform: Matrix4.rotationY(pi),
                    child: SetCamera(cameras, setRecognitions),
                  ),
                ),
                Positioned.fill(
                    child: AnimatedOpacity(
                        opacity: is_on ? 1.0 : 0,
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                          margin: EdgeInsets.all(size.getWidthPx(20)),
                          width: size.screenSize.width,
                          height: size.screenSize.height,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                        ))),
                Positioned.fill(
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
                    Text("The Choom AI를\n실행중 입니다.",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w100",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(17)),
                        textAlign: TextAlign.center)
                  ],
                ))),
                Positioned(
                    bottom: size.getWidthPx(50),
                    child: Container(
                      width: size.screenSize.width,
                      alignment: Alignment.center,
                      child: Text(detectCount.toString() + " %",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: const Color(0xffffffff),
                            fontFamily: "w500",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(17),
                          ),
                          textAlign: TextAlign.center),
                    ))
              ],
            ))),
          );
  }
}

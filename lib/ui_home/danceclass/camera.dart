import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:thechoom/ui_home/danceclass/useAI.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final List<int> checkduration;
  Camera(this.cameras, this.setRecognitions, this.checkduration);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  int checkIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.low,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          //print(ai_state.position);
          // Tflite.runPoseNetOnFrame(
          //         bytesList: img.planes.map((plane) {
          //           return plane.bytes;
          //         }).toList(),
          //         imageHeight: img.height,
          //         imageWidth: img.width,
          //         numResults: 1,
          //         threshold: 0.8)
          //     .then((recognitions) {
          //   widget.setRecognitions(recognitions, img.height, img.width);
          // });

          if (widget.checkduration != null) {
            if (widget.checkduration[checkIndex] <= ai_state.position) {
              //print(ai_state.position);

              if (Platform.isAndroid) {
                print('android');
                checkIndex += 1;
                if (!isDetecting) {
                  isDetecting = true;
                  Tflite.runPoseNetOnFrame(
                          bytesList: img.planes.map((plane) {
                            return plane.bytes;
                          }).toList(),
                          imageHeight: img.height,
                          imageWidth: img.width,
                          numResults: 1,
                          rotation: 270,
                          threshold: 0.8)
                      .then((recognitions) {
                    widget.setRecognitions(recognitions, img.height, img.width);
                    isDetecting = false;
                  });
                }
                // Android-specific code
              } else if (Platform.isIOS) {
                checkIndex += 1;
                if (!isDetecting) {
                  isDetecting = true;
                  Tflite.runPoseNetOnFrame(
                          bytesList: img.planes.map((plane) {
                            return plane.bytes;
                          }).toList(),
                          imageHeight: img.height,
                          imageWidth: img.width,
                          numResults: 1,
                          threshold: 0.8)
                      .then((recognitions) {
                    widget.setRecognitions(recognitions, img.height, img.width);
                    isDetecting = false;
                  });
                }
                // iOS-specific code
              }
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return CameraPreview(controller);
  }
}

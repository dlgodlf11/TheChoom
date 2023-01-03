import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class SetCamera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  SetCamera(this.cameras, this.setRecognitions);

  @override
  _SetCameraState createState() => new _SetCameraState();
}

class _SetCameraState extends State<SetCamera> {
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
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
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
        });
      });
    }
  }

  @override
  void dispose() {
    //controller?.dispose();
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

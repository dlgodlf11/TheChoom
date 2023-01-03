import 'package:flutter/material.dart';
import 'package:thechoom/ui_home/danceclass/useaiwidget/measurepose.dart';
import 'package:thechoom/utils/utils.dart';

class ChecklistWidget extends StatefulWidget {
  final String url;
  final String title;
  final int start;
  final int end;
  final int bpm;
  ChecklistWidget({this.url, this.title, this.bpm, this.end, this.start});
  @override
  _ChecklistWidgetState createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  Screen size;
  bool allcheck = false;
  List<bool> process = [false, false, false, false, false, false, false];
  List<String> text = [
    '카메라를 세로로 세워 주세요.',
    '화면에 전신이 나오도록 해주세요.',
    '옷 색깔과 배경이 잘 구분되어야 합니다.',
    '펑퍼짐한 옷은 피해주세요.',
    '화면 가이드에 맞게 춤을 춰주세요.',
    '혼자서 하셔야합니다.',
    '볼륨을 잘 들리도록 조절해 주세요'
  ];
  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(20)),
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.getWidthPx(20),
                    ),
                    Text("The Choom AI 하기 전 확인해주세요!",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: const Color(0xffff32ff),
                            fontFamily: "w700",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(19)),
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: size.getWidthPx(20),
                    ),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        checkColor: Colors.white,
                        activeColor: Color(0xffcb1acc),
                        title: Text("모두 확인하였습니다.",
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: const Color(0xff707070),
                                fontFamily: "w500",
                                fontStyle: FontStyle.normal,
                                fontSize: size.getWidthPx(17)),
                            textAlign: TextAlign.left),
                        value: allcheck,
                        onChanged: (value) {
                          setState(() {
                            allcheck = value;
                            for (int i = 0; i < process.length; i++) {
                              process[i] = value;
                            }
                          });
                        }),
                    SizedBox(
                      height: size.getWidthPx(20),
                    ),
                    Divider(
                      color: Color(0xff898989),
                    ),
                    SizedBox(
                      height: size.getWidthPx(20),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: process.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  checkColor: Colors.white,
                                  activeColor: Color(0xffcb1acc),
                                  title: Text(text[index],
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          color: const Color(0xff707070),
                                          fontFamily: "w500",
                                          fontStyle: FontStyle.normal,
                                          fontSize: size.getWidthPx(15)),
                                      textAlign: TextAlign.left),
                                  value: process[index],
                                  onChanged: (value) {
                                    setState(() {
                                      process[index] = value;
                                      if (process.indexWhere(
                                              (element) => element == false) ==
                                          -1) {
                                        allcheck = true;
                                      } else {
                                        allcheck = false;
                                      }
                                    });
                                  });
                            }))
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (process.indexWhere((element) => element == false) == -1) {
                    Route route = MaterialPageRoute(
                        builder: (context) => MeasurePose(
                              url: widget.url,
                              title: widget.title,
                              start: widget.start,
                              end: widget.end,
                              bpm: widget.bpm,
                            ));
                    Navigator.push(context, route);
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  width: size.screenSize.width,
                  height: size.getWidthPx(55),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: process.indexWhere(
                                        (element) => element == false) !=
                                    -1
                                ? Colors.white
                                : Color(0x34000000),
                            offset: Offset(5, 5),
                            blurRadius: 10,
                            spreadRadius: 0)
                      ],
                      color: const Color(0xffffffff)),
                  child: Text("The Choom AI 시작하기",
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: process.indexWhere(
                                      (element) => element == false) !=
                                  -1
                              ? Color(0xff676464)
                              : Color(0xfffe2eff),
                          fontFamily: "w700",
                          fontStyle: FontStyle.normal,
                          fontSize: size.getWidthPx(17)),
                      textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

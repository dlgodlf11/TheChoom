import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/utils/utils.dart';

class TutorialPage extends StatefulWidget {
  // var mission_data = 12;
  final bool cancelbutton;
  TutorialPage({this.cancelbutton});
  @override
  TutorialPageState createState() => TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  Screen size;
  int _current = 0;
  CarouselControllerImpl scrollController = new CarouselControllerImpl();
  var imagepath = [
    'assets/lottiejson/tutorialD1.json',
    'assets/lottiejson/tutorialD2.json',
    'assets/lottiejson/tutorialD3.json',
    'assets/lottiejson/tutorial_D4.json'
  ];
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    var textwidget = [
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                style: TextStyle(
                    color: Color(0xffff32ff),
                    fontFamily: "w400",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(20)),
                text: "국내외 아티스트들의\n다채로운 장르를 한번에")
          ])),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                style: TextStyle(
                    color: Color(0xffff32ff),
                    fontFamily: "w400",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(20)),
                text: "댄스 마스터가 익힌\n정확한 동작을 차근차근 내 집에서")
          ])),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                style: TextStyle(
                    color: Color(0xffff32ff),
                    fontFamily: "w400",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(20)),
                text: "나의 동작 정확도 판단을\n최신 AI 기술로")
          ])),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                style: TextStyle(
                    color: Color(0xffff32ff),
                    fontFamily: "w400",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(20)),
                text: "Let's play the Choom!")
          ])),
    ];
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
            bottom: 0,
            child: Container(
              width: size.screenSize.width,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(bottom: size.getWidthPx(265)),
              color: Colors.white,
            )),
        Positioned(
            top: 0,
            child: Container(
              width: size.screenSize.width,
              height: size.screenSize.height,
              padding: EdgeInsets.symmetric(vertical: size.getWidthPx(20)),
              alignment: Alignment.bottomCenter,
              child: CarouselSlider.builder(
                  carouselController: scrollController,
                  options: CarouselOptions(
                    //scrollPhysics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index, reason) {
                      print(index);
                      setState(() {
                        _current = index;
                      });
                    },
                    height: double.infinity,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Lottie.asset(
                          imagepath[index],
                          fit: BoxFit.fitWidth,
                          repeat: true,
                        ),
                      ],
                    );
                  }),
            )),
        Positioned(
          top: size.getWidthPx(70),
          child: textwidget[_current],
        ),
        Positioned(
            bottom: size.getWidthPx(30),
            child: _current != 3 && widget.cancelbutton == false
                ? SizedBox()
                : Container(
                    width: size.screenSize.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.getWidthPx(30)),
                    alignment: Alignment.topCenter,
                    child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: size.getWidthPx(50),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x34000000),
                                    offset: Offset(5, 5),
                                    blurRadius: 30,
                                    spreadRadius: 0)
                              ],
                              color: Colors.white),
                          child: Text(
                            widget.cancelbutton
                                ? "닫기"
                                : _current == 3
                                    ? "더춤 시작하기"
                                    : '다음',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xfffe2eff),
                                fontFamily: "w700",
                                fontStyle: FontStyle.normal,
                                fontSize: size.getWidthPx(15)),
                          ),
                        )))),
        Positioned(
            bottom: size.getWidthPx(100),
            child: Container(
              margin: EdgeInsets.only(bottom: size.getWidthPx(20)),
              alignment: Alignment.center,
              width: size.screenSize.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagepath.map<Widget>((url) {
                  int index = imagepath.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color(0xfffe2eff)
                          : Color(0xff4e164e),
                    ),
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }
}

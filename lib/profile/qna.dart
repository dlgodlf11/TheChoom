import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/profile/viewcontent.dart';
import 'package:thechoom/utils/utils.dart';

class QnA extends StatefulWidget {
  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  Screen size;
  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);

    return Container(
      color: Color(0xff191919),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff191919),
          appBar: appbar(),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Manager')
                .doc('QnA')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data['qna']);
                return Container(
                  child: snapshot.data['qna'].length == 0
                      ? Center(
                          child: Text('질문이 없슴니다',
                              style: TextStyle(
                                color: Colors.white,
                              )))
                      : ListView.builder(
                          itemCount: snapshot.data['qna'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => ViewContent(
                                          title: snapshot.data['qna'][index]
                                              ['title'],
                                          date: snapshot.data['qna'][index]
                                              ['date'],
                                          content: snapshot.data['qna'][index]
                                              ['text'],
                                        ));
                                Navigator.push(context, route);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.getWidthPx(17),
                                    vertical: size.getWidthPx(11)),
                                decoration: BoxDecoration(
                                    color: Color(0xff191919),
                                    border: Border.all(
                                        width: 0.1, color: Colors.white)),
                                height: size.getWidthPx(90),
                                width: size.screenSize.width,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data['qna'][index]['title'],
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: const Color(0xffdbdbdb),
                                            fontFamily: "w500",
                                            fontStyle: FontStyle.normal,
                                            fontSize: size.getWidthPx(16)),
                                        textAlign: TextAlign.left),
                                    Text(snapshot.data['qna'][index]['date'],
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: const Color(0xffdbdbdb),
                                            fontFamily: "w100",
                                            fontStyle: FontStyle.normal,
                                            fontSize: size.getWidthPx(10)),
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                              ),
                            );
                          }),
                );
              } else {
                return Center(
                  child: Lottie.asset(
                    'assets/lottiejson/progress_nor.json',
                    width: size.getWidthPx(110),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        iconTheme: new IconThemeData(
          color: Colors.black,
          size: 24,
        ),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/images/icons/back_btn.svg',
              color: Color(0xffcb1acc),
              width: size.getWidthPx(26),
            ),
          );
        }),
        elevation: 0,
        backgroundColor: Color(0xff191919),
        title: Text(
          "자주묻는 질문",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: const Color(0xffcb0ccc),
              fontFamily: "w700",
              fontStyle: FontStyle.normal,
              fontSize: size.getWidthPx(17)),
        ),
        centerTitle: false,
      ),
    );
  }
}

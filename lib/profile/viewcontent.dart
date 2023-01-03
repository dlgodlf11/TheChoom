import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thechoom/utils/utils.dart';

class ViewContent extends StatefulWidget {
  String title;
  String content;
  String date;
  ViewContent({this.title, this.content, this.date});
  @override
  _ViewContentState createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  Screen size;
  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
      color: Color(0xff191919),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Color(0xff191919),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: AppBar(
              iconTheme: new IconThemeData(
                color: Colors.black,
                size: 24,
              ),
              elevation: 0,
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/images/icons/back_btn.svg',
                  width: size.getWidthPx(24),
                  color: Color(0xffdd1dde),
                ),
                onPressed: () => Navigator.pop(context, null),
              ),
              backgroundColor: Color(0xff191919),
              title: Text(
                '상세보기',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: const Color(0xffdd1dde),
                    fontFamily: "AppleSDGothicNeoEB",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(17)),
              ),
              centerTitle: false,
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(size.getWidthPx(15)),
            color: Color(0xff191919),
            width: size.screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    textScaleFactor: 1.0,
                    maxLines: 2,
                    style: TextStyle(
                        color: const Color(0xffdbdbdb),
                        fontFamily: "AppleSDGothicNeoSB",
                        fontStyle: FontStyle.normal,
                        fontSize: size.getWidthPx(17))),
                SizedBox(height: size.getWidthPx(15)),
                Divider(
                  thickness: 1,
                  color: Color(0xffdbdbdb),
                ),
                SizedBox(height: size.getWidthPx(15)),
                Expanded(
                    child: Container(
                  child: ListView(
                    children: [
                      Text(
                        widget.content.replaceAll('/n', '\n'),
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: const Color(0xffdbdbdb),
                            fontFamily: "AppleSDGothicNeoSB",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(14)),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

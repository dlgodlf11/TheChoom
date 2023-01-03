import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thechoom/utils/utils.dart';

class PvsPage extends StatefulWidget {
  var url;
  PvsPage({this.url});
  @override
  PvsPageState createState() => PvsPageState();
}

class PvsPageState extends State<PvsPage> {
  Screen size;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);

    return Container(
      color: Colors.white,
      child: SafeArea(
          bottom: false,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: appBar(),
              body: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(size.getWidthPx(10)),
                    color: Colors.white,
                    child: SvgPicture.asset(
                      widget.url,
                      width: size.screenSize.width,
                      fit: BoxFit.fill,
                    ),
                  )
                ],
              ))),
    );
  }

  appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
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
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "약관 상세",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: Color(0xff707070),
              fontFamily: "AppleSDGothicNeoEB",
              fontStyle: FontStyle.normal,
              fontSize: size.getWidthPx(17)),
        ),
        centerTitle: true,
      ),
    );
  }
}

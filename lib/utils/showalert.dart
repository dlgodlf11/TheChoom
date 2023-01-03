import 'package:flutter/material.dart';
import 'package:thechoom/utils/responsive_size.dart';

class ShowAlert {
  Future<dynamic> showalert(
      {BuildContext context,
      bool istwobutton = false,
      void Function() onPressed,
      Screen size,
      String text,
      String title,
      String secondbuttontext}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(size.getWidthPx(20)),
            actionsPadding: EdgeInsets.only(top: size.getWidthPx(31)),
            buttonPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(size.getWidthPx(43)),
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(title,
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: const Color(0xff707070),
                    fontFamily: "w700",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(19)),
                textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    child: Text(text,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: const Color(0xff707070),
                            fontFamily: "w500",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(16)),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            actions: istwobutton
                ? <Widget>[
                    Container(
                      width: size.screenSize.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(size.getWidthPx(16)),
                              alignment: Alignment.center,
                              width: size.getWidthPx(160),
                              height: size.getWidthPx(51),
                              child: Text(
                                "닫기",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: const Color(0xff707070),
                                    fontFamily: "w700",
                                    fontStyle: FontStyle.normal,
                                    fontSize: size.getWidthPx(17)),
                              ),
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: onPressed,
                            child: Container(
                              padding: EdgeInsets.all(size.getWidthPx(16)),
                              alignment: Alignment.center,
                              width: size.getWidthPx(160),
                              height: size.getWidthPx(51),
                              child: Text(
                                secondbuttontext,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: const Color(0xffdd1dde),
                                    fontFamily: "w700",
                                    fontStyle: FontStyle.normal,
                                    fontSize: size.getWidthPx(17)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                : <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(size.getWidthPx(16)),
                        alignment: Alignment.center,
                        width: size.screenSize.width,
                        height: size.getWidthPx(51),
                        child: Text(
                          "닫기",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: const Color(0xffdd1dde),
                              fontFamily: "w700",
                              fontStyle: FontStyle.normal,
                              fontSize: size.getWidthPx(17)),
                        ),
                      ),
                    )
                  ],
          );
        });
  }
}

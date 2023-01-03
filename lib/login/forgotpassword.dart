import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:thechoom/utils/showalert.dart';
import 'package:thechoom/utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  Screen size;
  ShowAlert showAlert;
  bool loading = false;
  TextEditingController _email = new TextEditingController();

  String _emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return '입력하신 이메일이 형식에 맞지 않습니다. ex)asdf@asdf.com';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    showAlert = new ShowAlert();

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.grey[900],
          child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.grey[900],
                appBar: appbar(),
                body: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getWidthPx(30),
                      vertical: size.getWidthPx(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("비밀번호를 잃어버리셨군요.",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: const Color(0xff707070),
                            fontFamily: "w500",
                            fontStyle: FontStyle.normal,
                            fontSize: size.getWidthPx(17),
                          ),
                          textAlign: TextAlign.left),
                      SizedBox(
                        height: size.getWidthPx(15),
                      ),
                      Text(
                          "가입한 이메일 계정을 통해 새롭게 비밀번호를 설정할 수 있는\n인증 메일을 보내드립니다. 올바른 이메일 계정이 아니라면, \n재발급 절차에 문제가 있을 수 있으니 참고해주세요.",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: const Color(0xff707070),
                              fontFamily: "w400",
                              fontStyle: FontStyle.normal,
                              fontSize: size.getWidthPx(11)),
                          textAlign: TextAlign.left),
                      SizedBox(
                        height: size.getWidthPx(30),
                      ),
                      textfield(
                          controller: _email,
                          viewtext: false,
                          placehoder: '가입했던 이메일 계정을 입력해 주세요'),
                      validateText(
                          validator: _emailValidator, text: _email.text),
                      SizedBox(
                        height: size.getWidthPx(30),
                      ),
                      submitbutton(
                        onPressed: () {
                          print('as');
                          setState(() {
                            loading = true;
                          });
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _email.text)
                              .then((value) {
                            setState(() {
                              loading = false;
                            });
                            showAlert.showalert(
                                context: context,
                                title: '비밀번호 재발급 완료',
                                text: '이메일 계정으로 들어가셔셔\n계정인증 후, 비밀번호를 변경해 주세요.',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                size: size);
                          }).catchError((e) {
                            setState(() {
                              loading = false;
                            });
                            showAlert.showalert(
                                context: context,
                                title: '이메일 오류',
                                text: '가입되지 않은 이메일입니다.',
                                size: size);
                          });
                        },
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

  validateText({validator, text}) {
    var result = validator(text);
    if (result == null) {
      return SizedBox(
        height: size.getWidthPx(17),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: size.getWidthPx(10)),
        alignment: Alignment.centerLeft,
        height: size.getWidthPx(17),
        child: Text(result,
            textScaleFactor: 1.0,
            style: TextStyle(
                color: const Color(0xfffe2eff),
                fontFamily: "w500",
                fontStyle: FontStyle.normal,
                fontSize: size.getWidthPx(7)),
            textAlign: TextAlign.left),
      );
    }
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
            color: Color(0xffcb0ccc),
          );
        }),
        elevation: 0,
        backgroundColor: Colors.grey[900],
        title: Text(
          "비밀번호 찾기",
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

  textfield(
      {String placehoder, TextEditingController controller, bool viewtext}) {
    return Container(
      width: size.screenSize.width,
      height: size.getWidthPx(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
            color: controller.text.length == 0
                ? Color(0xff707070)
                : Color(0xfffe2eff),
            width: 1),
      ),
      child: CupertinoTextField(
        obscureText: viewtext,
        padding: EdgeInsets.only(left: size.getWidthPx(14)),
        controller: controller,
        placeholder: placehoder,
        onChanged: (value) {
          setState(() {});
        },
        decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
        placeholderStyle: TextStyle(
            color: const Color(0xffb4b4b4),
            fontFamily: "w300",
            fontStyle: FontStyle.normal,
            fontSize: size.getWidthPx(13) * size.textscale),
        style: TextStyle(
            color: Color(0xfffe2eff),
            fontWeight: FontWeight.w300,
            fontFamily: "w300",
            fontStyle: FontStyle.normal,
            fontSize: size.getWidthPx(13) * size.textscale),
      ),
    );
  }

  submitbutton({void Function() onPressed}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xfffe2eff),
      ),
      width: double.infinity,
      height: size.getWidthPx(50),
      child: FlatButton(
        child: loading
            ? Lottie.asset(
                'assets/lottiejson/progress_nor.json',
                fit: BoxFit.fitWidth,
                width: size.getWidthPx(110),
                repeat: true,
              )
            : Text("비밀번호 재발급",
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "w700",
                    fontStyle: FontStyle.normal,
                    fontSize: size.getWidthPx(14)),
                textAlign: TextAlign.center),
        onPressed: loading ? null : onPressed,
      ),
    );
  }
}

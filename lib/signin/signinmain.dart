import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thechoom/signin/viewpvs.dart';
import 'package:thechoom/utils/showalert.dart';
import 'package:thechoom/utils/utils.dart';

class SigninMain extends StatefulWidget {
  @override
  _SigninMainState createState() => _SigninMainState();
}

class _SigninMainState extends State<SigninMain> with TickerProviderStateMixin {
  Screen size;
  ShowAlert showAlert;
  bool isallcheck = false;
  bool useallow = false;
  bool privatedataallow = false;
  bool recivevent = false;
  bool marketing = false;
  bool loading = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _checkpassword = new TextEditingController();
  TextEditingController _nickname = new TextEditingController();
  ScrollController signinscroll = new ScrollController();
  int signinindex = 0;
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

  String _pwdValidator(String value) {
    Pattern pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return '비밀번호는 영문, 숫자조합으로 8자 이상입니다.';
    } else {
      return null;
    }
  }

  String _pwdCheckValidator(String value) {
    if (value != _password.text) {
      return '비밀번호가 일치하지 않습니다.';
    } else {
      return null;
    }
  }

  String _nicknameValidator(String value) {
    if (value.length < 2) {
      return '2자 이상으로 입력해 주세요';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    showAlert = new ShowAlert();
    return Container(
      color: Color(0xff191919),
      child: SafeArea(
        bottom: false,
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              backgroundColor: Color(0xff191919),
              appBar: appbar(),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: signinscroll,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(20), vertical: size.getWidthPx(0)),
                          width: size.screenSize.width,
                          child: Column(
                            children: <Widget>[
                              _checkAllAgree(),
                              Divider(
                                thickness: 1,
                                color: Color(0xff707070),
                              ),
                              _checkAgree(text: "이용약관 동의(필수)", url: "assets/pvs/img_pvs_service.svg"),
                              _checkAgree(text: "개인정보 처리방침 동의(필수)", url: "assets/pvs/img_pvs_custom.svg"),
                            ],
                          ),
                        ),
                        Container(
                          width: size.screenSize.width,
                          child: ListView(
                            children: <Widget>[
                              textfield(placehoder: '이메일 입력.', controller: _email, viewtext: false),
                              validateText(validator: _emailValidator, text: _email.text),
                              textfield(placehoder: '영어, 숫자조합으로 최소 8자리 비밀번호를 입력.', controller: _password, viewtext: true),
                              validateText(validator: _pwdValidator, text: _password.text),
                              textfield(placehoder: '비밀번호 확인.', controller: _checkpassword, viewtext: true),
                              validateText(validator: _pwdCheckValidator, text: _checkpassword.text),
                              textfield(placehoder: '힙스러운 나만의 댄서 네임을 정해봐유!.', controller: _nickname, viewtext: false),
                              validateText(validator: _nicknameValidator, text: _nickname.text),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(bottom: size.getWidthPx(30) - MediaQuery.of(context).viewInsets.bottom, left: size.getWidthPx(30), child: bottomnavbar()),
                ],
              ),
            )),
      ),
    );
  }

  validateText({validator, text}) {
    var result = validator(text);
    if (result == null) {
      return SizedBox(
        height: size.getWidthPx(17),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: size.getWidthPx(46)),
        alignment: Alignment.centerLeft,
        height: size.getWidthPx(17),
        child: Text(result,
            textScaleFactor: 1.0,
            style: TextStyle(color: const Color(0xfffe2eff), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(7)),
            textAlign: TextAlign.left),
      );
    }
  }

  textfield({String placehoder, TextEditingController controller, bool viewtext}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: size.screenSize.width,
      height: size.getWidthPx(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: controller.text.length == 0 ? Color(0xff707070) : Color(0xfffe2eff), width: 1),
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
        placeholderStyle:
            TextStyle(color: const Color(0xffb4b4b4), fontFamily: "w300", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(13) * size.textscale),
        style: TextStyle(
            color: Color(0xfffe2eff),
            fontWeight: FontWeight.w300,
            fontFamily: "w300",
            fontStyle: FontStyle.normal,
            fontSize: size.getWidthPx(13) * size.textscale),
      ),
    );
  }

  bottomnavbar() {
    return InkWell(
      onTap: () {
        if (!loading) {
          if (signinindex == 0) {
            if ((useallow && privatedataallow) || isallcheck) {
              setState(() {
                signinindex += 1;
                signinscroll.animateTo((signinindex) * (MediaQuery.of(context).size.width), duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
              });
            }
          } else {
            if (_emailValidator(_email.text) == null &&
                _pwdValidator(_password.text) == null &&
                _pwdCheckValidator(_checkpassword.text) == null &&
                _nicknameValidator(_nickname.text) == null) {
              setState(() {
                loading = true;
              });
              print('오캐이 다음');
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text, password: _password.text).then((currentuser) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentuser.user.uid)
                    .set({"email": _email.text, "name": _nickname.text, "uid": currentuser.user.uid, "listeningclass": [], "finishedclass": []});
                showAlert
                    .showalert(
                        context: context,
                        title: "Let's dancing time!",
                        text: '회원가입이 완료 되었네요!\n' + _nickname.text + "님 좀 추십니까?",
                        onPressed: () {
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        },
                        size: size)
                    .then((value) => Navigator.pop(context));
              }).catchError((e) {
                showAlert.showalert(context: context, title: "회원가입 오류", text: '뭔가 이상합니다...\n누가 당신의 이메일을 사용하고있나봐요', size: size);

                setState(() {
                  loading = false;
                });
              });
            } else {
              print('노우노우 다시해');
              showAlert.showalert(context: context, title: '회원가입 오류', text: '입력하신 내용을 다시 확인해 주세요.', size: size);
              print(_emailValidator(_email.text));
              print(_pwdValidator(_password.text));
              print(_pwdCheckValidator(_checkpassword.text));
              print(_nicknameValidator(_nickname.text));
            }
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // border: Border.all(
          //   color: const Color(0xfffe2eff),
          //   width: 3,
          // ),
          color: (useallow && privatedataallow) || isallcheck ? Color(0xffcb1acc) : Color(0xff707070),
        ),
        width: MediaQuery.of(context).size.width - size.getWidthPx(60),
        height: size.getWidthPx(60),
        child: loading
            ? CircularProgressIndicator()
            : Text(signinindex == 0 ? "다음" : '회원가입 완료',
                textScaleFactor: 1.0,
                style: TextStyle(color: const Color(0xff191919), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                textAlign: TextAlign.center),
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
              setState(() {
                signinindex -= 1;
                if (signinindex < 0) {
                  Navigator.pop(context);
                }
                signinscroll.animateTo((signinindex) * (MediaQuery.of(context).size.width), duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
              });
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
        backgroundColor: Color(0xff191919),
        title: Text(
          signinindex == 1 ? "회원 정보 입력" : "개인정보 약관 동의",
          textScaleFactor: 1.0,
          style: TextStyle(color: const Color(0xffcb0ccc), fontFamily: "w700", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
        ),
        centerTitle: false,
      ),
    );
  }

  Widget _checkAllAgree() {
    return Row(
      children: [
        Container(
          child: Text("모두 동의합니다.",
              textScaleFactor: 1.0,
              style: TextStyle(color: const Color(0xff707070), fontFamily: "AppleSDGothicNeoM", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
              textAlign: TextAlign.left),
        ),
        Container(
          child: new Checkbox(
            checkColor: Color(0xffffffff),
            activeColor: Color(0xffcb1acc),
            value: isallcheck,
            onChanged: (bool value) {
              setState(() {
                isallcheck = !isallcheck;
                useallow = isallcheck;
                privatedataallow = isallcheck;
                recivevent = isallcheck;
                marketing = isallcheck;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _checkAgree({String text, String url}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              child: new Checkbox(
                checkColor: Color(0xffffffff),
                activeColor: Color(0xffcb1acc),
                value: text == "이용약관 동의(필수)"
                    ? useallow
                    : text == "개인정보 처리방침 동의(필수)"
                        ? privatedataallow
                        : text == "이벤트 등 프로모션 안내(필수)"
                            ? recivevent
                            : marketing,
                onChanged: (bool value) {
                  setState(() {
                    text == "이용약관 동의(필수)"
                        ? useallow = value
                        : text == "개인정보 처리방침 동의(필수)"
                            ? privatedataallow = value
                            : text == "이벤트 등 프로모션 안내(필수)"
                                ? recivevent = value
                                : marketing = value;
                    print(isallcheck);
                    print(useallow);
                    print(recivevent);
                    print(privatedataallow);

                    if (useallow && privatedataallow) {
                      isallcheck = true;
                    } else {
                      isallcheck = false;
                    }
                  });
                },
              ),
            ),
            Container(
              child: Text(text,
                  textScaleFactor: 1.0,
                  style: TextStyle(color: const Color(0xff707070), fontFamily: "w500", fontStyle: FontStyle.normal, fontSize: size.getWidthPx(17)),
                  textAlign: TextAlign.left),
            ),
          ],
        ),
        url == null
            ? SizedBox()
            : Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => PvsPage(
                                url: url,
                              ));
                      Navigator.push(context, route);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: size.getWidthPx(15),
                      ),
                      child: Text("내용보기",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: const Color(0xff707070),
                              fontFamily: "AppleSDGothicNeoM",
                              fontStyle: FontStyle.normal,
                              fontSize: size.getWidthPx(11)),
                          textAlign: TextAlign.left),
                    ),
                  ),
                ],
              )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thechoom/utils/utils.dart';

class BottomNavBar extends StatefulWidget {
  final ValueChanged<int> changeCurrentTab;

  BottomNavBar({Key key, this.changeCurrentTab}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int tab = 0;
  var iconselectlist = [true, false, false, false, false];

  Screen size;
  onchange(index) {
    if (index != 5) {
      tab = index;
      iconselectlist = [false, false, false, false, false];
      iconselectlist[index] = true;
      widget.changeCurrentTab(index);
    }
    // setState(() {

    // });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.getWidthPx(40)),
      color: Color(0xff191919),
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: BottomNavigationBar(
          backgroundColor: Color(0xff191919),
          type: BottomNavigationBarType.fixed,
          iconSize: size.getWidthPx(24),
          currentIndex: tab,
          unselectedItemColor: Color(0xff817d7d),
          selectedItemColor: Color(0xffcb1acc),
          // selectedIconTheme: IconThemeData(
          //   color: Color(0xff084bff),
          // ),
          elevation: 0,
          selectedFontSize: 13.0,
          showUnselectedLabels: true,
          onTap: onchange,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icons/home_btn.svg',
                color:
                    iconselectlist[0] ? Color(0xffcb1acc) : Color(0xff817d7d),
                width: iconselectlist[0]
                    ? size.getWidthPx(17)
                    : size.getWidthPx(17),
              ),
              title: Text('Home',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: "w400",
                      fontStyle: FontStyle.normal,
                      fontSize: size.getWidthPx(10)),
                  textAlign: TextAlign.center),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icons/my choom_btn.svg',
                color:
                    iconselectlist[1] ? Color(0xffcb1acc) : Color(0xff817d7d),
                width: iconselectlist[1]
                    ? size.getWidthPx(17)
                    : size.getWidthPx(17),
              ),
              title: Text('My Choom',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: "w400",
                      fontStyle: FontStyle.normal,
                      fontSize: size.getWidthPx(10)),
                  textAlign: TextAlign.center),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icons/profile_btn.svg',
                color:
                    iconselectlist[2] ? Color(0xffcb1acc) : Color(0xff817d7d),
                width: iconselectlist[2]
                    ? size.getWidthPx(17)
                    : size.getWidthPx(17),
              ),
              title: Text('Profile',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: "w400",
                      fontStyle: FontStyle.normal,
                      fontSize: size.getWidthPx(10)),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
// items: [
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/bottomnavbar/btn_home.svg',
//                 width: iconselectlist[0] ? size.getWidthPx(20) : size.getWidthPx(17),
//                 color: iconselectlist[0] ? Color(0xff084bff) : null,
//               ),
//               title: Text('홈',
//                   textScaleFactor: 1.0,
//                   style: const TextStyle(fontFamily: "AppleSDGothicNeoR", fontStyle: FontStyle.normal, fontSize: 10.0),
//                   textAlign: TextAlign.center),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/bottomnavbar/btn_benchmark.svg',
//                 width: iconselectlist[1] ? size.getWidthPx(20) : size.getWidthPx(17),
//                 color: iconselectlist[1] ? Color(0xff084bff) : null,
//               ),
//               title: Text('퍼스널레코드',
//                   textScaleFactor: 1.0,
//                   style: const TextStyle(fontFamily: "AppleSDGothicNeoR", fontStyle: FontStyle.normal, fontSize: 10.0),
//                   textAlign: TextAlign.center),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/bottomnavbar/btn_timer.svg',
//                 width: iconselectlist[2] ? size.getWidthPx(20) : size.getWidthPx(17),
//                 color: iconselectlist[2] ? Color(0xff084bff) : null,
//               ),
//               title: Text('타이머',
//                   textScaleFactor: 1.0,
//                   style: const TextStyle(fontFamily: "AppleSDGothicNeoR", fontStyle: FontStyle.normal, fontSize: 10.0),
//                   textAlign: TextAlign.center),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/bottomnavbar/btn_record.svg',
//                 width: iconselectlist[3] ? size.getWidthPx(20) : size.getWidthPx(17),
//                 color: iconselectlist[3] ? Color(0xff084bff) : null,
//               ),
//               title: Text('히스토리',
//                   textScaleFactor: 1.0,
//                   style: const TextStyle(fontFamily: "AppleSDGothicNeoR", fontStyle: FontStyle.normal, fontSize: 10.0),
//                   textAlign: TextAlign.center),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/bottomnavbar/btn_box.svg',
//                 width: iconselectlist[4] ? size.getWidthPx(20) : size.getWidthPx(17),
//                 color: iconselectlist[4] ? Color(0xff084bff) : null,
//               ),
//               title: Text('박스',
//                   textScaleFactor: 1.0,
//                   style: const TextStyle(fontFamily: "AppleSDGothicNeoR", fontStyle: FontStyle.normal, fontSize: 10.0),
//                   textAlign: TextAlign.center),
//             ),
//           ],

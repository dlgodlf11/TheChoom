import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:thechoom/utils/responsive_size.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MiniVideo extends StatefulWidget {
  final String url;
  final String end;
  MiniVideo({this.url, this.end});
  @override
  _MiniVideoState createState() => _MiniVideoState();
}

class _MiniVideoState extends State<MiniVideo> {
  Screen size;
  YoutubePlayerController _controller;
  double opacity = 1.0;
  bool play = false;
  bool mute = true;
  Timer timer;
  int time;
  @override
  void initState() {
    int time = (int.parse(widget.end.split(':')[0]) * 60) +
        int.parse(widget.end.split(':')[1]);
    _controller = YoutubePlayerController(
      initialVideoId: widget.url,
      flags: YoutubePlayerFlags(autoPlay: true, mute: true, loop: true),
    );
    _controller.addListener(() {
      if (_controller.value.position.inSeconds >= time) {
        _controller.seekTo(Duration(seconds: 0));
      }
    });
    print('object');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(
        MediaQuery.of(context).size, MediaQuery.of(context).textScaleFactor);
    return Container(
      width: size.screenSize.width,
      height: size.getWidthPx(200),
      child: Stack(
        children: [
          Positioned.fill(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: false,
              actionsPadding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              topActions: [],
              bottomActions: [],
            ),
          ),
          Positioned(
              bottom: size.getWidthPx(5),
              right: size.getWidthPx(5),
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: !mute
                    ? SvgPicture.asset(
                        'assets/images/icons/mute_btn.svg',
                        color: Colors.white,
                        width: size.getWidthPx(25),
                      )
                    : SvgPicture.asset(
                        'assets/images/icons/play_btn.svg',
                        color: Colors.white,
                        width: size.getWidthPx(25),
                      ),

                // Icon(
                //   mute ? Icons.volume_off : Icons.volume_up,
                //   color: Colors.white,
                // ),
                onPressed: () {
                  if (mute) {
                    setState(() {
                      _controller.unMute();
                      mute = false;
                    });
                  } else {
                    setState(() {
                      _controller.mute();
                      mute = true;
                    });
                  }
                },
              ))
        ],
      ),
    );
  }
}

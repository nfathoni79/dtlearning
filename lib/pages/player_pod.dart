import 'dart:developer';
import 'package:dtlearning/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';

class PlayerPod extends StatefulWidget {
  final String? videotype, videoUrl;
  const PlayerPod(this.videotype, this.videoUrl, {Key? key}) : super(key: key);

  @override
  State<PlayerPod> createState() => _PlayerPodState();
}

class _PlayerPodState extends State<PlayerPod> {
  late final PodPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late PlayVideoFrom playVideoFrom;
  int? playerCPosition, videoDuration;

  @override
  void initState() {
    _playerInit();
    super.initState();
  }

  _playerInit() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    if (widget.videotype == "youtube") {
      log("youtube==");
      playVideoFrom = PlayVideoFrom.youtube(widget.videoUrl ?? "");
    } else if (widget.videotype == "vimeo") {
      log("vimeo==");
      playVideoFrom = PlayVideoFrom.vimeo(widget.videoUrl ?? "");
    } else {
      log("else==");
      playVideoFrom = PlayVideoFrom.network(widget.videoUrl ?? "");
    }
    _controller = PodPlayerController(
      playVideoFrom: playVideoFrom,
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: true,
        isLooping: false,
        videoQualityPriority: [2160, 1440, 1080, 720, 360, 240, 144],
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // _controller.videoSeekTo(Duration(milliseconds: widget.stopTime ?? 0));
    _initializeVideoPlayerFuture = _controller.initialise();

    _controller.addListener(() async {
      playerCPosition =
          (_controller.videoPlayerValue?.position)?.inMilliseconds ?? 0;
      videoDuration =
          (_controller.videoPlayerValue?.duration)?.inMilliseconds ?? 0;
      log("playerCPosition :===> $playerCPosition");
      log("videoDuration :===> $videoDuration");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WillPopScope(
              onWillPop: () => onBackPressed(),
              child: PodVideoPlayer(
                controller: _controller,
              ),
            );
          } else {
            return Center(
              child: Utils.pageLoader(),
            );
          }
        },
      ),
    );
  }

  Future<bool> onBackPressed() async {
    log("onBackPressed playerCPosition :===> $playerCPosition");
    log("onBackPressed videoDuration :===> $videoDuration");

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Future.value(true);
  }
}

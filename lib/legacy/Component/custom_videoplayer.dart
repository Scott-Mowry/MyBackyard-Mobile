// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';

// class CustomVideoPlayer extends StatefulWidget {
//   CustomVideoPlayer({Key? key,required this.url}) : super(key: key);
//   String url;
//   @override
//   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// }

// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   final FijkPlayer player = FijkPlayer();
//   @override
//   void initState() {
//     super.initState();
//     setUrl();
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     player.release();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FijkView(
//       color: Colors.black,
//       player: player,
//       fit: FijkFit.cover,
//       fs: false,
//     );
//   }
//   setUrl(){
//     player.setDataSource(
//       widget.url
//         // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
//         , autoPlay: true);
//     setState(() {});
//   }
// }

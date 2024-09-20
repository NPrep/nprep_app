// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// import '../../../utils/colors.dart';
//
// class NetflixStyleControls extends StatelessWidget {
//   final ChewieController chewieController;
//   VideoPlayerController videoPlayerController;
//   NetflixStyleControls({ this.chewieController,this.videoPlayerController});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Container(
//             color: Colors.transparent,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Playback controls
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.replay_10),
//                       onPressed: _rewind,
//                     ),
//                     IconButton(
//                       icon: Icon(chewieController.isFullScreen
//                           ? Icons.fullscreen_exit
//                           : Icons.fullscreen),
//                       onPressed: _toggleFullScreen,
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.fast_forward),
//                       onPressed: _fastForward,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 // Seek bar and video duration
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Text(
//                         formatDuration(chewieController.videoPlayerController.value.position),
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     Expanded(
//                       child: VideoProgressIndicator(
//                         chewieController.videoPlayerController,
//                         allowScrubbing: true,
//                         colors: VideoProgressColors(
//                           playedColor: Colors.red,
//                           // handleColor: Colors.red,
//                           backgroundColor: Colors.grey,
//                           bufferedColor: Colors.grey.withOpacity(0.5),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: Text(
//                         formatDuration(chewieController.videoPlayerController.value.duration),
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 16),
//       ],
//     );
//   }
//
//   void _rewind() {
//     chewieController.seekTo(
//       chewieController.videoPlayerController.value.position - Duration(seconds: 10),
//     );
//   }
//
//   void _fastForward() {
//     chewieController.seekTo(
//       chewieController.videoPlayerController.value.position + Duration(seconds: 10),
//     );
//   }
//
//   void _toggleFullScreen() {
//     chewieController.enterFullScreen();
//   }
//
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }
// }

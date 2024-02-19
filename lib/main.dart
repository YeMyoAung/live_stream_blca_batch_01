import 'package:flutter/material.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/routes/router.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/themes/light_theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

// final LiveStreamUtilsService socketService = LiveStreamUtilsService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  // await socketService.init();
  runApp(MainApp(
    service: Locator<AgoraHostService>(),
  ));
}

final AppLightTheme appLightTheme = AppLightTheme();

// void callback() {
//   if (socketService.socket == null) {
//     return callback();
//   }
//   socketService.socket?.on("comment", (data) {
//     print("CommentEvent, $data");
//   });
//   socketService.socket?.on('post', (data) {
//     print("PostEvent,  $data");
//   });
//   socketService.socket?.on('like', (data) {
//     print("LikeEvent,  $data");
//   });
//   socketService.socket?.on('comment', (data) {
//     print("CommentEvent,  $data");
//   });
//   socketService.socket?.on("liveComment", (data) {
//     print("liveCommentEvent, $data");
//   });
//   socketService.socket?.on('hostEvent', (data) {
//     print("HostEvent,  $data");
//   });
//   socketService.socket?.on("joinEvent", (data) {
//     print("joinEvent, $data");
//   });
//   socketService.socket?.on("join", (data) {
//     print("UserJoinEvent, $data");
//   });
//   socketService.socket?.on("viewCount", (data) {
//     print("UserJoinCountEvent, $data");
//   });
//   Future.delayed(const Duration(seconds: 4), () {
//     socketService.socket?.emit("host", 12.toString());
//     print("Host Called");
//   });
//   Future.delayed(const Duration(seconds: 4), () {
// end
//     socketService.socket?.emit("join", 55.toString());
//     print("Join Called");
//   });
// }

class MainApp extends StatelessWidget {
  final AgoraBaseService service;
  const MainApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    // callback();
    return MaterialApp(
      navigatorKey: StarlightUtils.navigatorKey,
      onGenerateRoute: router,
      theme: appLightTheme.theme,
      initialRoute: RouteNames.auth,
    );
  }
}

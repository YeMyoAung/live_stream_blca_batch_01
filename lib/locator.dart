import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:live_stream/firebase_options.dart';
import 'package:live_stream/services/agora/impl/agora_guest_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/services/post/post_service.dart';

GetIt Locator = GetIt.asNewInstance();

Future<void> setup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  Locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  final agoraHostService = await AgoraHostService.instance();

  Locator.registerLazySingleton<AgoraHostService>(() => agoraHostService);

  final agoraGuestService = await AgoraGuestService.instance();

  Locator.registerLazySingleton<AgoraGuestService>(() => agoraGuestService);

  Locator.registerLazySingleton(() => AuthService());

  final Dio dio = Dio();

  Locator.registerLazySingleton(() => dio);

  Locator.registerLazySingleton(() => PostService());
}

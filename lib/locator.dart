import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:live_stream/firebase_options.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';

GetIt Locator = GetIt.asNewInstance();

Future<void> setup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  Locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  final service = await AgoraHostService.instance();
  Locator.registerLazySingleton<AgoraHostService>(() => service);
}

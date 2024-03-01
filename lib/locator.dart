import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:live_stream/firebase_options.dart';
import 'package:live_stream/services/agora/impl/agora_guest_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/services/firebase/firestore.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:image_picker/image_picker.dart';

GetIt locator = GetIt.asNewInstance();

Future<void> setup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  locator.registerLazySingleton(() => FirebaseStorage.instance);

  locator.registerLazySingleton(() => FirebaseFirestore.instance);

  locator.registerLazySingleton(() => ImagePicker());

  final Dio dio = Dio();

  locator.registerLazySingleton(() => dio);

  locator.registerLazySingleton(() => AuthService());

  locator.registerLazySingleton(() => SettingService());

  final agoraHostService = await AgoraHostService.instance();

  locator.registerLazySingleton<AgoraHostService>(() => agoraHostService);

  final agoraGuestService = await AgoraGuestService.instance();

  locator.registerLazySingleton<AgoraGuestService>(() => agoraGuestService);

  locator.registerLazySingleton(() => PostService());
  locator.registerLazySingleton(() => MyPostService());
  locator.registerLazySingleton(() => SearchPostService());
}

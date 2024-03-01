import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';

import '../../core/errors/error.dart';
import '../auth/auth.dart';

class AppSetting {
  final String theme;
  final bool withSound;

  const AppSetting(
    this.theme,
    this.withSound,
  );

  factory AppSetting.fromJson(dynamic data) {
    final withSound = data['is_mute'];
    return AppSetting(
      data['theme'] ?? 'light',
      withSound == null ? true : withSound == true,
    );
  }
}

abstract class SettingBaseService {
  final FirebaseFirestore database;
  final AuthService authService;

  SettingBaseService()
      : database = locator<FirebaseFirestore>(),
        authService = locator<AuthService>();

  Future<Result<bool>> write(String key, dynamic value);

  Stream<AppSetting> settings();

  Future<AppSetting> read();
}

const _availableSettingsKeys = ["theme", "is_mute"];

class SettingService extends SettingBaseService {
  @override
  Stream<AppSetting> settings() {
    final user = authService.currentUser;

    if (user == null) {
      return const Stream.empty();
    }
    return database
        .collection("settings")
        .doc(user.uid)
        .snapshots()
        .map(_listener);
  }

  AppSetting _listener(DocumentSnapshot<Map<String, dynamic>> event) {
    final data = event.data();
    if (data != null) {
      return AppSetting.fromJson(data);
    }
    return const AppSetting('light', false);
  }

  @override
  Future<Result<bool>> write(String key, value) async {
    if (!_availableSettingsKeys.contains(key)) {
      return const Result(error: GeneralError("Invalid key"));
    }
    final user = authService.currentUser;
    if (user == null) {
      return const Result(error: GeneralError("Unauthorized"));
    }
    try {
      await database.collection("settings").doc(user.uid).set(
        {key: value},
        SetOptions(merge: true),
      );
      return const Result(data: true);
    } on SocketException catch (e) {
      return Result(
        error: GeneralError(e.message),
      );
    } on FirebaseException catch (e) {
      return Result(
        error: GeneralError(
          e.message ?? e.code,
          e.stackTrace,
        ),
      );
    } catch (e) {
      return Result(
        error: GeneralError(e.toString()),
      );
    }
  }

  @override
  Future<AppSetting> read() async {
    final user = authService.currentUser;

    if (user == null) {
      return const AppSetting("light", true);
    }
    final result = await database.collection("settings").doc(user.uid).get();
    final data = result.data();
    if (data == null) {
      return const AppSetting("light", true);
    }
    return AppSetting.fromJson(data);
  }
}

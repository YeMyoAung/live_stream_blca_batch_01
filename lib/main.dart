import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_cubit.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/routes/router.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/themes/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MainApp(
    service: Locator<AgoraHostService>(),
  ));
}

final AppLightTheme appLightTheme = AppLightTheme();

class MainApp extends StatelessWidget {
  final AgoraBaseService service;
  const MainApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LiveViewCubit(),
        )
      ],
      child: MaterialApp(
        onGenerateRoute: router,
        theme: appLightTheme.theme,
        initialRoute: RouteNames.auth,
      ),
    );
  }
}

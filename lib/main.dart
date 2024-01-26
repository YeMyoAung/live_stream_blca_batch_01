import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_cubit.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/views/screens/live_stream/live_stream_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = await AgoraHostService.instance();
  runApp(MainApp(
    service: service,
  ));
}

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
        home: LiveStreamScreen(
          service: service,
        ),
      ),
    );
  }
}

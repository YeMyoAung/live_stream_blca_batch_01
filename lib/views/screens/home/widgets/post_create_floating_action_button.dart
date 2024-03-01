import 'package:flutter/material.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

void _goToContentCreatePage() {
  StarlightUtils.pushNamed(RouteNames.postCreate);
}

class CreatePostFloatingActionButton extends StatelessWidget {
  const CreatePostFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const FloatingActionButton(
      onPressed: _goToContentCreatePage,
      child: Icon(Icons.edit),
    );
  }
}

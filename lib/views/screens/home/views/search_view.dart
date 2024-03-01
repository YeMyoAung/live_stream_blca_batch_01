import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/views/screens/home/widgets/show_posts.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final topSafe = context.topSafe;
  late final searchBloc = context.read<SearchBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tileColor = theme.listTileTheme.tileColor!;
    final textColor = context.theme.textTheme.bodyLarge?.color;

    final textFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: tileColor,
      ),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: context.height,
        width: context.width,
        padding: EdgeInsets.only(
          top: topSafe,
        ),
        child: Stack(
          children: [
            const ShowPosts<SearchBloc>(
              padding: EdgeInsets.only(
                top: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: TextField(
                controller: searchBloc.queryC,
                focusNode: searchBloc.queryF,
                onEditingComplete: searchBloc.search,
                decoration: InputDecoration(
                  fillColor: tileColor,
                  filled: true,
                  hintText: "Search ...",
                  hintStyle: TextStyle(
                    color: textColor,
                  ),
                  enabledBorder: textFieldBorder,
                  border: textFieldBorder,
                  focusedBorder: textFieldBorder,
                  prefixIcon: Icon(
                    Icons.search,
                    color: textColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: searchBloc.clear,
                    icon: Icon(
                      Icons.clear,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

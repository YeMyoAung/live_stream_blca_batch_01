import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Locator<AuthService>();
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: StarlightUtils.pop,
        ),
        title: const Text("Setting"),
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Theme(
          data: context.theme.copyWith(
            listTileTheme: ListTileThemeData(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            children: [
              StreamBuilder(
                stream: authService.userChanges(),
                builder: (_, snap) {
                  final data = snap.data;
                  if (data == null) return const SizedBox();
                  final url = data.photoURL;

                  return ProfileCard(
                    shortName:
                        data.email?[0] ?? data.displayName?[0] ?? data.uid[0],
                    profileUrl: url ?? "",
                    displayName: data.displayName ?? "",
                    email: data.email ?? data.uid,
                  );
                },
              ),
              const SwitchCard(
                title: "Theme",
                current: 0,
                first: 0,
                second: 1,
                firstWidget: Icon(Icons.brightness_5),
                secondWidget: Icon(Icons.brightness_2),
              ),
              const SwitchCard(
                title: "Mute Audio",
                current: 1,
                first: 0,
                second: 1,
                firstWidget: Icon(
                  Icons.volume_off,
                ),
                secondWidget: Icon(
                  Icons.volume_up,
                  size: 22,
                ),
              ),
              OnTapCard(
                onTap: () {
                  launchUrl(Uri.parse("https://google.com"));
                },
                title: "Terms and Conditions",
              ),
              OnTapCard(
                onTap: () {
                  showLicensePage(context: context);
                },
                title: "Licenses",
              ),
              OnTapCard(
                onTap: () {
                  launchUrl(Uri.parse("tel:+959959165151"));
                },
                title: "Contact Us",
              ),
              OnTapCard(
                onTap: () {
                  StarlightUtils.aboutDialog(
                    applicationName: "Live Stream",
                    applicationVersion: "1.0.0",
                  );
                },
                title: "About Us",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  child: TextButton(
                    onPressed: () async {
                      await authService.logout();
                      StarlightUtils.pushNamed(RouteNames.home);
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OnTapCard extends StatelessWidget {
  final String title;

  final void Function()? onTap;

  const OnTapCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
      ),
    );
  }
}

class SwitchCard<T> extends StatelessWidget {
  final String title;
  final T current, first, second;
  final Widget firstWidget, secondWidget;

  const SwitchCard({
    super.key,
    required this.title,
    required this.current,
    required this.first,
    required this.second,
    required this.firstWidget,
    required this.secondWidget,
  });

  @override
  Widget build(BuildContext context) {
    final Map<T, Widget> data = {};

    data.addEntries([
      MapEntry(
          first,
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: firstWidget,
          )),
      MapEntry(
        second,
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: secondWidget,
        ),
      )
    ]);

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: ListTile(
        title: Text(title),
        trailing: SizedBox(
          width: 60,
          child: AnimatedToggleSwitch.dual(
            style: const ToggleStyle(
              backgroundColor: Color.fromRGBO(230, 230, 230, 1),
              indicatorColor: Colors.transparent,
            ),
            animationOffset: const Offset(10, 0),
            spacing: 8,
            indicatorSize: const Size(30, 30),
            borderWidth: 0,
            height: 35,
            second: second,
            current: current,
            first: first,
            iconBuilder: (i) {
              return data[i]!;
            },
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String profileUrl, shortName, displayName, email;

  const ProfileCard({
    super.key,
    required this.profileUrl,
    required this.shortName,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, //
        borderRadius:
            BorderRadius.circular(8), // Color.fromRGBO(r, g, b, opacity)
      ),
      child: Row(
        children: [
          if (profileUrl.isEmpty == true)
            CircleAvatar(
              maxRadius: 35,
              child: Text(
                shortName,
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
            )
          else
            CircleAvatar(
              maxRadius: 35,
              backgroundImage: CachedNetworkImageProvider(profileUrl),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}

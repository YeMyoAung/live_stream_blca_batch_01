import 'package:flutter/material.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/services/firebase/firestore.dart';
import 'package:live_stream/views/screens/settings/widgets/logout_button.dart';
import 'package:live_stream/views/screens/settings/widgets/on_tap_card.dart';
import 'package:live_stream/views/screens/settings/widgets/profile_card.dart';
import 'package:live_stream/views/screens/settings/widgets/switch_card.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:url_launcher/url_launcher.dart';

void _goToProfileSetting() {
  StarlightUtils.pushNamed(RouteNames.profileSetting);
}

void _aboutUs() {
  StarlightUtils.aboutDialog(
    applicationName: "Live Stream",
    applicationVersion: "1.0.0",
  );
}

void _contactUs() {
  launchUrl(Uri.parse("tel:+959959165151"));
}

void _termsAndConditions() {
  launchUrl(Uri.parse("https://google.com"));
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = locator<AuthService>();
    final SettingService settingService = locator<SettingService>();
    final theme = context.theme;
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
        child: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          children: [
            StreamBuilder(
              stream: authService.userChanges(),
              builder: (_, snap) {
                final data = snap.data;
                if (data == null) return const SizedBox();
                final url = data.photoURL;

                return GestureDetector(
                  onTap: _goToProfileSetting,
                  child: ProfileCard(
                    shortName:
                        data.email?[0] ?? data.displayName?[0] ?? data.uid[0],
                    profileUrl: url ?? "",
                    displayName: data.displayName ?? "",
                    email: data.email ?? data.uid,
                  ),
                );
              },
            ),
            StreamBuilder(
              stream: settingService.settings(),
              builder: (_, snap) {
                final data = snap.data;

                return SwitchCard(
                  onTap: (value) async {
                    await settingService.write("theme", value);
                  },
                  title: "Theme",
                  current: data?.theme ?? "light",
                  first: "light",
                  second: "dark",
                  firstWidget: const Icon(Icons.brightness_5),
                  secondWidget: const Icon(Icons.brightness_2),
                );
              },
            ),
            StreamBuilder(
              stream: settingService.settings(),
              builder: (_, snap) {
                final data = snap.data;
                return SwitchCard(
                  onTap: (value) {
                    settingService.write("is_mute", value);
                  },
                  title: "Mute Audio",
                  current: data?.withSound ?? true,
                  first: false,
                  second: true,
                  firstWidget: const Icon(
                    Icons.volume_off,
                  ),
                  secondWidget: const Icon(
                    Icons.volume_up,
                    size: 22,
                  ),
                );
              },
            ),
            const OnTapCard(
              onTap: _termsAndConditions,
              title: "Terms and Conditions",
            ),
            OnTapCard(
              onTap: () {
                StarlightUtils.push(
                  Theme(
                    data: theme.brightness == Brightness.dark
                        ? ThemeData.dark().copyWith(
                            progressIndicatorTheme:
                                theme.progressIndicatorTheme,
                          )
                        : ThemeData.light().copyWith(
                            progressIndicatorTheme:
                                theme.progressIndicatorTheme,
                          ),
                    child: const LicensePage(),
                  ),
                );
              },
              title: "Licenses",
            ),
            const OnTapCard(
              onTap: _contactUs,
              title: "Contact Us",
            ),
            const OnTapCard(
              onTap: _aboutUs,
              title: "About Us",
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                child: LogoutButton(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

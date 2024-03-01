import 'package:flutter/material.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/views/screens/settings/widgets/network_user_info.dart';
import 'package:live_stream/views/screens/settings/widgets/profile_setting_card.dart';
import 'package:live_stream/views/widgets/network_profile.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = locator<AuthService>();
    final theme = context.theme;
    final primaryColor = theme.floatingActionButtonTheme.backgroundColor;
    final cardBgColor = theme.bottomNavigationBarTheme.backgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          onPressed: StarlightUtils.pop,
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              height: context.height * 0.3,
              width: context.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: authService.updateProfile,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          maxRadius: 44,
                          backgroundColor: primaryColor,
                        ),
                        NetworkUserInfo(
                          builder: (data) {
                            final shortName = data.displayName?[0] ??
                                data.email?[0] ??
                                data.uid[0];
                            final profileUrl = data.photoURL ?? "";
                            if (profileUrl.isEmpty == true) {
                              return CircleAvatar(
                                maxRadius: 42,
                                child: Text(
                                  shortName,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: textColor,
                                  ),
                                ),
                              );
                            }
                            return NetworkProfile(
                              radius: 42,
                              profileUrl: profileUrl,
                              onFail: CircleAvatar(
                                maxRadius: 42,
                                child: Text(
                                  shortName,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 5,
                          child: Icon(
                            Icons.camera_alt,
                            color: textColor,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          user.displayName ??
                              user.email ??
                              user.uid.substring(0, 5),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          "Identity: ${user.providerData.first.email ?? user.providerData.first.phoneNumber ?? user.email ?? "NA"}",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          "Linked With: ${user.providerData.first.providerId}",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ProfileSettingCard(
                onTap: () async {
                  final result = await StarlightUtils.bottomSheet(builder: (_) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      width: context.width,
                      height: context.height * 0.5,
                      color: textColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value?.isNotEmpty == true
                                  ? null
                                  : "Display Name cannot be empty";
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            initialValue: authService.currentUser?.displayName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Display Name",
                            ),
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                StarlightUtils.pop(result: value);
                              }
                            },
                          )
                        ],
                      ),
                    );
                  });
                  if (result != null) {
                    locator<AuthService>().updateDisplayName(result);
                  }
                },
                title: "Display Name",
                value: (user) =>
                    user.displayName ?? user.email ?? user.uid.substring(0, 5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ProfileSettingCard(
                title: "Identity",
                value: (user) {
                  return user.providerData.first.email ??
                      user.providerData.first.phoneNumber ??
                      user.email ??
                      "NA";
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ProfileSettingCard(
                title: "Linked With",
                value: (user) {
                  return user.providerData.first.providerId;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

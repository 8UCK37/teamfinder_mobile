import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../../widgets/misc/teamfinder_appbar.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  bool isDarkCurrent;
  SettingsPage({Key? key, required this.isDarkCurrent}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _preferences;
  late bool _isDark = widget.isDarkCurrent;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    bool savedThemeValue = _preferences.getBool('isDarkTheme') ?? false;
    setState(() {
      _isDark = savedThemeValue;
    });
  }

  Future<void> _saveThemeValue(bool value) async {
    final userService = Provider.of<ProviderService>(context, listen: false);
    userService.updateTheme(value);
    await _preferences.setBool('isDarkTheme', value);
  }

  void onStateChanged(bool isDarkModeEnabled) {
    setState(() {
      _isDark = isDarkModeEnabled;
      _saveThemeValue(isDarkModeEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: TeamFinderAppBar(
          titleText: "Settings",
          isDark: _isDark,
          implyLeading: true,
          height: 55,
          showNotificationCount: false,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                const Divider(
                  thickness: 4,
                ),
                _SingleSection(
                  title: "Theme",
                  children: [
                    ListTile(
                      title: Text(_isDark ? "Dark Mode" : "Light Mode"),
                      leading: DayNightSwitcherIcon(
                        isDarkModeEnabled: _isDark,
                        onStateChanged: onStateChanged,
                      ),
                      trailing: DayNightSwitcher(
                        isDarkModeEnabled: _isDark,
                        onStateChanged: onStateChanged,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Preferences",
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: _CustomListTile(
                          title: "Notifications",
                          leading: Icon(Icons.notifications_none_rounded),
                          children: [
                            ListTile(
                              title: Text("item1"),
                            ),
                            ListTile(
                              title: Text("item2"),
                            )
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: _CustomListTile(
                          title: "Chat",
                          leading: Icon(Icons.messenger_outline_rounded),
                          children: [
                            ListTile(
                              title: Text("item1"),
                            ),
                            ListTile(
                              title: Text("item2"),
                            )
                          ]),
                    ),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Privacy & Security",
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: _CustomListTile(
                          title: "Security Status",
                          leading: Icon(Icons.lock_outline_rounded),
                          children: [
                            ListTile(
                              title: Text("item1"),
                            ),
                            ListTile(
                              title: Text("item2"),
                            )
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: _CustomListTile(
                          title: "Profile",
                          leading: Icon(Icons.person_outline_rounded),
                          children: [
                            ListTile(
                              title: Text("item1"),
                            ),
                            ListTile(
                              title: Text("item2"),
                            )
                          ]),
                    ),

                    // _CustomListTile(
                    //     title: "Calling", icon: Icons.phone_outlined),
                    // _CustomListTile(
                    //     title: "People", icon: Icons.contacts_outlined),
                    // _CustomListTile(
                    //     title: "Calendar", icon: Icons.calendar_today_rounded)
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: _CustomListTile(
                          title: "Help & Feedback",
                          leading: Icon(Icons.help_outline_rounded),
                          children: [
                            ListTile(
                              title: Text("item1"),
                            ),
                            ListTile(
                              title: Text("item2"),
                            )
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: _CustomListTile(
                        title: "About",
                        leading: Icon(Icons.info_outline_rounded),
                        children: [
                          ListTile(
                            title: Text("item1"),
                          ),
                          ListTile(
                            title: Text("item2"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> children;
  const _CustomListTile({
    Key? key,
    required this.title,
    required this.leading,
    this.trailing,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text(title),
      ),
      leading: leading,
      trailing: trailing,
      childrenPadding: const EdgeInsets.only(left: 50),
      children: children,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

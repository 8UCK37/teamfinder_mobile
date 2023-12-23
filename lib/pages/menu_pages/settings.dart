import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamfinder_mobile/services/data_service.dart';
import '../../widgets/custom_appbar.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  bool isDarkCurrent;
  SettingsPage({Key? key, required this.isDarkCurrent}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _preferences;
  late bool _isDark=widget.isDarkCurrent;
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
          height:55,
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
                  title: "General",
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
                    const _CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    const _CustomListTile(
                        title: "Security Status",
                        icon: CupertinoIcons.lock_shield),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "App component",
                  children: [
                    _CustomListTile(
                        title: "Profile", icon: Icons.person_outline_rounded),
                    _CustomListTile(
                        title: "Chat", icon: Icons.message_outlined),
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
                    _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                    _CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
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
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {},
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

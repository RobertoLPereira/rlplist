import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'layout.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/settings.dart';
import 'pages/items.dart';
import 'pages/item-add.dart';
import 'pages/item-edit.dart';

void main() => runApp(ThizerList());

class ThizerList extends StatefulWidget {
  @override
  State<ThizerList> createState() => _ThizerListState();
}

class _ThizerListState extends State<ThizerList> {
  String _deviceId;

  @override
  // ignore: override_on_non_overriding_member
  void initState() {
    super.initState();
    initPlatformState();
  }

  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    AboutPage.tag: (context) => AboutPage(),
    SettingsPage.tag: (context) => SettingsPage(),
    ItemsPage.tag: (context) => ItemsPage(),
    ItemAddPage.tag: (context) => ItemAddPage(),
    ItemEditPage.tag: (context) => ItemEditPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThizerList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Layout.primary(),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Layout.primary(),
          ),
          bodyText2: TextStyle(fontSize: 14),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Layout.secondary()),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'),
        Locale('en'),
      ],
      home: HomePage(),
      routes: routes,
    );
  }

  Future<void> initPlatformState() async {
    String deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }
}

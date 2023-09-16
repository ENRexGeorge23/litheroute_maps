import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:litheroute_maps/MyColors.dart';
import 'package:litheroute_maps/screens/store_table/store_lists.dart';
import 'package:litheroute_maps/screens/store_location/store_location_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/splash.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await dotenv.load(fileName: "assets/config/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mapbox Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorSchemeSeed: MyColors.primaryColor,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
            color: MyColors.primaryColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const Splash(),
        routes: {
          '/splash': (context) => const Splash(),
          '/store-lists': (context) => const StoreListsScreen(),
          '/store-location-map': (context) => const StoreLocationMapScreen(),
        });
  }
}

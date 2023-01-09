import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_app/locator/locator.dart';
import 'package:flutter_weather_app/providers/weather_provider.dart';
import 'package:flutter_weather_app/repository/weather_repo.dart';
import 'package:flutter_weather_app/screens/weather_screen.dart';
import 'package:provider/provider.dart';

void main() {
  setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (c) =>
                WeatherProvider(weatherRepo: getIt.get<WeatherRepo>()))
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (context, _) {
            return MaterialApp(
              title: 'Weather App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const WeatherScreen(),
            );
          }),
    );
  }
}

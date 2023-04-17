import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';

import 'logic/route_handler.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlaceHolder',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: "McLaren",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Color.fromRGBO(0, 0, 0, 0.50),
              ),
            ],
            fontSize: 25,
          ),
          titleMedium: TextStyle(
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Color.fromRGBO(0, 0, 0, 0.50),
              ),
            ],
            fontSize: 30,
          ),
          titleLarge: TextStyle(
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 2,
                color: Color.fromRGBO(255, 204, 77, 0.50),
              ),
            ],
            color: Color.fromRGBO(255, 204, 77, 1),
            fontSize: 40,
          ),
        ),
      ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}

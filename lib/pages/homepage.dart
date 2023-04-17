import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../constants/route_classes.dart';
import '../constants/values.dart';
import '../logic/data_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);
  bool load = true;

  void loadBefore() async {
    await loadAll();
    String temp = await rootBundle.loadString('assets/lang.json');
    lang = jsonDecode(temp);
    load = false;
    setState(() {});
  }

  void reload() {
    purge();
    loadAll();
  }

  @override
  void initState() {
    loadBefore();
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(93, 202, 124, 1),
              Color.fromRGBO(58, 84, 180, 1),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: load
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    Hero(
                        tag: "2b",
                        child: Image.asset("assets/images/2beer.png")),
                    const Spacer(),
                    Text(
                      lang[langSelected]!["homeScreen"]!["title"] ?? "0",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteName.selectGame);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        shadowColor: const Color.fromRGBO(255, 204, 77, 0.75),
                        elevation: 5.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          lang[langSelected]!["homeScreen"]!["play"] ?? "0",
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        reload();
                      },
                      child: Text(
                        lang[langSelected]!["homeScreen"]!["how2play"] ?? "0",
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                          lang[langSelected]!["homeScreen"]!["credit"] ?? "0"),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        overlayOpacity: 0.3,
        overlayColor: Colors.black,
        animationCurve: Curves.elasticInOut,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.settings),
            labelStyle: const TextStyle(fontSize: 15, shadows: []),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
            label: lang[langSelected]!["homeScreen"]!["settings"] ?? "0",
            onTap: () {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.person),
            labelStyle: const TextStyle(fontSize: 15, shadows: []),
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
            label: lang[langSelected]!["homeScreen"]!["player"] ?? "0",
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.library,
                arguments: LibraryParam(to: Libraries.player),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.rule),
            labelStyle: const TextStyle(fontSize: 15, shadows: []),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            label: lang[langSelected]!["homeScreen"]!["rules"] ?? "0",
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.library,
                arguments: LibraryParam(to: Libraries.rule),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.tag),
            labelStyle: const TextStyle(fontSize: 15, shadows: []),
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            label: lang[langSelected]!["homeScreen"]!["tags"] ?? "0",
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.library,
                arguments: LibraryParam(to: Libraries.tag),
              );
            },
          ),
        ],
      ),
    );
  }
}

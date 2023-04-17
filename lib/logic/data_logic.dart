import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/classes.dart';
import '../constants/values.dart';
import 'id_handler.dart';

Future<void> purge() async {
  // clean local storage
  if (kIsWeb) return;
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File("${directory.path}/info.drink");
  await file.writeAsString("");
}

Future<void> loadAll() async {
  if (!kIsWeb) return loadAllLocal();
}

void clearAll() {
  allId.clear();
  alltagsId.clear();
  allRule.clear();
  allTag.clear();
  allPlayer.clear();
}

Future<void> loadAllFirebase() async {}

Future<void> loadAllLocal() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File("${directory.path}/info.drink");

  clearAll();

  try {
    String stringData = await file.readAsString();

    Map data = jsonDecode(stringData);

    //Load all Players

    List rawPlayers = data["players"] as List;

    for (var raw in rawPlayers) {
      List<int> tempTag = [];
      for (var element in raw["nopeTags"] as List) {
        tempTag.add(element as int);
      }
      int id = raw["id"] as int;
      for (var element in allId) {
        if (element == id) {
          id = getUnusedId();
          break;
        }
      }
      allId.add(id);
      allPlayer.add(
        Player(
          id: id,
          name: raw["name"] as String,
          tagsToAvoid: tempTag,
          orientation: Orientations.values[raw["orr"] as int],
          genre: Genre.values[raw["genre"] as int],
        ),
      );
    }

    //Load all Rules

    List rawRules = data["rules"] as List;

    for (var raw in rawRules) {
      List<int> tempTags = [];
      for (var element in raw["tagsId"] as List) {
        tempTags.add(element as int);
      }
      int id = raw["id"] as int;
      for (var element in allId) {
        if (element == id) {
          id = getUnusedId();
          break;
        }
      }
      int? difficulty = raw["difficulty"] as int;
      allRule.add(
        Rule(
          name: raw["name"] as String,
          description: raw["description"] as String,
          id: id,
          tags: tempTags,
          difficulty: difficulty,
        ),
      );
    }

    List rawTags = data["tags"] as List;

    for (var raw in rawTags) {
      int id = raw["id"] as int;
      for (var element in allId) {
        if (element == id) {
          id = getUnusedId(isTag: true);
          break;
        }
      }
      allTag.add(
        Tag(
          id: id,
          name: raw["name"] as String,
          description: raw["description"] as String,
        ),
      );
    }

    langSelected = data["settings"]["lang"] ?? "fr";
  } catch (e) {
    print("Couldn't read ${directory.path}/info.drink");
    print(e);

    final String info = await rootBundle.loadString('assets/default.json');

    await file.writeAsString(info);

    loadAllLocal();
  }
}

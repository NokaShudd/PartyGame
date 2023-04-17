import 'package:flutter/material.dart';

import 'classes.dart';

const Color blue = Color.fromARGB(255, 56, 152, 163);
const Color green = Color.fromARGB(255, 57, 174, 90);

List<int> allId = [];
List<Player> allPlayer = [];
List<Rule> allRule = [];
List<Tag> allTag = [];
List<int> alltagsId = [];

String langSelected = "en";

Map<String, dynamic> lang = {
  "en": {
    "homeScreen": {
      "title": "PlaceHolder",
      "play": "Play",
      "how2play": "How to play",
      "Credit": "Credit"
    },
  },
  "fr": {
    "homeScreen": {
      "title": "PlaceHolder",
      "play": "Jouer",
      "how2play": "Comment jouer",
      "Credit": "Crédits"
    },
  }
};

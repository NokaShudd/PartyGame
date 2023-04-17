import 'dart:math';

import '../constants/classes.dart';
import '../constants/values.dart';

String personToString(Person person) {
  if (lang[langSelected]!["classe"] != null) {
    return lang[langSelected]!["classe"]["person"][person.name];
  }
  switch (person) {
    case Person.sameSex:
      return "someone with the same genre";
    case Person.otherSex:
      return "someone with another genre";
    case Person.sameOr:
      return "someone with the same orientation";
    case Person.otherOr:
      return "someone with another orientation";
    case Person.attracted:
      return "someone the player could be attracted";
    case Person.bothAttracted:
      return "someone who could get attracted";
    case Person.nonAttracted:
      return "someone the player won't get attracted";
    default:
      return "anyone";
  }
}

String readDescriptionForFocus(String description) {
  String newString = "";
  String endString = "";
  List<String> split1 = description.split("§");
  bool done = false;
  for (var i = 0; i < split1.length; i++) {
    if (i + 1 < split1.length) {
      if (!done) {
        newString += split1[i] + split1[i + 1];
      }
      done = !done;
    } else {
      newString += split1[i];
    }
  }
  bool done2 = false;
  List<String> split2 = newString.split("%");
  for (var i = 0; i < split2.length; i++) {
    if (i + 1 < split2.length) {
      if (!done2) {
        endString += split2[i] +
            personToString(
              Person.values[int.parse(split2[i + 1])],
            );
      }
      done2 = !done2;
    } else {
      endString += split2[i];
    }
  }
  return endString;
}

String readDescription(
  String description, {
  int add = 0,
  List<Player> players = const [],
  Player? player,
}) {
  String newString = "";
  String endString = "";
  List<String> split1 = description.split("§");
  bool done = false;
  for (var i = 0; i < split1.length; i++) {
    if (i + 1 < split1.length) {
      if (!done) {
        newString += "${split1[i]}${int.parse(split1[i + 1]) + add}";
      }
      done = !done;
    } else {
      newString += split1[i];
    }
  }
  bool done2 = false;
  List<String> split2 = newString.split("%");
  for (var i = 0; i < split2.length; i++) {
    if (i + 1 < split2.length) {
      if (!done2) {
        endString += split2[i];
        if (player != null) {
          endString += nameFromCommand(
            Person.values[int.parse(split2[i + 1])],
            players,
            player,
          );
        } else {
          endString += personToString(Person.values[int.parse(split2[i + 1])]);
        }
      }
      done2 = !done2;
    } else {
      endString += split2[i];
    }
  }
  return endString.replaceAll(
    "||",
    lang[langSelected]!["classe"]!["or"] ?? "or",
  );
}

List<Player> getAttracted(List<Player> players, Genre genre, Orientations or) {
  switch (or) {
    case Orientations.hetero:
      if (genre == Genre.male) {
        return players
            .where((element) => element.genre == Genre.female)
            .toList();
      }
      return players.where((element) => element.genre == Genre.male).toList();
    case Orientations.gay:
      if (genre == Genre.female) {
        return players
            .where((element) => element.genre == Genre.female)
            .toList();
      }
      return players.where((element) => element.genre == Genre.male).toList();
    default:
      return players;
  }
}

List<Player> getNonAttracted(
  List<Player> players,
  Genre genre,
  Orientations or,
) {
  switch (or) {
    case Orientations.hetero:
      if (genre == Genre.female) {
        return players
            .where((element) => element.genre == Genre.female)
            .toList();
      }
      return players.where((element) => element.genre == Genre.male).toList();
    case Orientations.gay:
      if (genre == Genre.male) {
        return players
            .where((element) => element.genre == Genre.female)
            .toList();
      }
      return players.where((element) => element.genre == Genre.male).toList();
    default:
      return players;
  }
}

List<Player> getBothAttracted(
    List<Player> players, Genre genre, Orientations or) {
  switch (or) {
    case Orientations.hetero:
      if (genre == Genre.male) {
        return players
            .where(
              (element) => (element.genre == Genre.female &&
                  element.orientation != Orientations.gay),
            )
            .toList();
      }
      return players
          .where(
            (element) => (element.genre == Genre.male &&
                element.orientation != Orientations.gay),
          )
          .toList();
    case Orientations.gay:
      if (genre == Genre.female) {
        return players
            .where(
              (element) => (element.genre == Genre.female &&
                  element.orientation != Orientations.hetero),
            )
            .toList();
      }
      return players
          .where(
            (element) => (element.genre == Genre.male &&
                element.orientation != Orientations.hetero),
          )
          .toList();
    default:
      return players;
  }
}

Player? getRandomIn(List<Player> players) {
  if (players.isEmpty) return null;
  return players[Random().nextInt(players.length)];
}

String nameFromCommand(Person person, List<Player> players, Player player) {
  Orientations or = player.orientation;
  Genre genre = player.genre;
  Player? playerGoal;
  List<Player> newPlayers =
      players.where((element) => element != player).toList();

  switch (person) {
    case Person.anyone:
      playerGoal = getRandomIn(newPlayers);
      break;
    case Person.sameOr:
      playerGoal = getRandomIn(
        newPlayers.where((element) => element.orientation == or).toList(),
      );
      break;
    case Person.sameSex:
      playerGoal = getRandomIn(
        newPlayers.where((element) => element.genre == genre).toList(),
      );
      break;
    case Person.otherOr:
      playerGoal = getRandomIn(
        newPlayers.where((element) => element.orientation != or).toList(),
      );
      break;
    case Person.otherSex:
      playerGoal = getRandomIn(
        newPlayers.where((element) => element.genre != genre).toList(),
      );
      break;
    case Person.attracted:
      playerGoal = getRandomIn(
        getAttracted(newPlayers, genre, or),
      );
      break;
    case Person.nonAttracted:
      playerGoal = getRandomIn(getNonAttracted(newPlayers, genre, or));
      break;
    case Person.bothAttracted:
      playerGoal = getRandomIn(getBothAttracted(newPlayers, genre, or));
      break;
    default:
      playerGoal = newPlayers[0];
  }
  if (playerGoal != null) {
    return playerGoal.name;
  }
  playerGoal = getRandomIn(newPlayers);
  if (playerGoal != null) {
    return playerGoal.name;
  }
  return "Erreur";
}

void getAllTagsId() {
  alltagsId = [];
  for (Tag tag in allTag) {
    alltagsId.add(tag.id);
  }
}

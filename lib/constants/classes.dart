import '../logic/id_handler.dart';

enum Type { player, rule, tag }

enum Blocks {
  action,
  person,
  number,
}

enum Person {
  sameSex,
  otherSex,
  sameOr,
  otherOr,
  attracted,
  bothAttracted,
  nonAttracted,
  anyone,
}

enum Orientations {
  hetero,
  gay,
  by,
}

enum Genre {
  male,
  female,
  other,
}

class Player {
  Player({
    required this.id,
    required this.name,
    required this.orientation,
    required this.genre,
    required this.tagsToAvoid,
  });

  final int id;
  String name;
  Orientations orientation;
  Genre genre;
  List<int> tagsToAvoid;

  factory Player.temporary(
    String name, {
    Orientations orientation = Orientations.by,
    Genre genre = Genre.other,
  }) =>
      Player(
        id: getUnusedId(),
        name: name.trim(),
        orientation: orientation,
        genre: genre,
        tagsToAvoid: [],
      );
}

class Rule {
  Rule({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.tags,
  });

  final int id;
  int difficulty;
  String name;
  String description;
  List<int> tags;

  factory Rule.temporary(
    String name,
    String description,
  ) =>
      Rule(
        id: getUnusedId(),
        name: name,
        difficulty: 0,
        description: description,
        tags: [],
      );

  factory Rule.permanent(
    String name,
    String description,
    List<int> tags,
    int difficulty,
  ) =>
      Rule(
        id: getUnusedId(),
        name: name,
        difficulty: difficulty,
        description: description,
        tags: tags,
      );
}

class Tag {
  Tag({required this.id, required this.name, required this.description});
  final int id;
  String name;
  String description;

  factory Tag.create(String name, String description) => Tag(
        id: getUnusedId(isTag: true),
        name: name,
        description: description,
      );
}

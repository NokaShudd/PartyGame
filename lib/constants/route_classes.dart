import 'classes.dart';

class RouteName {
  static const playGame = "/Game";
  static const focus = '/Focus';
  static const selectGame = "/SelectGame";
  static const library = "/Library";
  static const selectPlayer = "/SelectPlayer";
}

enum Libraries {
  tag,
  player,
  rule,
}

enum TagMode {
  all,
  favorite,
  manual,
}

class SelectPlayerParam {
  SelectPlayerParam({
    required this.difficulty,
    required this.tagmode,
    this.tags = const [],
  });

  List<bool> difficulty;
  TagMode tagmode;
  List<Tag> tags;
}

class LibraryParam {
  LibraryParam({
    required this.to,
  });

  Libraries to;
}

class FocusParam {
  FocusParam({
    required this.type,
    required this.element,
  });

  Type type;
  final dynamic element;
}

class GameParam {
  GameParam({
    required this.difficulty,
    required this.tagmode,
    required this.players,
    this.tags = const [],
  });

  List<bool> difficulty;
  TagMode tagmode;
  List<Tag> tags;
  List<Player> players;
}

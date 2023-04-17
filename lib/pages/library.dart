import 'dart:async';
import 'package:flutter/material.dart';

import '../constants/classes.dart';
import '../constants/route_classes.dart';
import '../constants/values.dart';
import '../logic/game_logic.dart';
import '../logic/id_handler.dart';
import 'focus.dart';

class Library extends StatefulWidget {
  const Library({
    Key? key,
    required this.to,
  }) : super(key: key);

  final Libraries to;

  @override
  State<Library> createState() => _LibraryState();
}

String getStringTagsPlayers(Player player, Map<String, dynamic> txt) {
  String output = txt["avoidFol"];
  int error = 0;
  if (player.tagsToAvoid.isEmpty) {
    return txt["avoidNone"];
  }
  for (int element in player.tagsToAvoid) {
    try {
      Tag tag = allTag.firstWhere((tag) => tag.id == element);
      output += "${tag.name}, ";
    } catch (e) {
      error++;
    }
  }
  if (error == 0) {
    return output.substring(0, output.length - 2);
  }
  return "$output${txt["avoidErr_1"]} $error ${txt["avoidErr_1"]}";
}

String getStringTagsRule(Rule rule, Map<String, dynamic> txt) {
  String output = txt["tagsFol"];
  int error = 0;

  if (rule.tags.isEmpty) {
    return txt["noTags"] ?? "Doesn't have any tags";
  }
  for (int element in rule.tags) {
    try {
      Tag tag = allTag.firstWhere((tag) => tag.id == element);
      output += " ${tag.name},";
    } catch (e) {
      error++;
    }
  }
  if (error == 0) {
    return output.substring(0, output.length - 1);
  }
  if (error == rule.tags.length) {
    return txt["tagsFol"] + " " + txt["1Dead"];
  }
  return "$output${txt["avoidErr_1"]} $error ${txt["avoidErr_1"]}";
}

String getStringTagFollowed(Tag tag, Map<String, dynamic> txt) {
  int numb = 0;
  for (Rule rule in allRule) {
    for (int tagId in rule.tags) {
      if (tagId == tag.id) {
        numb++;
      }
    }
  }
  if (numb == 0) {
    return txt["noRule"];
  }
  return "$numb ${numb > 1 ? txt['rulesUse'] : txt['ruleUse']}";
}

class _LibraryState extends State<Library> with SingleTickerProviderStateMixin {
  bool searching = false;
  List<String> tabs = <String>['Players', 'Rules', 'Tags'];
  TextEditingController namecontroller = TextEditingController();
  TextEditingController desccontrollet = TextEditingController();
  late TabController tabController;
  Map<String, dynamic> txt = lang[langSelected]!["libraryScreen"];

  void showEdit(Type type, var element, int index) {
    Navigator.pushNamed(
      context,
      RouteName.focus,
      arguments: FocusParam(type: type, element: element),
    ).then((val) {
      Timer(const Duration(milliseconds: 200), () => setState(() {}));
    });
  }

  @override
  void initState() {
    tabs = [txt["player"], txt["rules"], txt["tags"]];
    tabController = TabController(length: 3, vsync: this);
    if (widget.to != Libraries.player) {
      tabController.animateTo(widget.to == Libraries.rule ? 1 : 2);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        searching = !searching;
                      });
                    },
                  ),
                  const CloseButton()
                ],
                backgroundColor: green,
                title: searching
                    ? Container(
                        height: 45,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Color.fromRGBO(58, 84, 180, 1),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(),
                        ),
                      )
                    : Text(
                        txt["library"],
                        style: const TextStyle(fontSize: 25, shadows: []),
                      ),
                bottom: TabBar(
                  controller: tabController,
                  indicatorColor: const Color.fromRGBO(58, 84, 180, 1),
                  tabs: tabs.map((e) => Tab(text: e)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: allPlayer.length,
              itemBuilder: (context, index) {
                Player pl = allPlayer[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: const Center(child: Icon(Icons.delete)),
                  ),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      allId.removeWhere(
                          (element) => element == allPlayer[index].id);
                      allPlayer.removeAt(index);
                    });
                  },
                  child: PlayerTile(
                    pl: pl,
                    index: index,
                  ),
                );
              },
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: allRule.length,
              itemBuilder: (context, index) {
                Rule rul = allRule[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: const Center(child: Icon(Icons.delete)),
                  ),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      allId.removeWhere(
                          (element) => element == allRule[index].id);
                      allRule.removeAt(index);
                    });
                  },
                  child: RuleWidget(rul: rul, index: index),
                );
              },
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: allTag.length,
              itemBuilder: (context, index) {
                Tag tag = allTag[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: const Center(child: Icon(Icons.delete)),
                  ),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      for (Rule rule in allRule) {
                        List<int> newTag = [];
                        for (var element in rule.tags) {
                          if (element != allTag[index].id) {
                            newTag.add(element);
                          }
                        }
                        rule.tags = newTag;
                      }
                      for (Player player in allPlayer) {
                        List<int> newTag = [];
                        for (var element in player.tagsToAvoid) {
                          if (element != allPlayer[index].id) {
                            newTag.add(element);
                          }
                        }
                        player.tagsToAvoid = newTag;
                      }

                      alltagsId.removeWhere(
                          (element) => element == allTag[index].id);
                      allTag.removeAt(index);
                    });
                  },
                  child: TagWidget(
                    tag: tag,
                    index: index,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (tabController.index == 0) {
            Player newPlayer = Player(
              id: getUnusedId(),
              name: txt["newPlayer"],
              orientation: Orientations.by,
              genre: Genre.other,
              tagsToAvoid: [],
            );
            allPlayer.add(newPlayer);
            showEdit(Type.player, newPlayer, allPlayer.length - 1);
          } else if (tabController.index == 1) {
            Rule newRule = Rule.permanent(txt["newRule"], "", [], 0);
            allRule.add(newRule);
            showEdit(Type.rule, newRule, allRule.length - 1);
          } else {
            Tag newTag = Tag.create(txt["newTag"], "");
            allTag.add(newTag);
            showEdit(Type.tag, newTag, allTag.length - 1);
          }
        },
        backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TagWidget extends StatefulWidget {
  const TagWidget({
    Key? key,
    required this.tag,
    required this.index,
  }) : super(key: key);

  final Tag tag;
  final int index;

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  Map<String, dynamic> txt = lang[langSelected]!["libraryScreen"];
  void showEdit(Type type, var element, int index) {
    Navigator.pushNamed(
      context,
      RouteName.focus,
      arguments: FocusParam(type: type, element: element),
    ).then((val) {
      Timer(const Duration(milliseconds: 200), () => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showEdit(Type.tag, allTag[widget.index], widget.index);
      },
      title: Text(
        widget.tag.name,
        style: const TextStyle(fontSize: 25, shadows: []),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tag.description,
            style: const TextStyle(fontSize: 20, shadows: []),
          ),
          Text(
            getStringTagFollowed(widget.tag, txt),
            style: const TextStyle(fontSize: 15, shadows: []),
          )
        ],
      ),
    );
  }
}

class RuleWidget extends StatefulWidget {
  const RuleWidget({
    Key? key,
    required this.rul,
    required this.index,
  }) : super(key: key);

  final Rule rul;
  final int index;

  @override
  State<RuleWidget> createState() => _RuleWidgetState();
}

class _RuleWidgetState extends State<RuleWidget> {
  Map<String, dynamic> txt = lang[langSelected]!["libraryScreen"];
  void showEdit(Type type, var element, int index) {
    Navigator.pushNamed(
      context,
      RouteName.focus,
      arguments: FocusParam(type: type, element: element),
    ).then((val) {
      Timer(const Duration(milliseconds: 200), () => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showEdit(Type.rule, allRule[widget.index], widget.index);
      },
      title: Text(
        widget.rul.name,
        style: const TextStyle(fontSize: 25, shadows: []),
      ),
      leading: CircleAvatar(
        child: widget.rul.difficulty > 0
            ? Text("${widget.rul.difficulty}/5")
            : const Icon(Icons.child_friendly),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            readDescription(widget.rul.description),
            style: const TextStyle(fontSize: 20, shadows: []),
          ),
          Text(
            getStringTagsRule(widget.rul, txt),
            style: const TextStyle(fontSize: 15, shadows: []),
          )
        ],
      ),
    );
  }
}

class PlayerTile extends StatefulWidget {
  const PlayerTile({
    Key? key,
    required this.pl,
    required this.index,
  }) : super(key: key);

  final Player pl;
  final int index;

  @override
  State<PlayerTile> createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  Map<String, dynamic> txt = lang[langSelected]!["libraryScreen"];
  void showEdit(Type type, var element, int index) {
    Navigator.pushNamed(
      context,
      RouteName.focus,
      arguments: FocusParam(type: type, element: element),
    ).then((value) {
      Timer(const Duration(milliseconds: 200), () => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showEdit(Type.player, allPlayer[widget.index], widget.index);
      },
      title: Text(
        widget.pl.name,
        style: const TextStyle(fontSize: 25, shadows: []),
      ),
      leading: Hero(
        tag: 'genre_p_${widget.index}',
        child: widget.pl.genre == Genre.male
            ? const Icon(Icons.male)
            : widget.pl.genre == Genre.female
                ? const Icon(Icons.female)
                : const Icon(Icons.circle_outlined),
      ),
      subtitle: Text(
        getStringTagsPlayers(widget.pl, txt),
        style: const TextStyle(fontSize: 15, shadows: []),
      ),
    );
  }
}

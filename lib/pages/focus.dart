import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/classes.dart';
import '../constants/values.dart';
import '../logic/game_logic.dart';

class FocusOn extends StatefulWidget {
  const FocusOn({
    Key? key,
    required this.type,
    required this.element,
  }) : super(key: key);

  final Type type;
  final dynamic element;

  @override
  State<FocusOn> createState() => _FocusOnState();
}

class _FocusOnState extends State<FocusOn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Map<int, bool> tagSelected = {};
  Map<String, dynamic> txt = lang[langSelected]!["focus"];

  @override
  void initState() {
    switch (widget.type) {
      case Type.player:
        Player player = widget.element as Player;
        nameController.text = player.name;
        for (Tag tag in allTag) {
          tagSelected[tag.id] = player.tagsToAvoid.any(
            (element) => (element == tag.id),
          );
        }
        break;
      case Type.rule:
        Rule rule = widget.element as Rule;
        nameController.text = rule.name;
        for (Tag tag in allTag) {
          tagSelected[tag.id] = rule.tags.any(
            (element) => (element == tag.id),
          );
        }
        break;
      case Type.tag:
        Tag tag = widget.element as Tag;
        nameController.text = tag.name;
        descController.text = tag.description;
        break;
      default:
    }
    super.initState();
  }

  int getnumbRulePossible(Player player) {
    int numb = 0;
    for (Rule rule in allRule) {
      bool can = true;
      for (int rule_tag_id in rule.tags) {
        for (int tag in player.tagsToAvoid) {
          if (tag == rule_tag_id) {
            can = false;
            break;
          }
        }
        if (!can) {
          break;
        }
      }
      if (can) {
        numb++;
      }
    }
    return numb;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case Type.player:
        Player player = widget.element as Player;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 58, 168, 180),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
            title: Text(
              player.name,
              style: const TextStyle(shadows: [], fontSize: 20),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              ListTile(
                title: Text(txt["name"]),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: txt["enterName"],
                          border: InputBorder.none,
                        ),
                        onSubmitted: (String? name) {
                          if (name != null && name.isNotEmpty) {
                            player.name = name;
                            setState(() {});
                          }
                        },
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(txt["genre"]),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 25.0,
                  ),
                  child: CupertinoSlidingSegmentedControl(
                      backgroundColor: Colors.black.withOpacity(0.2),
                      groupValue: player.genre,
                      thumbColor: const Color(0xFFFFCC4D),
                      children: const {
                        Genre.male: Icon(Icons.male),
                        Genre.female: Icon(Icons.female),
                        Genre.other: Icon(Icons.question_mark)
                      },
                      onValueChanged: (Genre? newVal) {
                        setState(() {
                          player.genre = newVal!;
                          if (newVal == Genre.other) {
                            player.orientation = Orientations.by;
                          }
                        });
                      }),
                ),
              ),
              player.genre == Genre.other
                  ? ListTile(
                      title: Text(txt["orientations"]),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Bi"),
                        ],
                      ),
                    )
                  : ListTile(
                      title: Text(txt["orientation"]),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 25.0,
                        ),
                        child: CupertinoSlidingSegmentedControl(
                          backgroundColor: Colors.black.withOpacity(0.2),
                          groupValue: player.orientation,
                          thumbColor: const Color(0xFFFFCC4D),
                          children: const {
                            Orientations.hetero: Text(
                              "Hétéro",
                              style: TextStyle(fontSize: 12),
                            ),
                            Orientations.gay: Text(
                              "Gay",
                              style: TextStyle(fontSize: 12),
                            ),
                            Orientations.by: Text(
                              "Bi",
                              style: TextStyle(fontSize: 12),
                            ),
                          },
                          onValueChanged: (Orientations? newVal) {
                            setState(() {
                              player.orientation = newVal!;
                            });
                          },
                        ),
                      ),
                    ),
              ListTile(
                title: Text(txt["tags2Avoid"]),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.vertical,
                    children: allTag.map((tag) {
                      return FilterChip(
                        selectedColor: const Color(0xFFFFCC4D),
                        selected: tagSelected[tag.id]!,
                        label: Text(tag.name),
                        onSelected: (val) {
                          setState(() {
                            tagSelected[tag.id] = !tagSelected[tag.id]!;
                            player.tagsToAvoid.clear();
                            for (Tag _tag in allTag) {
                              if (tagSelected[_tag.id]!) {
                                player.tagsToAvoid.add(_tag.id);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              ListTile(
                title: Text(txt["usable"]),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${txt['usableDesc_0']} ${getnumbRulePossible(player)} "
                    "${txt['usableDesc_1']}",
                  ),
                ),
              )
            ],
          ),
        );
      case Type.rule:
        Rule rule = widget.element as Rule;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 58, 168, 180),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
            title: Text(
              rule.name,
              style: const TextStyle(shadows: [], fontSize: 20),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              ListTile(
                title: Text(txt["name"]),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: txt["enterName"],
                          border: InputBorder.none,
                        ),
                        onSubmitted: (String? name) {
                          if (name != null && name.isNotEmpty) {
                            rule.name = name;
                            setState(() {});
                          }
                        },
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(txt["rule"]),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          title: Text(txt["do"]),
                          subtitle: DoSubWidget(
                            rule: rule,
                            refreshRoot: () {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          title: Text(txt["or"]),
                          subtitle: OrSubWidget(
                            rule: rule,
                            refreshRoot: () {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(txt["tags"]),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.vertical,
                    children: allTag.map((tag) {
                      return FilterChip(
                        selectedColor: const Color(0xFFFFCC4D),
                        selected: tagSelected[tag.id]!,
                        label: Text(tag.name),
                        onSelected: (val) {
                          setState(() {
                            tagSelected[tag.id] = !tagSelected[tag.id]!;
                            rule.tags.clear();
                            for (Tag _tag in allTag) {
                              if (tagSelected[_tag.id]!) {
                                rule.tags.add(_tag.id);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              ListTile(
                title: Text(txt["diff"]),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 25.0,
                  ),
                  child: CupertinoSlidingSegmentedControl(
                    backgroundColor: Colors.black.withOpacity(0.2),
                    groupValue: rule.difficulty,
                    thumbColor: const Color(0xFFFFCC4D),
                    children: const {
                      0: Icon(Icons.child_friendly),
                      1: Text(
                        "1",
                        style: TextStyle(fontSize: 12),
                      ),
                      2: Text(
                        "2",
                        style: TextStyle(fontSize: 12),
                      ),
                      3: Text(
                        "3",
                        style: TextStyle(fontSize: 12),
                      ),
                      4: Text(
                        "4",
                        style: TextStyle(fontSize: 12),
                      ),
                      5: Text(
                        "5",
                        style: TextStyle(fontSize: 12),
                      ),
                    },
                    onValueChanged: (int? newVal) {
                      setState(() {
                        rule.difficulty = newVal!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      case Type.tag:
        Tag tag = widget.element as Tag;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 58, 168, 180),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
            title: Text(
              tag.name,
              style: const TextStyle(shadows: [], fontSize: 20),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text(txt["name"]),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: txt["enterName"],
                          border: InputBorder.none,
                        ),
                        onSubmitted: (String? name) {
                          if (name != null && name.isNotEmpty) {
                            tag.name = name;
                            setState(() {});
                          }
                        },
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(txt["desc"]),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          hintText: txt["enterDesc"],
                          border: InputBorder.none,
                        ),
                        onSubmitted: (String? desc) {
                          if (desc != null && desc.isNotEmpty) {
                            tag.description = desc;
                            setState(() {});
                          }
                        },
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const Scaffold(
          backgroundColor: Colors.amber,
          body: Center(
            child: Text("Error ;_;"),
          ),
        );
    }
  }
}

class DoSubWidget extends StatefulWidget {
  const DoSubWidget({
    Key? key,
    required this.rule,
    required this.refreshRoot,
  }) : super(key: key);

  final Rule rule;
  final Function() refreshRoot;

  @override
  State<DoSubWidget> createState() => _DoSubWidgetState();
}

class _DoSubWidgetState extends State<DoSubWidget> {
  bool empty = true;
  List<Map<Blocks, dynamic>> actions = [];
  Map<String, dynamic> txt = lang[langSelected]!["focus"];

  String realActionsToString() {
    String out = '';

    for (Map<Blocks, dynamic> pair in actions) {
      switch (pair.keys.first) {
        case Blocks.number:
          out += "§${pair.values.first}§ ";
          break;
        case Blocks.person:
          out += "%${Person.values.indexWhere(
            (element) => (element == pair.values.first),
          )}% ";
          break;
        default:
          out += pair.values.first + " ";
      }
    }

    return out;
  }

  String actionsToString() {
    String out = '';

    for (Map<Blocks, dynamic> pair in actions) {
      switch (pair.keys.first) {
        case Blocks.person:
          out += "${personToString(pair.values.first)} ";
          break;
        default:
          out += pair.values.first + " ";
      }
    }

    return out;
  }

  @override
  void initState() {
    empty = widget.rule.description.isEmpty;
    super.initState();
  }

  void showEdit() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            color: const Color.fromRGBO(93, 202, 124, 1),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(txt["blocks"]),
                    subtitle: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      children: [
                        Draggable<Blocks>(
                          data: Blocks.action,
                          feedback: Container(
                            height: 50,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 110,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(txt["blockText"])),
                            ),
                          ),
                        ),
                        Draggable<Blocks>(
                          data: Blocks.person,
                          feedback: Container(
                            height: 50,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 110,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(txt["blockPerson"])),
                            ),
                          ),
                        ),
                        Draggable<Blocks>(
                          data: Blocks.number,
                          feedback: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(txt["blockNumber"])),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(txt["drop"]),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: DragTarget<Blocks>(
                            onAccept: (data) {
                              TextEditingController tec =
                                  TextEditingController();
                              showAddBlock(context, data, tec).then((value) {
                                setState(() {});
                              });
                            },
                            builder: (context, _, __) {
                              return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                    ),
                                  ),
                                  height: 75,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ));
                            },
                          ),
                        ),
                        Container(
                          height: 75,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (actions.isNotEmpty) {
                                  actions.removeLast();
                                }
                              });
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(txt["result"]),
                    subtitle: Text(actionsToString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (actions.isEmpty) {
                            Navigator.pop(context);
                            return;
                          }
                          if (widget.rule.description.isEmpty ||
                              widget.rule.description.split("||").length < 2) {
                            widget.rule.description = realActionsToString();
                            Navigator.pop(context);
                            widget.refreshRoot();
                            return;
                          }
                          List<String> temp =
                              widget.rule.description.split("||");
                          widget.rule.description =
                              "${realActionsToString()}||${temp[1]}";
                          widget.refreshRoot();
                          Navigator.pop(context);
                        },
                        child: actions.isNotEmpty
                            ? Text(
                                txt["confirm"],
                                style: const TextStyle(color: Colors.black),
                              )
                            : Text(
                                txt["back"],
                                style: const TextStyle(color: Colors.black),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((val) {
      widget.refreshRoot();
    });
  }

  Future<dynamic> showAddBlock(
    BuildContext context,
    Blocks data,
    TextEditingController tec,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          if (data == Blocks.action) {
            return SimpleDialog(
              backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
              title: Text(txt["text"]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tec,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (tec.text.isNotEmpty) {
                      actions.add({data: tec.text});
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(txt["confirm"]),
                )
              ],
            );
          }
          if (data == Blocks.number) {
            return SimpleDialog(
              backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
              title: Text(txt["number"]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tec,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if ((int.tryParse(tec.text) ?? 0) > 0) {
                      actions.add({data: tec.text});
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(txt["confirm"]),
                )
              ],
            );
          }
          if (data == Blocks.person) {
            return SimpleDialog(
              backgroundColor: const Color(0xFF5DCA7C),
              title: Text(txt["person"]),
              children: [
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.attracted});
                    Navigator.pop(context);
                  },
                  child: Text(
                    txt["desc_0"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.bothAttracted});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_1"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.nonAttracted});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_2"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.otherSex});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_3"],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.otherSex});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_4"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.otherOr});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_5"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.sameOr});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_6"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.anyone});
                    Navigator.pop(context);
                  },
                  child: Text(
                    txt["desc_7"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    txt["cancel"],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          }
          return Text("Error");
        });
  }

  @override
  Widget build(BuildContext context) {
    if (empty) {
      return ElevatedButton(onPressed: showEdit, child: Text(txt["add"]));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              readDescriptionForFocus(widget.rule.description.split("||")[0]),
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(onPressed: showEdit, icon: const Icon(Icons.edit))
          ],
        ),
      ),
    );
  }
}

class OrSubWidget extends StatefulWidget {
  const OrSubWidget({
    Key? key,
    required this.refreshRoot,
    required this.rule,
  }) : super(key: key);

  final Rule rule;
  final Function() refreshRoot;

  @override
  State<OrSubWidget> createState() => _OrSubWidgetState();
}

class _OrSubWidgetState extends State<OrSubWidget> {
  bool empty = true;
  List<Map<Blocks, dynamic>> actions = [];
  Map<String, dynamic> txt = lang[langSelected]!["focus"];

  String actionsToString() {
    String out = '';

    for (Map<Blocks, dynamic> pair in actions) {
      switch (pair.keys.first) {
        case Blocks.person:
          out += "${personToString(pair.values.first)} ";
          break;
        default:
          out += pair.values.first + " ";
      }
    }

    return out;
  }

  String realActionsToString() {
    String out = '';

    for (Map<Blocks, dynamic> pair in actions) {
      switch (pair.keys.first) {
        case Blocks.number:
          out += "§${pair.values.first}§ ";
          break;
        case Blocks.person:
          out += "%${Person.values.indexWhere(
            (element) => (element == pair.values.first),
          )}% ";
          break;
        default:
          out += pair.values.first + " ";
      }
    }

    return out;
  }

  Future<dynamic> showAddBlock(
    BuildContext context,
    Blocks data,
    TextEditingController tec,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          if (data == Blocks.action) {
            return SimpleDialog(
              backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
              title: Text(txt["text"]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tec,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (tec.text.isNotEmpty) {
                      actions.add({data: tec.text.trim()});
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(txt["confirm"]),
                )
              ],
            );
          }
          if (data == Blocks.number) {
            return SimpleDialog(
              backgroundColor: const Color.fromRGBO(93, 202, 124, 1),
              title: Text(txt["number"]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: tec,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if ((int.tryParse(tec.text) ?? 0) > 0) {
                      actions.add({data: tec.text});
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(txt["confirm"]),
                )
              ],
            );
          }
          if (data == Blocks.person) {
            return SimpleDialog(
              backgroundColor: const Color(0xFF5DCA7C),
              title: Text(txt["person"]),
              children: [
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.attracted});
                    Navigator.pop(context);
                  },
                  child: Text(
                    txt["desc_0"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.bothAttracted});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_1"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.nonAttracted});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_2"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.otherSex});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_3"],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.otherSex});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_4"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.otherOr});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_5"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.sameOr});
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    txt["desc_6"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    actions.add({data: Person.anyone});
                    Navigator.pop(context);
                  },
                  child: Text(
                    txt["desc_7"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    txt["cancel"],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          }
          return Text("Error");
        });
  }

  void showEdit() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            color: const Color.fromRGBO(93, 202, 124, 1),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(txt["blocks"]),
                    subtitle: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      children: [
                        Draggable<Blocks>(
                          data: Blocks.action,
                          feedback: Container(
                            height: 50,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 110,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(txt["blockText"])),
                            ),
                          ),
                        ),
                        Draggable<Blocks>(
                          data: Blocks.person,
                          feedback: Container(
                            height: 50,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 110,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(txt["blockPerson"])),
                            ),
                          ),
                        ),
                        Draggable<Blocks>(
                          data: Blocks.number,
                          feedback: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(txt["blockNumber"])),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(txt["drop"]),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: DragTarget<Blocks>(
                            onAccept: (data) {
                              TextEditingController tec =
                                  TextEditingController();
                              showAddBlock(context, data, tec).then((value) {
                                setState(() {});
                              });
                            },
                            builder: (context, _, __) {
                              return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                    ),
                                  ),
                                  height: 75,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ));
                            },
                          ),
                        ),
                        Container(
                          height: 75,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (actions.isNotEmpty) {
                                  actions.removeLast();
                                }
                              });
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(txt["result"]),
                    subtitle: Text(actionsToString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (actions.isEmpty) {
                            Navigator.pop(context);
                            return;
                          }
                          if (widget.rule.description.isEmpty ||
                              widget.rule.description.split("||").length < 2) {
                            widget.rule.description = realActionsToString();
                            Navigator.pop(context);
                            widget.refreshRoot();
                            return;
                          }
                          List<String> temp =
                              widget.rule.description.split("||");
                          widget.rule.description =
                              "${temp[1]}||${realActionsToString()}";
                          widget.refreshRoot();
                          Navigator.pop(context);
                        },
                        child: actions.isNotEmpty
                            ? Text(
                                txt["confirm"],
                                style: const TextStyle(color: Colors.black),
                              )
                            : Text(
                                txt["back"],
                                style: const TextStyle(color: Colors.black),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((val) {
      widget.refreshRoot();
    });
  }

  @override
  void initState() {
    List<String> temp = widget.rule.description.split("||");
    if (temp.length == 2 && temp[1].trim().isNotEmpty) {
      empty = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (empty) {
      return ElevatedButton(onPressed: showEdit, child: Text(txt["add"]));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              readDescriptionForFocus(widget.rule.description.split("||")[1]),
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(onPressed: showEdit, icon: const Icon(Icons.edit))
          ],
        ),
      ),
    );
  }
}

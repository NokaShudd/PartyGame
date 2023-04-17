import 'dart:async';
import 'package:flutter/material.dart';

import '../constants/route_classes.dart';
import '../constants/values.dart';
import '../constants/classes.dart';

class SelectGame extends StatefulWidget {
  const SelectGame({Key? key}) : super(key: key);

  @override
  State<SelectGame> createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  double right = 1000.0;

  Map<String, dynamic> txt = lang[langSelected]!["selectGameScreen"]!;

  List<bool> difficulty = [true, true, true, true];

  TagMode tagmode = TagMode.all;

  List<Tag> tags = [];

  void actualizeDiffs(int index, bool val) {
    difficulty[index] = val;
  }

  @override
  void initState() {
    Timer(const Duration(milliseconds: 400), () {
      right = 0;
      setState(() {});
    });

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
        child: Stack(
          children: [
            Positioned(
              top: 150,
              right: -150,
              child: Hero(
                tag: "2b",
                child: Image.asset("assets/images/2beer.png"),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              left: (right == 0) ? 0 : -1000.0,
              top: 0,
              bottom: 0,
              right: right,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(
                          txt["quickGame"] ?? "0",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                        child: Text(
                          txt["quickInfo"] ?? "0",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  right = 1000;
                                });
                                Timer(
                                  const Duration(milliseconds: 100),
                                  () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteName.selectPlayer,
                                      arguments: SelectPlayerParam(
                                        difficulty: [true, true, true, true],
                                        tagmode: TagMode.all,
                                      ),
                                    ).then(
                                      (value) => setState(
                                        () {
                                          right = 0;
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                shadowColor:
                                    const Color.fromRGBO(255, 204, 77, 0.75),
                                elevation: 5.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  txt["play"] ?? "0",
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor:
                                    const Color.fromRGBO(255, 204, 77, 0.85),
                                shadowColor:
                                    const Color.fromRGBO(255, 204, 77, 0.75),
                                elevation: 5.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  txt["option"] ?? "0",
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 25, 0, 15),
                        child: Text(
                          txt["other"] ?? "0",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: Text(
                          txt["withDiff"] ?? "0",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              DifficultyButton(
                                index: 0,
                                actualize: actualizeDiffs,
                              ),
                              DifficultyButton(
                                index: 1,
                                actualize: actualizeDiffs,
                              ),
                              DifficultyButton(
                                index: 2,
                                actualize: actualizeDiffs,
                              ),
                              DifficultyButton(
                                index: 3,
                                actualize: actualizeDiffs,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          txt["withTags"] ?? "0",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                tagmode = TagMode.all;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/tag.png",
                                      scale: 30,
                                    ),
                                    Text(
                                      txt["all"] ?? "0",
                                      style: TextStyle(
                                        color: (tagmode == TagMode.all)
                                            ? const Color(0xFFFFCC4D)
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                tagmode = TagMode.favorite;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/tagf.png",
                                      scale: 30,
                                    ),
                                    Text(
                                      txt["favorite"] ?? "0",
                                      style: TextStyle(
                                        color: (tagmode == TagMode.favorite)
                                            ? const Color(0xFFFFCC4D)
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                tagmode = TagMode.manual;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/tags.png",
                                      scale: 30,
                                    ),
                                    Text(
                                      txt["choose"] ?? "0",
                                      style: TextStyle(
                                        color: (tagmode == TagMode.manual)
                                            ? const Color(0xFFFFCC4D)
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  right = 1000;
                                });
                                Timer(
                                  const Duration(milliseconds: 100),
                                  () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteName.selectPlayer,
                                      arguments: SelectPlayerParam(
                                        difficulty: difficulty,
                                        tagmode: tagmode,
                                        tags: tags,
                                      ),
                                    ).then(
                                      (value) => setState(
                                        () {
                                          right = 0;
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                shadowColor:
                                    const Color.fromRGBO(255, 204, 77, 0.75),
                                elevation: 5.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  txt["play"] ?? "0",
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: const Color(0xFFFF4D71),
                                shadowColor: const Color(0xD7FF4D71),
                                elevation: 5.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  txt["back"] ?? "0",
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatefulWidget {
  const DifficultyButton({
    Key? key,
    required this.index,
    required this.actualize,
  }) : super(key: key);

  final int index;
  final Function(int, bool) actualize;

  @override
  State<DifficultyButton> createState() => _DifficultyButtonState();
}

class _DifficultyButtonState extends State<DifficultyButton> {
  Map<String, dynamic> txt = lang[langSelected]!["selectGameScreen"]!;
  bool value = true;

  List<String> imagesPath = [
    "assets/images/beer.png",
    "assets/images/beer2.png",
    "assets/images/beer3.png",
    "assets/images/beer3p.png",
  ];

  List<String> textList = [
    "0",
    '1',
    "2",
    '3',
  ];

  @override
  void initState() {
    textList = [
      txt["easy"] ?? "0",
      txt["normal"] ?? "1",
      txt["hard"] ?? "2",
      txt["reallyHard"] ?? "3",
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        value = !value;
        setState(() {});
        widget.actualize(widget.index, value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Image.asset(
              imagesPath[widget.index],
              scale: 3,
            ),
            Text(
              textList[widget.index],
              style: TextStyle(
                color: value ? const Color(0xFFFFCC4D) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

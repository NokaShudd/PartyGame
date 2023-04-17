import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/classes.dart';
import '../constants/route_classes.dart';
import '../constants/values.dart';
import '../logic/game_logic.dart';

class Game extends StatefulWidget {
  const Game({
    Key? key,
    required this.difficulty,
    required this.tagmode,
    required this.players,
    this.tags = const [],
  }) : super(key: key);

  final List<bool> difficulty;
  final TagMode tagmode;
  final List<Tag> tags;
  final List<Player> players;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  Map<String, dynamic> txt = lang[langSelected]!["playScreen"];
  bool started = false;
  bool canPlay = true;
  bool alternate = true;
  List<Rule> ruleInGame = [];
  double heroLeft = 0.0;
  double heroTop = 0.0;
  Color color = Colors.lime;
  Player? currentPlayer;
  int lastPos = -1;
  Rule? selectedRule;
  bool canRepeat = false;
  Map<int, List<Rule>> rulesForPlayers = {};
  Map<int, Rule?> lastRuleOfPlayer = {};
  bool first = true;
  late CarouselController carouselController;
  late AnimationController controller;
  bool moving = false;
  bool playerInfo = false;

  void setRule() {
    if (widget.tagmode == TagMode.all &&
        widget.difficulty.every(
          (element) => element,
        )) {
      ruleInGame = allRule;
    }

    if (ruleInGame.isEmpty) {
      setState(() {
        canPlay = false;
      });
    }
  }

  void setNewPlayer() {
    if (alternate) {
      currentPlayer = widget.players[(lastPos + 1) % widget.players.length];
      lastPos++;
      carouselController.animateToPage(lastPos % widget.players.length);
      return;
    }
    List<Player> temp =
        widget.players.where((element) => element != currentPlayer).toList();
    int random = Random().nextInt(temp.length);
    currentPlayer = temp[random];
    carouselController.animateToPage(random);
  }

  String getResumer() {
    String temp = "${txt['desc_0']} "
        "${widget.players.length} ${txt['desc_1']}"
        " ${getMinDifficulty()} ${txt['desc_2']} "
        "${getMaxDifficulty()}"
        "${txt['desc_3']}${ruleInGame.length} "
        "${txt['desc_4']} ";

    if (widget.tagmode == TagMode.all) {
      return temp + txt["desc_5_0"];
    }
    return '$temp${widget.tags.length} ${txt['desc-5_1']}';
  }

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
    controller = AnimationController(vsync: this, duration: 1700.ms);
    setRule();
    getRulesForPlayers();
    setRandomColor();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getRulesForPlayers() {
    for (Player player in widget.players) {
      List<Rule> rules = [];
      for (Rule rule in ruleInGame) {
        if (rule.tags.isEmpty) {
          rules.add(rule);
        }
        for (int tagId in rule.tags) {
          if (!player.tagsToAvoid.any((element) => element == tagId)) {
            rules.add(rule);
          }
        }
      }
      rulesForPlayers[player.id] = rules;
    }
  }

  void setRandomColor() {
    List<Color> temp =
        Colors.primaries.where((element) => element != color).toList();

    color = temp[Random().nextInt(temp.length)];
  }

  void getRandomRule() {
    List<Rule> ruleForNow = rulesForPlayers[currentPlayer!.id] ?? ruleInGame;

    if (!canRepeat && ruleForNow.length > 1) {
      List<Rule> temp = ruleForNow
          .where(
            (element) => (element != lastRuleOfPlayer[currentPlayer!.id]),
          )
          .toList();
      selectedRule = temp[Random().nextInt(temp.length)];
    } else {
      if (!canRepeat && ruleInGame.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(txt["1rule"]),
          ),
        );
      }

      selectedRule = ruleForNow[Random().nextInt(ruleForNow.length)];
    }
    lastRuleOfPlayer[currentPlayer!.id] = selectedRule;
  }

  int getMaxDifficulty() {
    int max = widget.difficulty.length;
    for (var element in widget.difficulty.reversed) {
      if (element) {
        break;
      }
      max--;
    }
    return max;
  }

  int getMinDifficulty() {
    int min = 1;
    for (var element in widget.difficulty.reversed) {
      if (element) {
        break;
      }
      min++;
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: started
            ? const BoxDecoration()
            : BoxDecoration(
                color: color,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(93, 202, 124, 1),
                    Color.fromRGBO(58, 84, 180, 1),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
        child: InkWell(
          onTap: () {
            setRandomColor();
            setNewPlayer();
            controller.forward().then((_) => controller.reset());
            getRandomRule();
            Timer(100.ms, () {
              setState(() {
                playerInfo = false;
                moving = true;
              });
              Timer(1300.ms, () {
                setState(() {
                  moving = false;
                });
              });
            });
            setState(() {});
          },
          child: Stack(
            children: [
              AnimatedPositioned(
                top: MediaQuery.of(context).size.height / 4,
                left: 45,
                duration: const Duration(milliseconds: 800),
                curve: Curves.decelerate,
                child: Visibility(
                  visible: !started,
                  child: Hero(
                    tag: "2b",
                    child: Image.asset(
                      "assets/images/2beer.png",
                      scale: 2,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !started,
                child: Positioned(
                  top: MediaQuery.of(context).size.height / 3,
                  left: 45,
                  right: 45,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Color(0xFFFEFEE2),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          offset: Offset(2, 2),
                          color: Color.fromARGB(96, 0, 0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getResumer(),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                bottom: started ? 25 : MediaQuery.of(context).size.height / 3.5,
                right: 25,
                child: started
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Color.fromARGB(255, 221, 221, 138),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              offset: Offset(2, 2),
                              color: Color.fromARGB(96, 0, 0, 0),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (!canPlay) return;
                            setRandomColor();
                            setNewPlayer();
                            getRandomRule();
                            setState(() {
                              started = true;
                            });
                            controller
                                .forward()
                                .then((_) => controller.reset());
                            getRandomRule();

                            Timer(100.ms, () {
                              setState(() {
                                moving = true;
                              });
                              Timer(1300.ms, () {
                                setState(() {
                                  moving = false;
                                });
                              });
                            });
                          },
                          child: Text(
                            txt["start"],
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                        .animate(
                          delay: const Duration(seconds: 1),
                          onPlay: (controller) => controller.repeat(
                            reverse: true,
                          ),
                        )
                        .shake(
                          hz: 5,
                          rotation: 0.03,
                          duration: const Duration(milliseconds: 400),
                          delay: const Duration(milliseconds: 800),
                        ),
              ),
              Visibility(
                visible: started,
                child: Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: CarouselSlider(
                      carouselController: carouselController,
                      items: widget.players
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                setState(() {
                                  playerInfo = !playerInfo;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Color(0xFFFEFEE2),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      color: Color.fromARGB(96, 0, 0, 0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      playerInfo
                                          ? "${e.genre.name} - ${e.orientation.name}"
                                          : e.name,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 75,
                        enlargeCenterPage: true,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                      ),
                    )),
              ),
              Visibility(
                visible: started,
                child: AnimatedPositioned(
                  duration: 250.ms,
                  left: 45,
                  right: 45,
                  height: MediaQuery.of(context).size.height / 3,
                  bottom:
                      moving ? -100 : -MediaQuery.of(context).size.height / 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Color.fromARGB(255, 158, 55, 48),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: started,
                child: Positioned(
                  top: MediaQuery.of(context).size.height / 3,
                  bottom: MediaQuery.of(context).size.height / 3,
                  left: 45,
                  right: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                      color: moving
                          ? const Color.fromARGB(255, 194, 67, 58)
                          : const Color(0xFFFEFEE2),
                      boxShadow: moving
                          ? null
                          : [
                              const BoxShadow(
                                offset: Offset(-2, 2),
                                color: Color.fromARGB(96, 0, 0, 0),
                              ),
                            ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: moving
                          ? Center(
                              child: Image.asset(
                                "assets/images/2beer.png",
                                scale: 2,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  (selectedRule != null)
                                      ? selectedRule!.name
                                      : "",
                                  style: const TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  readDescription(
                                    (selectedRule != null)
                                        ? selectedRule!.description
                                        : "",
                                    players: widget.players,
                                    player: currentPlayer,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                    ),
                  )
                      .animate(controller: controller)
                      .flipH(
                          end: -1, curve: Curves.decelerate, duration: 400.ms)
                      .moveY(
                        delay: 400.ms,
                        end: (MediaQuery.of(context).size.height / 3) + 120,
                        duration: 200.ms,
                      )
                      .then(delay: 500.ms)
                      .moveY(
                        end: -(MediaQuery.of(context).size.height / 3) - 120,
                      )
                      .then()
                      .flipH(end: 1, duration: 400.ms),
                ),
              ),
              Visibility(
                visible: started,
                child: AnimatedPositioned(
                  duration: 250.ms,
                  left: 45,
                  right: 45,
                  height: MediaQuery.of(context).size.height / 3,
                  bottom:
                      moving ? -140 : -MediaQuery.of(context).size.height / 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Color.fromARGB(255, 218, 85, 75),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/2beer.png",
                        scale: 2,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

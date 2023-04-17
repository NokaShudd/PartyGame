import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/classes.dart';
import '../constants/route_classes.dart';
import '../constants/values.dart';

class SelectPlayer extends StatefulWidget {
  const SelectPlayer({
    Key? key,
    required this.difficulty,
    required this.tagmode,
    this.tags = const [],
  }) : super(key: key);

  final List<bool> difficulty;
  final TagMode tagmode;
  final List<Tag> tags;

  @override
  State<SelectPlayer> createState() => _SelectPlayerState();
}

class _SelectPlayerState extends State<SelectPlayer> {
  Map<String, dynamic> txt = lang[langSelected]!["selectPlayerScreen"]!;
  bool isDragging = false;

  void reload() {
    setState(() {});
  }

  bool isInPlayerInGame(int id) {
    for (Player element in playerInGame) {
      if (element.id == id) return true;
    }
    return false;
  }

  void showAddPanel() {
    int index = 0;
    int? sex = 2;
    int? orr = 2;

    TextEditingController nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return BottomSheet(
            enableDrag: false,
            onClosing: () {},
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.65,
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
                        PageView(
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (int indexPage) {
                            setState(() {
                              index = indexPage;
                            });
                          },
                          children: [
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15.0, 0, 10),
                                  child: Icon(
                                    Icons.access_time,
                                    size: 45,
                                  ),
                                ),
                                ListTile(
                                  title: Text(txt["name"]),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: 25.0,
                                    ),
                                    child: TextField(
                                      style: const TextStyle(fontSize: 15),
                                      controller: nameController,
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
                                        backgroundColor:
                                            Colors.black.withOpacity(0.2),
                                        groupValue: sex,
                                        thumbColor: const Color(0xFFFFCC4D),
                                        children: const {
                                          0: Icon(Icons.male),
                                          1: Icon(Icons.female),
                                          2: Icon(Icons.question_mark)
                                        },
                                        onValueChanged: (int? newVal) {
                                          setState(() {
                                            sex = newVal;
                                            if (sex == 2) {
                                              orr = 2;
                                            }
                                          });
                                        }),
                                  ),
                                ),
                                ListTile(
                                  title: Text(txt["orientation"]),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: 25.0,
                                    ),
                                    child: CupertinoSlidingSegmentedControl(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.2),
                                      groupValue: orr,
                                      thumbColor: const Color(0xFFFFCC4D),
                                      children: const {
                                        0: Text(
                                          "Hétéro",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        1: Text(
                                          "Gay",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        2: Text(
                                          "Bi",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      },
                                      onValueChanged: (int? newVal) {
                                        setState(() {
                                          orr = newVal;
                                          if (orr != 2 && sex == 2) {
                                            sex = 0;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                nameController.text.replaceAll(" ", "").isEmpty
                                    ? const Center()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          horizontal: 80.0,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            playerInGame.add(
                                              Player.temporary(
                                                nameController.text,
                                                genre: Genre.values[sex ?? 2],
                                                orientation: Orientations
                                                    .values[orr ?? 2],
                                              ),
                                            );
                                            Navigator.pop(context);
                                            reload();
                                          },
                                          child: Text(txt["confirm"]),
                                        ),
                                      )
                              ],
                            ),
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15.0, 0, 10),
                                  child: Icon(
                                    Icons.person,
                                    size: 45,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      runSpacing: 25.0,
                                      spacing: 50.0,
                                      children: allPlayer
                                          .where((element) =>
                                              !isInPlayerInGame(element.id))
                                          .map(
                                            (e) => InkWell(
                                              onTap: () {
                                                setState(() {
                                                  playerInGame.add(e);
                                                });
                                                reload();
                                              },
                                              child: CircleAvatar(
                                                radius: 45.0,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.3),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    e.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: index == 0
                                        ? const Color.fromRGBO(
                                            93,
                                            202,
                                            124,
                                            1,
                                          )
                                        : Colors.white30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: index == 1
                                        ? const Color.fromRGBO(
                                            93,
                                            202,
                                            124,
                                            1,
                                          )
                                        : Colors.white30,
                                  ),
                                ),
                              ]),
                        )
                      ],
                    ),
                  );
                },
              );
            });
      },
    );
  }

  List<Widget> addWidget() {
    if ((playerInGame.length) % 3 != 0) {
      if ((playerInGame.length + 1) % 3 == 0) {
        return [
          SizedBox(
            height: MediaQuery.of(context).size.width / 3 - 10,
            width: MediaQuery.of(context).size.width / 3 - 10,
          ),
        ];
      }
      return [
        SizedBox(
          height: MediaQuery.of(context).size.width / 3 - 10,
          width: MediaQuery.of(context).size.width / 3 - 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width / 3 - 10,
          width: MediaQuery.of(context).size.width / 3 - 10,
        ),
      ];
    }
    return [];
  }

  List<Player> playerInGame = [];

  void setDragging(bool val) {
    setState(() {
      isDragging = val;
    });
  }

  @override
  void initState() {
    playerInGame.add(allPlayer.where((element) => element.id == 0).first);
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
              left: -100,
              bottom: -25,
              child: Hero(
                tag: "2b",
                child: Image.asset("assets/images/2beer.png"),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Text(
                          txt["players"],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            runSpacing: 10,
                            runAlignment: WrapAlignment.spaceEvenly,
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                                  // ignore: unnecessary_cast
                                  AddPlayerButton(
                                    showPanel: showAddPanel,
                                  ) as Widget,
                                  PlayButton(
                                    start: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteName.playGame,
                                        arguments: GameParam(
                                          difficulty: widget.difficulty,
                                          tagmode: widget.tagmode,
                                          tags: widget.tags,
                                          players: playerInGame,
                                        ),
                                      );
                                    },
                                  )
                                ] +
                                playerInGame
                                    .map(
                                      (e) => PlayerIconWidget(
                                        e: e,
                                        setDragging: setDragging,
                                      ),
                                    )
                                    .toList() +
                                addWidget(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: isDragging ? 25 : -200,
              left: MediaQuery.of(context).size.width / 2 - 25,
              duration: const Duration(milliseconds: 250),
              child: DragTarget(
                builder: (context, candidateData, rejectedData) =>
                    const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.delete,
                    size: 30,
                  ),
                ),
                onAccept: (player) {
                  playerInGame.remove(player);
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  PlayButton({
    Key? key,
    required this.start,
  }) : super(key: key);

  final Map<String, dynamic> txt = lang[langSelected]!["selectPlayerScreen"]!;
  final Function() start;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: start,
      child: Container(
        width: (MediaQuery.of(context).size.width / 3) * 2 - 10,
        height: MediaQuery.of(context).size.width / 3 - 10,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x5FFFCC4D),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          border: Border.all(color: const Color(0xFFFFCD4D), width: 3.0),
          color: const Color(0xADFFCC4D),
        ),
        child: Center(
            child: Text(
          txt["play"],
          style: const TextStyle(fontSize: 45),
        )),
      ),
    );
  }
}

class AddPlayerButton extends StatelessWidget {
  const AddPlayerButton({
    Key? key,
    required this.showPanel,
  }) : super(key: key);

  final Function() showPanel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showPanel,
      child: Container(
        height: MediaQuery.of(context).size.width / 3 - 10,
        width: MediaQuery.of(context).size.width / 3 - 10,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x5FFFCC4D),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          border: Border.all(color: const Color(0xFFFFCD4D), width: 3.0),
          color: const Color(0xADFFCC4D),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 60,
            shadows: [
              Shadow(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerIconWidget extends StatefulWidget {
  const PlayerIconWidget({
    Key? key,
    required this.e,
    required this.setDragging,
  }) : super(key: key);

  final Player e;
  final Function(bool) setDragging;

  @override
  State<PlayerIconWidget> createState() => _PlayerIconWidgetState();
}

class _PlayerIconWidgetState extends State<PlayerIconWidget> {
  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Player>(
      delay: const Duration(milliseconds: 20),
      onDragStarted: () {
        widget.setDragging(true);
      },
      onDragEnd: (_) {
        widget.setDragging(false);
      },
      data: widget.e,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.width / 3,
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x5FFFCC4D),
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFFFCD4D),
            ),
            color: const Color(0xADFFCC4D),
          ),
          child: Center(child: FittedBox(child: Text(widget.e.name))),
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.width / 3 - 10,
        width: MediaQuery.of(context).size.width / 3 - 10,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x5FFFCC4D),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
          border: Border.all(
            color: const Color(0xFFFFCD4D),
          ),
          color: const Color(0xADFFCC4D),
        ),
        child: Center(
            child: Text(
          widget.e.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ),
    );
  }
}

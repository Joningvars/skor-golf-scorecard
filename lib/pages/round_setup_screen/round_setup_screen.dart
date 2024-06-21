import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/data/korpan.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/add_player_screen/add_player_screen.dart';
import 'package:score_card/pages/hole_screen/hole_screen.dart';
import 'package:score_card/pages/round_setup_screen/add_player_button.dart';
import 'package:score_card/pages/round_setup_screen/custom_tee_button.dart';
import 'package:score_card/pages/round_setup_screen/player_button.dart';
import 'package:score_card/providers/round_provider.dart';
import 'package:score_card/widgets/custom_appbar.dart';
import 'package:score_card/providers/player_list_provider.dart';

class RoundSetupScreen extends ConsumerStatefulWidget {
  const RoundSetupScreen({super.key, required this.course});
  final GolfCourse course;

  @override
  RoundSetupScreenState createState() => RoundSetupScreenState();
}

class RoundSetupScreenState extends ConsumerState<RoundSetupScreen> {
  int selectedTee = 0;
  int selectedFront9Index = 1;
  int selectedBack9Index = 1;
  bool isSpecificCourse = false;

  //names of the different set of 9 holes for Korpan
  final List<String> courseNames = ['Sjórinn', 'Áin', 'Landið'];
  List<Hole> _currentHoles = [];

  FixedExtentScrollController front9Controller =
      FixedExtentScrollController(initialItem: 1);
  FixedExtentScrollController back9Controller =
      FixedExtentScrollController(initialItem: 1);

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    isSpecificCourse = widget.course.name == 'Korpúlfsstaðir';
    _updateHoles();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      front9Controller.jumpToItem(selectedFront9Index);
      back9Controller.jumpToItem(selectedBack9Index);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _navigateToHoleDetailPage(List<Player> players) {
    if (players.isNotEmpty) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HoleDetailPage(
            course: widget.course,
            holes: _currentHoles,
            players: players,
            selectedTee: selectedTee,
          ),
        ),
      ).then((_) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });
    }
  }

  //updates korpan depending on chosen front 9 and back 9 (as it has 27 holes)
  void _updateHoles() {
    if (isSpecificCourse) {
      List<Hole> front9;
      List<Hole> back9;

      switch (courseNames[selectedFront9Index]) {
        case 'Sjórinn':
          front9 = getSjorninHoles();
          break;
        case 'Áin':
          front9 = getAinHoles();
          break;
        case 'Landið':
          front9 = getLandidHoles();
          break;
        default:
          front9 = getSjorninHoles();
      }

      switch (courseNames[selectedBack9Index]) {
        case 'Sjórinn':
          back9 = getSjorninHoles();
          break;
        case 'Áin':
          back9 = getAinHoles();
          break;
        case 'Landið':
          back9 = getLandidHoles();
          break;
        default:
          back9 = getAinHoles();
      }

      setState(() {
        _currentHoles = front9 + back9;
      });
    } else {
      setState(() {
        _currentHoles = widget.course.holes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final players = ref.watch(playerListProvider);
    final playerListNotifier = ref.read(playerListProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Velja teig'),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              theme.colorScheme.secondary,
              theme.primaryColor,
              theme.primaryColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isSpecificCourse) const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Velja teig',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    CustomTeeButton(
                      text: widget.course.par == 0
                          ? 'Hvítur'
                          : widget.course.whiteTee.toString(),
                      color: Colors.white,
                      onPressed: () {
                        _startRound(players, 2);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTeeButton(
                      text: widget.course.par == 0
                          ? 'Gulur'
                          : widget.course.yellowTee.toString(),
                      color: Colors.yellow,
                      onPressed: () {
                        _startRound(players, 0);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTeeButton(
                      text: widget.course.par == 0
                          ? 'Blár'
                          : widget.course.blueTee.toString(),
                      color: Colors.blue,
                      onPressed: () {
                        _startRound(players, 3);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTeeButton(
                      text: widget.course.par == 0
                          ? 'Rauður'
                          : widget.course.redTee.toString(),
                      color: Colors.red,
                      onPressed: () {
                        _startRound(players, 1);
                      },
                    ),
                  ],
                ),
              ),

              //korpan front 9 and back 9 picker(as it has 27 holes)
              if (isSpecificCourse) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height: 150,
                              width: 120,
                              child: ListWheelScrollView.useDelegate(
                                controller: front9Controller,
                                diameterRatio: 1.2,
                                perspective: 0.005,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    selectedFront9Index = index;
                                    _updateHoles();
                                  });
                                },
                                itemExtent: 30,
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Text(
                                      courseNames[index].toUpperCase(),
                                      style: TextStyle(
                                        color: selectedFront9Index == index
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                        fontSize: 25,
                                      ),
                                    );
                                  },
                                  childCount: courseNames.length,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: theme.colorScheme.secondary,
                      )),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height: 150,
                              width: 120,
                              child: ListWheelScrollView.useDelegate(
                                controller: back9Controller,
                                diameterRatio: 1.2,
                                perspective: 0.005,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    selectedBack9Index = index;
                                    _updateHoles();
                                  });
                                },
                                itemExtent: 30,
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Text(
                                      courseNames[index].toUpperCase(),
                                      style: TextStyle(
                                        color: selectedBack9Index == index
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 25,
                                      ),
                                    );
                                  },
                                  childCount: courseNames.length,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 70)
              ],
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Golfarar',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Color.fromARGB(82, 15, 39, 58),
                  thickness: 4,
                ),
              ),
              _buildPlayerButtons(players, playerListNotifier),
            ],
          ),
        ),
      ),
    );
  }

  //starts the "round" for saving unfinished round and then loading it back up
  void _startRound(List<Player> players, int tee) {
    if (players.isNotEmpty) {
      ref.read(roundProvider.notifier).startRound(
            widget.course,
            players,
            _currentHoles,
            tee,
          );
      setState(() {
        selectedTee = tee;
      });
      HapticFeedback.lightImpact();
      _navigateToHoleDetailPage(players);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Vinsamlegast bættu við golfara svo hægt sé að byrja hring.'),
        ),
      );
    }
  }

  Widget _buildPlayerButtons(List<Player> players, var playerListNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (index) {
          if (index < players.length) {
            return PlayerButton(
              player: players[index],
              onDelete: () {
                HapticFeedback.lightImpact();
                playerListNotifier.removePlayer(players[index]);
              },
              onEdit: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPlayerScreen(
                      course: widget.course,
                      onAddPlayer: (firstName, lastName, tee) {
                        setState(() {
                          players[index] = Player(
                            firstName: firstName,
                            lastName: lastName,
                            strokes: players[index].strokes,
                            selectedTee: players[index].selectedTee,
                          );
                          playerListNotifier.updatePlayer(
                              index, players[index]);
                        });
                      },
                      initialPlayer: players[index],
                      onDeletePlayer: () =>
                          playerListNotifier.removePlayer(players[index]),
                    ),
                  ),
                );
              },
            );
          } else {
            return AddPlayerButton(
              course: widget.course,
              onAddPlayer: (firstName, lastName, tee) {
                final newPlayer = Player(
                  firstName: firstName,
                  lastName: lastName,
                  strokes: List.generate(18, (index) => 0),
                  selectedTee: tee,
                );
                playerListNotifier.addPlayer(newPlayer);
              },
            );
          }
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/add_player_screen/add_player_screen.dart';
import 'package:score_card/pages/hole_screen/hole_screen.dart';
import 'package:score_card/pages/round_setup_screen/add_player_button.dart';
import 'package:score_card/pages/round_setup_screen/custom_tee_button.dart';
import 'package:score_card/pages/round_setup_screen/player_button.dart';
import 'package:score_card/widgets/custom_appbar.dart';
import 'package:score_card/providers/player_list_provider.dart'; // Make sure this import is correct

class RoundSetupScreen extends ConsumerStatefulWidget {
  const RoundSetupScreen({super.key, required this.course});
  final GolfCourse course;

  @override
  _RoundSetupScreenState createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends ConsumerState<RoundSetupScreen> {
  int selectedTee = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            holes: widget.course.holes,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final players = ref.watch(playerListProvider);
    final playerListNotifier = ref.read(playerListProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Velja teig'),
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  CustomTeeButton(
                    text: widget.course.whiteTee.toString(),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        selectedTee = 2;
                      });
                      HapticFeedback.lightImpact();
                      _navigateToHoleDetailPage(players);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTeeButton(
                    text: widget.course.yellowTee.toString(),
                    color: Colors.yellow,
                    onPressed: () {
                      setState(() {
                        selectedTee = 0;
                      });
                      HapticFeedback.lightImpact();
                      _navigateToHoleDetailPage(players);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTeeButton(
                    text: widget.course.blueTee.toString(),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        selectedTee = 3;
                      });
                      HapticFeedback.lightImpact();
                      _navigateToHoleDetailPage(players);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTeeButton(
                    text: widget.course.redTee.toString(),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        selectedTee = 1;
                      });
                      HapticFeedback.lightImpact();
                      _navigateToHoleDetailPage(players);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
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
            Expanded(
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
                              onDeletePlayer: () => playerListNotifier
                                  .removePlayer(players[index]),
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
            ),
          ],
        ),
      ),
    );
  }
}

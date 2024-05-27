import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/add_player_screen/add_player_screen.dart';
import 'package:score_card/pages/hole_screen/hole_screen.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/widgets/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoundSetupScreen extends StatefulWidget {
  const RoundSetupScreen({super.key, required this.course});
  final GolfCourse course;

  @override
  State<RoundSetupScreen> createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends State<RoundSetupScreen> {
  List<Player> players = [];
  int selectedTee = 0;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? playerJsonList = prefs.getStringList('players');
    if (playerJsonList != null) {
      setState(() {
        players = playerJsonList
            .map((jsonString) => Player.fromJson(json.decode(jsonString)))
            .toList();
      });
    }
  }

  Future<void> _savePlayers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> playerJsonList =
        players.map((player) => json.encode(player.toJson())).toList();
    await prefs.setStringList('players', playerJsonList);
  }

  void _addPlayer(String firstName, String lastName, int tee) {
    Player newPlayer = Player(
      firstName: firstName,
      lastName: lastName,
      strokes: [],
      selectedTee: tee,
    );
    setState(() {
      players.add(newPlayer);
    });
    _savePlayers();
  }

  void _deletePlayer(Player player) {
    setState(() {
      players.remove(player);
    });
    _savePlayers();
  }

  void _navigateToHoleDetailPage() {
    if (players.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HoleDetailPage(
            course: widget.course,
            holes: widget.course.holes,
            players: players,
            selectedTee: selectedTee, // Pass the selected tee
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ]),
        ),
        child: Stack(
          children: [
            // const BackgroundBlob(),
            Positioned.fill(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 75),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTeeButton(
                        text: widget.course.whiteTee.toString(),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            selectedTee = 2;
                          });
                          HapticFeedback.lightImpact();
                          _navigateToHoleDetailPage();
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
                          _navigateToHoleDetailPage();
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
                          _navigateToHoleDetailPage();
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
                          _navigateToHoleDetailPage();
                        },
                      ),
                      const SizedBox(height: 120),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Golfarar',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(82, 15, 39, 58),
                        thickness: 4,
                      ),
                      // render buttons for every player
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 4; i++)
                            if (i < players.length)
                              PlayerButton(
                                player: players[i],
                                onDelete: () {
                                  HapticFeedback.lightImpact();
                                  _deletePlayer(players[i]);
                                },
                                onEdit: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddPlayerScreen(
                                        course: widget.course,
                                        onAddPlayer:
                                            (firstName, lastName, tee) {
                                          setState(() {
                                            players[i] = Player(
                                              firstName: firstName,
                                              lastName: lastName,
                                              strokes: players[i].strokes,
                                              selectedTee:
                                                  players[i].selectedTee,
                                            );
                                            _savePlayers();
                                          });
                                        },
                                        initialPlayer: players[i],
                                        onDeletePlayer: () =>
                                            _deletePlayer(players[i]),
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              AddPlayerButton(
                                course: widget.course,
                                onAddPlayer: _addPlayer,
                              ),
                        ],
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

class CustomTeeButton extends StatelessWidget {
  const CustomTeeButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: theme.colorScheme.secondary,
          shadowColor: Colors.black),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_golf_rounded,
              size: 60,
              color: color,
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerButton extends StatelessWidget {
  final Player player;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PlayerButton({
    super.key,
    required this.player,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          SizedBox(
            width: 65,
            height: 65,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.black),
              onPressed: onEdit,
              child: Text(
                player.initials,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPlayerButton extends StatelessWidget {
  final GolfCourse course;
  final Function(String, String, int) onAddPlayer;

  const AddPlayerButton({
    super.key,
    required this.course,
    required this.onAddPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.black),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPlayerScreen(
                  course: course,
                  onAddPlayer: onAddPlayer,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/add_player_screen.dart';
import 'package:score_card/pages/hole_screen.dart';
import 'package:score_card/widgets/background_blob.dart';
import 'package:score_card/widgets/customAppBar.dart';

class RoundSetupScreen extends StatefulWidget {
  RoundSetupScreen({super.key, required this.course});
  final GolfCourse course;

  @override
  State<RoundSetupScreen> createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends State<RoundSetupScreen> {
  List<Player> players = [];

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
  }

  void _navigateToHoleDetailPage(int selectedTee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HoleDetailPage(
          players: [...players],
          hole: widget.course.holes[0],
          selectedTee: selectedTee,
        ),
      ),
    );
  }

  void _navigateToAddPlayerScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlayerScreen(
          course: widget.course,
          onAddPlayer: _addPlayer,
        ),
      ),
    );

    if (result != null) {
      String firstName = result['firstName'];
      String lastName = result['lastName'];
      int tee = result['tee'];

      _addPlayer(firstName, lastName, tee);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Select Tee'),
      body: Stack(
        children: [
          const BackgroundBlob(),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTeeButton(
                      text: '${widget.course.whiteTee.toString()} m',
                      color: Colors.white,
                      onPressed: () {
                        _navigateToHoleDetailPage(widget.course.whiteTee);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTeeButton(
                      text: '${widget.course.yellowTee.toString()} m',
                      color: Colors.yellow,
                      onPressed: () {
                        _navigateToHoleDetailPage(widget.course.yellowTee);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTeeButton(
                      text: '${widget.course.blueTee.toString()} m',
                      color: Colors.blue,
                      onPressed: () {
                        _navigateToHoleDetailPage(widget.course.blueTee);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTeeButton(
                      text: '${widget.course.redTee.toString()} m',
                      color: Colors.red,
                      onPressed: () {
                        _navigateToHoleDetailPage(widget.course.redTee);
                      },
                    ),
                    const SizedBox(height: 100),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Golfarar',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // render buttons for each player
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 4; i++)
                          if (i < players.length)
                            PlayerButton(player: players[i])
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
    );
  }
}

class CustomTeeButton extends StatelessWidget {
  const CustomTeeButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.color,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: 300,
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_golf_rounded,
                size: 60,
                color: color,
              ),
              const SizedBox(width: 20),
              Text(
                '$text',
                style: TextStyle(
                  color: color,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerButton extends StatelessWidget {
  final Player player;

  const PlayerButton({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        width: 60,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // Handle button tap
          },
          child: Text(
            '${player.initials}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class AddPlayerButton extends StatelessWidget {
  final GolfCourse course;
  final Function(String, String, int) onAddPlayer;

  const AddPlayerButton({
    Key? key,
    required this.course,
    required this.onAddPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        width: 60,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          onPressed: () {
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
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

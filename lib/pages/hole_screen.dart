import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/round_setup_screen.dart';
import 'package:score_card/widgets/background_blob.dart';
import 'package:score_card/widgets/customAppBar.dart';

class HoleDetailPage extends StatelessWidget {
  final List<Hole> holes;
  final int selectedTee;
  final List<Player> players;
  int currentHoleIndex;

  HoleDetailPage({
    required this.holes,
    required this.selectedTee,
    required this.players,
    this.currentHoleIndex = 0,
  });

  void _navigateToNextHole(BuildContext context) {
    if (currentHoleIndex < holes.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HoleDetailPage(
            holes: holes,
            selectedTee: selectedTee,
            players: players,
            currentHoleIndex: currentHoleIndex + 1,
          ),
        ),
      );
    } else {
      print('End of round');
    }
  }

  void _navigateToPrevHole(BuildContext context) {
    if (currentHoleIndex > 0) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context); // Pops if no previous hole
    }
  }

  @override
  Widget build(BuildContext context) {
    Hole currentHole = holes[currentHoleIndex];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hola ${currentHole.number}',
        action: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () => _navigateToNextHole(context),
        ),
        leadAction: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => _navigateToPrevHole(context),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundBlob(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Par: ${currentHole.par}'),
                    Text('Lengd: ${currentHole.redTee} m'),
                    const SizedBox(height: 16),
                    if (players.isNotEmpty)
                      Column(
                        children: [
                          for (int i = 0; i < players.length; i++)
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    PlayerButton(player: players[i]),
                                    const SizedBox(width: 100),
                                    CustomCounter(
                                      player: players[i],
                                      holeIndex: currentHoleIndex,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () => _navigateToNextHole(context),
              child: Text('Next Hole'),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCounter extends StatefulWidget {
  final Player player;
  final int holeIndex;

  CustomCounter({super.key, required this.player, required this.holeIndex});

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late int strokeCount;

  @override
  void initState() {
    super.initState();
    strokeCount = widget.player.strokes.length > widget.holeIndex
        ? widget.player.strokes[widget.holeIndex]
        : 0;
  }

  void _updateStrokeCount(int change) {
    setState(() {
      strokeCount += change;
      if (strokeCount < 0) {
        strokeCount = 0;
      }

      // Update playerS strokes
      if (widget.player.strokes.length > widget.holeIndex) {
        widget.player.strokes[widget.holeIndex] = strokeCount;
      } else {
        widget.player.strokes.addAll(
            List.filled(widget.holeIndex - widget.player.strokes.length, 0));
        widget.player.strokes.add(strokeCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _updateStrokeCount(-1);
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Text(
                          'PAR',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          strokeCount.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _updateStrokeCount(1);
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/round_setup_screen.dart';
import 'package:score_card/widgets/customAppBar.dart';

class HoleDetailPage extends StatefulWidget {
  final Hole hole;
  final int selectedTee;
  final List<Player> players;

  const HoleDetailPage({
    super.key,
    required this.hole,
    required this.selectedTee,
    required this.players,
  });

  @override
  State<HoleDetailPage> createState() => _HoleDetailPageState();
}

class _HoleDetailPageState extends State<HoleDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Hola ${widget.hole.number}'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Par: ${widget.hole.par}'),
            Text('Lengd: ${widget.hole.redTee} m'),
            const SizedBox(height: 16),
            if (widget.players.isNotEmpty)
              Column(
                children: [
                  for (int i = 0; i < widget.players.length; i++)
                    Row(
                      children: [
                        PlayerButton(player: widget.players[i]),
                        SizedBox(width: 100),
                        ElevatedButton(onPressed: () {}, child: Text('-')),
                        ElevatedButton(onPressed: () {}, child: Text('0')),
                        ElevatedButton(onPressed: () {}, child: Text('+')),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

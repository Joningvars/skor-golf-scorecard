import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';

class ScorecardScreen extends StatefulWidget {
  final List<Player> players;
  final List<Hole> holes;

  ScorecardScreen({required this.players, required this.holes});

  @override
  _ScorecardScreenState createState() => _ScorecardScreenState();
}

class _ScorecardScreenState extends State<ScorecardScreen> {
  @override
  void initState() {
    super.initState();
    // lock landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
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

  @override
  Widget build(BuildContext context) {
    int totalLength9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);
    return Scaffold(
      appBar: AppBar(
        title: Text('Skorkort'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFront9holes(),
            _buildFront9Par(),
            _buildFront9Length(),
            _buildFront9Handicap(),
            for (var player in widget.players) _buildPlayerFront9(player),
          ],
        ),
      ),
    );
  }

  Widget _buildFront9holes() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Hola', flex: 2),
          for (var holeNumber = 1; holeNumber <= 9; holeNumber++)
            _buildCell('$holeNumber', flex: 1),
          _buildCell('ÚT', flex: 1),
        ],
      ),
    );
  }

  Widget _buildFront9Length() {
    int totalLength9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Gulur(M)', flex: 2),
          for (var i = 1; i < 9; i++)
            _buildCell('${widget.holes[i].yellowTee}', flex: 1),
          _buildCell('${totalLength9}', flex: 1),
        ],
      ),
    );
  }

  Widget _buildFront9Par() {
    int totalPar9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.par);
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Par', flex: 2),
          for (var i = 1; i < 9; i++)
            _buildCell('${widget.holes[i].par}', flex: 1),
          _buildCell(totalPar9.toString(), flex: 1),
        ],
      ),
    );
  }

  Widget _buildFront9Handicap() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Forgjöf', flex: 2),
          for (var i = 1; i < 9; i++)
            _buildCell('${widget.holes[i].handicap}', flex: 1),
          _buildCell('', flex: 1),
        ],
      ),
    );
  }

  Widget _buildPlayerFront9(Player player) {
    int totalScore9 =
        player.strokes.take(9).fold(0, (prev, score) => prev + score);

    return Column(
      children: [
        Row(
          children: [
            _buildCell(player.initials, flex: 2),
            for (var score in player.strokes.take(9))
              _buildCell(score.toString(), flex: 1),
            _buildCell(totalScore9.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerBack9(Player player) {
    int totalScore18 = player.strokes.fold(0, (prev, score) => prev + score);

    int totalPar18 = widget.holes.fold(0, (prev, hole) => prev + hole.par);

    int totalLength18 =
        widget.holes.fold(0, (prev, hole) => prev + hole.yellowTee);

    return Column(
      children: [
        Row(
          children: [
            _buildCell(player.initials, flex: 2),
            for (var score in player.strokes.take(-9))
              _buildCell(score.toString(), flex: 1),
            _buildCell(totalScore18.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }
}

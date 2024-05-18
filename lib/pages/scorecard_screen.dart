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
    return Scaffold(
      appBar: AppBar(
        title: Text('Skorkort'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHoleNumbers(),
            _buildHoleLength(),
            _buildHandicap(),
            for (var player in widget.players) _buildPlayerRow(player),
          ],
        ),
      ),
    );
  }

  Widget _buildHoleNumbers() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Hola', flex: 2),
          for (var holeNumber = 1; holeNumber <= 18; holeNumber++)
            _buildCell('$holeNumber', flex: 1),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout() {
    int totalPar9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.par);

    int totalLength9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildVerticalCell('', totalPar9.toString()),
        _buildVerticalCell('', totalLength9.toString()),
        for (var player in widget.players)
          _buildVerticalCell(
              '${player.initials}',
              player.strokes
                  .take(9)
                  .fold(0, (prev, score) => prev + score)
                  .toString()),
      ],
    );
  }

  Widget _buildVerticalCell(String title, String value) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildHoleLength() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Gulur(M)', flex: 2),
          for (var hole in widget.holes)
            _buildCell('${hole.yellowTee}', flex: 1),
        ],
      ),
    );
  }

  Widget _buildHandicap() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          _buildCell('Forgjöf', flex: 2),
          for (var hole in widget.holes)
            _buildCell('${hole.handicap}', flex: 1),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(Player player) {
    int totalScore9 =
        player.strokes.take(9).fold(0, (prev, score) => prev + score);

    int totalPar9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.par);

    int totalLength9 =
        widget.holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);

    int totalScore18 = player.strokes.fold(0, (prev, score) => prev + score);

    int totalPar18 = widget.holes.fold(0, (prev, hole) => prev + hole.par);

    int totalLength18 =
        widget.holes.fold(0, (prev, hole) => prev + hole.yellowTee);

    return Column(
      children: [
        Row(
          children: [
            _buildCell(player.initials, flex: 2),
            for (var score in player.strokes.take(9))
              _buildCell(score.toString(), flex: 1),
            _buildCell(
                ' Par: $totalPar9, Lengd: $totalLength9, Högg: $totalScore9',
                flex: 3),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildCell('', flex: 2),
            for (var score in player.strokes.skip(9))
              _buildCell(score.toString(), flex: 1),
            _buildCell('$totalPar18 $totalLength18 $totalScore18', flex: 3),
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

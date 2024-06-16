import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/providers/round_provider.dart';
import 'package:score_card/widgets/relative_score.dart';

class CustomCounter extends ConsumerStatefulWidget {
  final Player player;
  final int holeIndex;
  final List<Hole> holes;

  const CustomCounter({
    super.key,
    required this.player,
    required this.holeIndex,
    required this.holes,
  });

  @override
  ConsumerState<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends ConsumerState<CustomCounter> {
  late int strokeCount;
  bool showCounter = false;

  @override
  void initState() {
    super.initState();
    if (widget.player.strokes.length <= widget.holeIndex) {
      widget.player.strokes.addAll(
        List<int>.filled(
          widget.holeIndex - widget.player.strokes.length + 1,
          0,
        ),
      );
    }
    strokeCount = widget.player.strokes[widget.holeIndex];
    if (strokeCount > 0) {
      showCounter = true;
    }
  }

  void _updateStrokeCount(int change, Player player) {
    HapticFeedback.lightImpact();
    setState(() {
      strokeCount += change;
      if (strokeCount < 1) {
        strokeCount = 1;
      } else if (strokeCount > 10) {
        strokeCount = 10;
      }

      int score = strokeCount;
      int par = widget.holes[widget.holeIndex].par;
      int relativeScore = score - par;

      player.relativeScore -= player.strokes[widget.holeIndex] - par;
      player.strokes[widget.holeIndex] = strokeCount;
      player.relativeScore += relativeScore;

      ref
          .read(roundProvider.notifier)
          .updateScore(player, widget.holeIndex, strokeCount);
    });
  }

  String _displayScoreText() {
    int score = widget.player.strokes[widget.holeIndex];
    int par = widget.holes[widget.holeIndex].par;
    int relativeScore = score - par;
    String scoreText = '';

    if (widget.holeIndex >= 0 && widget.holeIndex < widget.holes.length) {
      switch (relativeScore) {
        case -3:
          scoreText = 'ALBATROSS';
          break;
        case -2:
          scoreText = 'ÖRN';
          break;
        case -1:
          scoreText = 'FUGL';
          break;
        case 0:
          scoreText = 'PAR';
          break;
        case 1:
          scoreText = 'SKOLLI';
          break;
        case 2:
          scoreText = '2X SKOLLI';
          break;
        case 3:
          scoreText = '3X SKOLLI';
          break;
        default:
          if (relativeScore < -3) {
            scoreText = 'ÁS';
          } else {
            scoreText = 'ANNAÐ';
          }
      }
    }

    return scoreText;
  }

  Color _getBackgroundColor() {
    int score = widget.player.strokes[widget.holeIndex];
    int par = widget.holes[widget.holeIndex].par;
    int relativeScore = score - par;

    //return color depending on relative score
    switch (relativeScore) {
      case < -2:
        return Colors.orange;
      case -2:
        return Colors.green.shade400;
      case -1:
        return Colors.red.shade400;
      case 0:
        return const Color(0XFF3270A2);
      case 1:
        return Colors.grey;
      case 2:
        return Colors.grey.shade700;
      case >= 3:
        return Colors.grey.shade900;
      default:
        return const Color(0XFF3270A2);
    }
  }

  void _showCounter() {
    HapticFeedback.selectionClick();
    setState(() {
      showCounter = true;
      strokeCount = widget.holes[widget.holeIndex].par;
      widget.player.strokes[widget.holeIndex] = strokeCount;
      _updateStrokeCount(0, widget.player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return showCounter
        ? Expanded(
            child: Row(
              children: [
                RelativeScoreWidget(player: widget.player),
                const Spacer(),
                SizedBox(
                  height: 63,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _getBackgroundColor(),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            _updateStrokeCount(-1, widget.player);
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
                            color: Colors.grey.shade200,
                          ),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    _displayScoreText(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    strokeCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            _updateStrokeCount(1, widget.player);
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Row(
              children: [
                RelativeScoreWidget(player: widget.player),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 35),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showCounter();
                  },
                ),
              ],
            ),
          );
  }
}

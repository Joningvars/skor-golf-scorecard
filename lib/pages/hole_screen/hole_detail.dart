import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/hole_screen/custom_counter.dart';
import 'package:score_card/pages/round_setup_screen/player_button.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/widgets/custom_appbar.dart';

class HoleDetail extends StatelessWidget {
  final Hole currentHole;
  final int currentHoleIndex;
  final int totalHoles;
  final List<Hole> holes;
  final GolfCourse course;
  final List<Player> players;
  final int selectedTee;
  final PageController controller;
  final int pageIndex;

  const HoleDetail({
    super.key,
    required this.currentHole,
    required this.pageIndex,
    required this.currentHoleIndex,
    required this.totalHoles,
    required this.holes,
    required this.course,
    required this.players,
    required this.selectedTee,
    required this.controller,
  });

  void _showHoleNavigator(
      BuildContext context, int currentIndex, List<Hole> holes) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.golf_course_rounded,
                            size: 40,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Hola ${currentIndex + 1}',
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (currentIndex < holes.length)
                        Padding(
                          padding: const EdgeInsets.only(left: 80.0),
                          child: Text(
                            'Par ${holes[currentIndex].par}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color: Colors.grey.shade200,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // 5 columns
                        childAspectRatio: 1.3, // Rectangular buttons
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: holes.length,
                      itemBuilder: (context, index) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: const CircleBorder(),
                                backgroundColor: index == currentIndex
                                    ? theme.colorScheme.secondary
                                    : Colors.grey.shade300,
                              ),
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.pop(context);
                                controller.jumpToPage(index);
                                setState(() {});
                              },
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: index == currentIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: SizedBox(
                      height: 50,
                      width: 350,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          controller
                              .jumpTo(controller.position.maxScrollExtent);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: Colors.white),
                        child: const Text(
                          'Klára Hring',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CustomAppBar(
        title: '',
        leadAction: IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showHoleNavigator(
                context,
                currentHoleIndex,
                holes,
              );
            }),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.04,
            ),
            child: OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.landscape
                    ? SingleChildScrollView(
                        child: _buildContent(
                            currentHole, theme, context, screenSize),
                      )
                    : _buildContent(currentHole, theme, context, screenSize);
              },
            ),
          ),
        ),
      ),
    );
  }

  String getDistanceForSelectedTee(Hole hole, int selectedTee) {
    switch (selectedTee) {
      case 0:
        return '${hole.yellowTee} m';
      case 1:
        return '${hole.redTee} m';
      case 2:
        return '${hole.whiteTee} m';
      case 3:
        return '${hole.blueTee} m';
      default:
        return '${hole.yellowTee} m';
    }
  }

  Widget _buildContent(Hole currentHole, ThemeData theme, BuildContext context,
      Size screenSize) {
    return Column(
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Stack(children: [
              Positioned(
                top: 4,
                left: 4,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  width: 40,
                  child: IconShadow(
                    Icon(
                      Icons.golf_course_rounded,
                      color: Color.fromARGB(121, 12, 32, 48),
                      size: 90,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Icon(
                  Icons.golf_course_rounded,
                  color: Color(0XFF195482),
                  size: 90,
                ),
              ),
            ]),
            GestureDetector(
              onTap: () => _showHoleNavigator(
                context,
                currentHoleIndex,
                holes,
              ),
              child: Text(
                ' ${pageIndex.toString()}',
                style: TextStyle(
                  fontSize: screenSize.width * 0.399,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      offset: Offset(8.0, 8.0),
                      blurRadius: 0,
                      color: Color.fromARGB(82, 7, 19, 29),
                    ),
                  ],
                ),
              ),
            ),
            currentHole.par != 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Par ${currentHole.par}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.07,
                          color: const Color.fromARGB(255, 211, 221, 232),
                          shadows: const [
                            Shadow(
                              offset: Offset(3.0, 2.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(82, 7, 19, 29),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        getDistanceForSelectedTee(currentHole, selectedTee),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.069,
                          color: const Color(0XFF3270A2),
                          shadows: const [
                            Shadow(
                              offset: Offset(3.0, 2.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(82, 7, 19, 29),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'FGJ ${currentHole.handicap}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.038,
                          color: Colors.grey,
                          shadows: const [
                            Shadow(
                              offset: Offset(3.0, 2.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(82, 15, 39, 58),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(width: 80)
          ],
        ),
        const Divider(
          color: Color.fromARGB(82, 15, 39, 58),
          thickness: 4,
        ),
        const Spacer(),
        if (players.isNotEmpty)
          Column(
            children: players.map((player) {
              return Column(
                children: [
                  SizedBox(height: screenSize.height * 0.01),
                  Row(
                    children: [
                      PlayerButton(
                        player: player,
                        onDelete: () {},
                        onEdit: () {},
                      ),
                      CustomCounter(
                        player: player,
                        holeIndex: currentHoleIndex,
                        holes: holes,
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        const Spacer(),
        Icon(
          Icons.swipe,
          color: const Color.fromARGB(255, 27, 91, 141),
          size: screenSize.width * 0.1,
        ),
      ],
    );
  }
}

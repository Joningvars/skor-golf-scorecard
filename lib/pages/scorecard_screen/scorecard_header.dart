import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';

class CourseInfoHeader extends StatelessWidget {
  const CourseInfoHeader({
    super.key,
    required this.currentOrientation,
    required this.formattedDate,
    required this.course,
  });

  final Orientation currentOrientation;
  final String formattedDate;
  final GolfCourse course;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentOrientation == Orientation.landscape)
            Text(
              formattedDate,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            '${course.clubName} (${course.name})',
            style: const TextStyle(color: Colors.white, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'ÖRN',
                  style: TextStyle(color: Colors.green, fontSize: 10),
                ),
                const SizedBox(width: 5),
                const Text(
                  'FUGL',
                  style: TextStyle(color: Colors.red, fontSize: 10),
                ),
                const SizedBox(width: 5),
                const Text(
                  'PAR',
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 109, 168),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'SKOLLI',
                  style: TextStyle(color: Colors.grey[300], fontSize: 10),
                ),
                const SizedBox(width: 5),
                const Text(
                  '2x SKOLLI',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

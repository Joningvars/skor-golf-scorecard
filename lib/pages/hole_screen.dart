import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/widgets/customAppBar.dart';

class HoleDetailPage extends StatefulWidget {
  final Hole hole;
  int selectedTee;

  HoleDetailPage({Key? key, required this.hole, required this.selectedTee})
      : super(key: key);

  @override
  _HoleDetailPageState createState() => _HoleDetailPageState();
}

class _HoleDetailPageState extends State<HoleDetailPage> {
  int strokeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Hole ${widget.hole.number}'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Par: ${widget.hole.par}'),
            Text('Distance: ${widget.selectedTee} m'),
            const SizedBox(height: 16),
            Text('Strokes: $strokeCount'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  strokeCount++;
                });
              },
              child: const Text('Add Stroke'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:score_card/widgets/customAppBar.dart';

class ScoreCardScreen extends StatelessWidget {
  const ScoreCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Skorkort'),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 88,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey,
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

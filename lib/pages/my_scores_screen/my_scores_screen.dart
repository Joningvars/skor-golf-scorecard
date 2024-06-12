import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:score_card/models/round.dart';
import 'package:score_card/widgets/custom_appbar.dart';
import 'package:score_card/pages/my_scores_screen/savedRoundTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScoresScreen extends StatefulWidget {
  const MyScoresScreen({super.key});

  @override
  _MyScoresScreenState createState() => _MyScoresScreenState();
}

class _MyScoresScreenState extends State<MyScoresScreen> {
  List<Round> savedRounds = [];

  @override
  void initState() {
    super.initState();
    _loadRounds();
  }

  Future<void> _loadRounds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? roundJsonStrings = prefs.getStringList('savedRounds');
    if (roundJsonStrings != null) {
      setState(() {
        savedRounds = roundJsonStrings.map((jsonString) {
          return Round.fromJson(json.decode(jsonString));
        }).toList();
      });
    }
  }

  Future<void> _deleteRound(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? roundJsonStrings = prefs.getStringList('savedRounds');
    if (roundJsonStrings != null) {
      roundJsonStrings.removeAt(index);
      await prefs.setStringList('savedRounds', roundJsonStrings);
      setState(() {
        savedRounds.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Mínir Hringir'),
      body: Container(
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
        child: savedRounds.isNotEmpty
            ? ListView.builder(
                itemCount: savedRounds.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(savedRounds[index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteRound(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: SavedRoundTile(round: savedRounds[index]),
                  );
                },
              )
            : Center(
                child: Text(
                  'Engir vistaðir hringir...',
                  style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}

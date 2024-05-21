import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/widgets/customAppBar.dart';
import 'package:score_card/widgets/tee_select_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPlayerScreen extends StatefulWidget {
  final GolfCourse course;
  final Function(String, String, int) onAddPlayer;
  final Player? initialPlayer;
  final VoidCallback? onDeletePlayer;

  const AddPlayerScreen({
    super.key,
    required this.course,
    required this.onAddPlayer,
    this.initialPlayer,
    this.onDeletePlayer,
  });

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late int _selectedTee;
  final _formKey = GlobalKey<FormState>();

  void _deletePlayer() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eyða golfara',
            style: TextStyle(color: theme.primaryColor),
          ),
          content: const Text('viltu eyða golfara?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();

                Navigator.of(context).pop();
              },
              child: Text(
                'Hætta við',
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                HapticFeedback.lightImpact();

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final List<String>? playerJsonList =
                    prefs.getStringList('players');
                if (playerJsonList != null) {
                  List<Player> players = playerJsonList
                      .map((jsonString) =>
                          Player.fromJson(json.decode(jsonString)))
                      .toList();

                  players.remove(widget.initialPlayer);

                  final List<String> updatedPlayerJsonList = players
                      .map((player) => json.encode(player.toJson()))
                      .toList();

                  await prefs.setStringList('players', updatedPlayerJsonList);
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();

                if (widget.onDeletePlayer != null) {
                  widget.onDeletePlayer!();
                }
              },
              child: const Text(
                'Eyða',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _selectedTee = widget.initialPlayer?.selectedTee ?? 0;
    if (widget.initialPlayer != null) {
      _firstNameController.text = widget.initialPlayer!.firstName;
      _lastNameController.text = widget.initialPlayer!.lastName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Golfari'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Fornafn'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vinsamlegast fylltu út.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Eftirnafn'),
              ),
              TeeSelectDropdown(course: widget.course),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: theme.scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        HapticFeedback.lightImpact();

                        if (_formKey.currentState!.validate()) {
                          widget.onAddPlayer(
                            _firstNameController.text,
                            _lastNameController.text,
                            _selectedTee,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Vista',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (widget.initialPlayer != null)
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: theme.scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: _deletePlayer,
                        child: const Text(
                          'Eyða',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';

class TeeSelectDropdown extends StatefulWidget {
  final GolfCourse course;
  final void Function(int)? onItemSelected;

  const TeeSelectDropdown({
    super.key,
    required this.course,
    this.onItemSelected,
  });

  @override
  State<TeeSelectDropdown> createState() => _TeeSelectDropdownState();
}

class _TeeSelectDropdownState extends State<TeeSelectDropdown> {
  int _selectedTee = 0;
  late ExpansionTileController _controller;
  String _selectedTeeTitle = 'Gulur';

  @override
  void initState() {
    super.initState();
    _controller = ExpansionTileController();
    _selectedTee = widget.course.yellowTee; //default gulur
    _selectedTeeTitle = 'Gulur';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          backgroundColor: Colors.black12,
          leading: const Icon(Icons.sports_golf_outlined),
          title: Text('Velja teig ($_selectedTeeTitle)'),
          initiallyExpanded: false,
          controller: _controller,
          children: [
            buildTeeTile('Hvítur', widget.course.whiteTee.toString(),
                widget.course.whiteTee, Colors.white),
            buildTeeTile('Gulur', widget.course.yellowTee.toString(),
                widget.course.yellowTee, Colors.yellow),
            buildTeeTile('Blár', widget.course.blueTee.toString(),
                widget.course.blueTee, Colors.blue),
            buildTeeTile('Rauður', widget.course.redTee.toString(),
                widget.course.redTee, Colors.red),
          ],
        ),
      ],
    );
  }

  ListTile buildTeeTile(String title, String subtitle, int tee, Color color) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(Icons.sports_golf_rounded, color: color),
      onTap: () {
        setState(() {
          _selectedTee = tee;
          _selectedTeeTitle = title;
        });
        _controller.collapse();
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(tee);
        }
      },
      selected: _selectedTee == tee,
    );
  }
}

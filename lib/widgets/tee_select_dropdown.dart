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

  @override
  void initState() {
    super.initState();
    _controller = ExpansionTileController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          leading: const Icon(Icons.sports_golf_outlined),
          title: Text('Velja teig'),
          initiallyExpanded: false,
          controller: _controller,
          children: [
            buildTeeTile('Hvítur', widget.course.whiteTee.toString(),
                widget.course.redTee),
            buildTeeTile('Gulur', widget.course.yellowTee.toString(),
                widget.course.redTee),
            buildTeeTile(
                'Blár', widget.course.blueTee.toString(), widget.course.redTee),
            buildTeeTile('Rauður', widget.course.redTee.toString(),
                widget.course.redTee),
          ],
        ),
      ],
    );
  }

  ListTile buildTeeTile(String title, String subtitle, int tee) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        int selectedTeeValue;
        switch (title) {
          case 'Hvítur':
            selectedTeeValue = widget.course.whiteTee;
            break;
          case 'Gulur':
            selectedTeeValue = widget.course.yellowTee;
            break;
          case 'Blár':
            selectedTeeValue = widget.course.blueTee;
            break;
          case 'Rauður':
            selectedTeeValue = widget.course.redTee;
            break;
          default:
            selectedTeeValue = -1;
        }

        setState(() {
          _selectedTee = selectedTeeValue;
        });
        _controller.collapse();
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(selectedTeeValue);
        }
      },
      selected: _selectedTee == tee,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/widgets/tee_select_dropdown.dart';

class AddPlayerScreen extends StatefulWidget {
  AddPlayerScreen({super.key, required this.course, required this.onAddPlayer});

  final GolfCourse course;
  final void Function(String, String, int) onAddPlayer;

  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  int _selectedTee = 0;
  final _formKey = GlobalKey<FormState>();

  void _onAddPlayer() {
    if (_formKey.currentState!.validate()) {
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      if (firstName.isNotEmpty && lastName.isNotEmpty && _selectedTee != 0) {
        widget.onAddPlayer(firstName, lastName, _selectedTee);
        _firstNameController.clear();
        _lastNameController.clear();
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Vinsamlegast fyllut út í allar eyður.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bæta við golfara'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
                controller: _firstNameController, hintText: 'Fornafn'),
            const Divider(thickness: 1, color: Colors.black26),
            _buildTextField(
                controller: _lastNameController, hintText: 'Eftirnafn'),
            const Divider(thickness: 1, color: Colors.black26),
            TeeSelectDropdown(
              course: widget.course,
              onItemSelected: (selectedTee) {
                setState(() {
                  _selectedTee = selectedTee;
                });
              },
            ),
            const Divider(thickness: 1, color: Colors.black26),
            SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(
                onPressed: _onAddPlayer,
                child: Text('Bæta við'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hintText}) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vinsamlegast fylltu út $hintText';
            }
            return null;
          },
          decoration: InputDecoration(
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
            labelText: hintText,
          ),
        ),
      ),
    );
  }
}

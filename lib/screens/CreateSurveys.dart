import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/survey.dart';
import 'main/components/side_menu.dart';

class CreateSurveyPage extends StatefulWidget {
  @override
  _CreateSurveyPageState createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _choiceController = TextEditingController();
  final List<String> _choices = [];
  bool _isActive = true;

  void _addChoice() {
    if (_choiceController.text.isNotEmpty) {
      setState(() {
        _choices.add(_choiceController.text);
        _choiceController.clear();
      });
    }
  }

  void _createSurvey() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty || _choices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs et ajouter au moins un choix.')),
      );
      return;
    }

    final survey = Survey(
      //id: 0, // Peut-être généré par le backend
      //dateCreated: DateTime.now(),
      title: _titleController.text,
      description: _descriptionController.text,
      active: _isActive,
      //choices: _choices,
      //votes: List.filled(_choices.length, 0),
    );

    final response = await Survey.createSurvey(survey);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final surveyId = responseData['data']['id'];

      print("surveyId");
      print(surveyId);


      print("choices");
      // Création des choix pour le sondage
      for (String choice in _choices) {
        print(surveyId);
        print(choice);
        await Survey.createChoice(surveyId, choice);
      }

      // Si le sondage et les choix sont créés avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sondage et choix créés avec succès!')),
      );
      // Effacer le formulaire
      _titleController.clear();
      _descriptionController.clear();
      _choiceController.clear();
      setState(() {
        _choices.clear();
        _isActive = true;
      });
    } else {
      // Si quelque chose ne va pas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du sondage: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Sondage'),
      ),
      body: Row(
        children: [
          // Side Menu
          SideMenu(),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _choiceController,
                          decoration: InputDecoration(
                            labelText: 'Choix',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addChoice,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 6.0,
                    children: _choices.map((choice) {
                      return Chip(
                        label: Text(choice),
                        onDeleted: () {
                          setState(() {
                            _choices.remove(choice);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  SwitchListTile(
                    title: Text('Actif'),
                    value: _isActive,
                    onChanged: (bool value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _createSurvey,
                    child: Text('Créer le Sondage'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _choiceController.dispose();
    super.dispose();
  }
}

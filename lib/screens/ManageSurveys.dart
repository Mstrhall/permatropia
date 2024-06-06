import 'package:flutter/material.dart';
import '../models/survey.dart';
import 'main/components/side_menu.dart';

class ManageSurveysPage extends StatefulWidget {
  @override
  _ManageSurveysPageState createState() => _ManageSurveysPageState();
}

class _ManageSurveysPageState extends State<ManageSurveysPage> {
  List<Survey> _surveys = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSurveys();
  }

  Future<void> _fetchSurveys() async {
    try {
      List<Survey> surveys = await Survey.fetchAllSurveys();
      setState(() {
        _surveys = surveys;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch surveys: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSurvey(Survey survey) async {
    final response = await Survey.updateSurvey(survey);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sondage mis à jour avec succès!')),
      );
      _fetchSurveys();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour du sondage: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> _deleteSurvey(int id) async {
    final response = await Survey.deleteSurvey(id);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sondage supprimé avec succès!')),
      );
      _fetchSurveys();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du sondage: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Sondages'),
      ),
      body: Row(
        children: [
          // Side Menu
          SideMenu(),
          // Main Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _surveys.length,
              itemBuilder: (context, index) {
                final survey = _surveys[index];
                return ListTile(
                  title: Text(survey.title),
                  subtitle: Text(survey.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Implémenter la logique de mise à jour
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteSurvey(survey.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class Survey {
  final int? id;
  final DateTime? dateCreated;
  final String title;
  final String description;
  final bool active;
  final List<String>? choices;
  final List<int>? votes;

  Survey({
    this.id,
    this.dateCreated,
    required this.title,
    required this.description,
    required this.active,
    this.choices,
    this.votes,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      dateCreated: json['date_created'] != null ? DateTime.parse(json['date_created']) : null,
      title: json['title'],
      description: json['description'],
      active: json['active'],
      choices: json['choices']?.cast<String>(),
      votes: json['votes']?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'active': active,
      'choices': choices,  // Assuming 'choices' can be directly serialized.
      'votes': votes       // Assuming 'votes' can be directly serialized.
    };
  }

  static Future<http.Response> createSurvey(Survey survey) {
    return http.post(
      Uri.parse('https://permatropia-grp2.webturtle.fr/items/surveys'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(survey.toJson()),
    );
  }

  static Future<http.Response> createChoice(int surveyId, String choice) {
    return http.post(
      Uri.parse('https://permatropia-grp2.webturtle.fr/items/surveys_choices'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'survey_id': surveyId, 'label': choice}),
    );
  }

  static Future<http.Response> updateSurvey(Survey survey) {
    assert(survey.id != null, 'Survey ID cannot be null for update operation');
    return http.patch(
      Uri.parse('https://permatropia-grp2.webturtle.fr/items/surveys/${survey.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(survey.toJson()),
    );
  }

  static Future<List<Survey>> fetchAllSurveys() async {
    final response = await http.get(
      Uri.parse('https://permatropia-grp2.webturtle.fr/items/surveys'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['data'];
      return body.map((dynamic item) => Survey.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load surveys: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<http.Response> deleteSurvey(int id) {
    assert(id != null, 'Survey ID cannot be null for delete operation');
    return http.delete(
      Uri.parse('https://permatropia-grp2.webturtle.fr/items/surveys/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}

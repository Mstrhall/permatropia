import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String apiUrl = 'https://permatropia-grp2.webturtle.fr';

  login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> json = jsonDecode(response.body);
        return json['data']['access_token'];
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Catch any network errors or exceptions during the HTTP request.
      print('Error: $e');
      throw Exception('Failed to connect to the server. Please check your internet connection.');
    }
  }
}

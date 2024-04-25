import 'dart:convert';

import 'package:admin/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Screen'),
      ),
      body: Center(
        child: FutureBuilder(
          future: getCategories(context),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final category = snapshot.data?[index];
                    return ListTile(
                      title: Text(category['label']),
                      subtitle: Text('Transactions: ${category['transactions'].length}'),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<List<dynamic>> getCategories(BuildContext context) async {
    final url = Uri.parse('https://permatropia-grp1.webturtle.fr/items/sections');

    var authService = Provider.of<AuthService>(context, listen: false);
    var headers = await authService.getAuthenticatedHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

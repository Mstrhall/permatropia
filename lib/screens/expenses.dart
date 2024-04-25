import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scrollable_table_view/scrollable_table_view.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<List<dynamic>> _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url = Uri.parse('https://permatropia-grp1.webturtle.fr/items/transactions');
    const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjkzNWRjNjlmLTM2NzUtNDFlYy05NjgwLTI0Mjc4Yjg5MDViOCIsInJvbGUiOiI2MjUwZTVmNC1hYmM4LTQ0YTAtYTlmYS00ZTlhNGExYWY0MjQiLCJhcHBfYWNjZXNzIjoxLCJhZG1pbl9hY2Nlc3MiOjEsImlhdCI6MTcxNDAyNzQ0NSwiZXhwIjoxNzE0MDI4MzQ1LCJpc3MiOiJkaXJlY3R1cyJ9.qi4-eWI7-5ltesQUIok8YxfykSwY6JqqVAy6yzn2dy8';

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            _rows = List<List<dynamic>>.from(data['data'].map((record) {
              return [
                record['id'].toString(),
                record['label'],
                record['total'].toString(),
              ];
            }));
          });
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Center(
        child: _rows.isNotEmpty
            ? ScrollableTableView(
                headers: ["ID", "Label", "Total"]
                    .map((label) => TableViewHeader(label: label))
                    .toList(),
                rows: _rows
                   
                    .map((row) => TableViewRow(
                        cells: row
                            .map((cell) => TableViewCell(
                                child: Text(cell as String, style: const TextStyle(fontSize: 16)))
                            )
                            .toList()
                    ))
                    .toList(),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

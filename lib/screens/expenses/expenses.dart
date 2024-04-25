import 'dart:convert';
import 'package:admin/controllers/TokenProvider.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url = Uri.parse('https://permatropia-grp1.webturtle.fr/items/transactions');
/*     const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjkzNWRjNjlmLTM2NzUtNDFlYy05NjgwLTI0Mjc4Yjg5MDViOCIsInJvbGUiOiI2MjUwZTVmNC1hYmM4LTQ0YTAtYTlmYS00ZTlhNGExYWY0MjQiLCJhcHBfYWNjZXNzIjoxLCJhZG1pbl9hY2Nlc3MiOjEsImlhdCI6MTcxNDAzMzY3NiwiZXhwIjoxNzE0MDM0NTc2LCJpc3MiOiJkaXJlY3R1cyJ9.5m1peqUVZ2eOLmwc41o_oBHdOq4kXoU5ar63p4ZzN3E';
 */    String token = Provider.of<TokenProvider>(context).token;

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            _rows = List<DataRow>.from(data['data'].map((record) {
              return DataRow(
                cells: [
                  DataCell(Text(record['id'].toString())),
                  DataCell(Text(record['label'])),
                  DataCell(Text(record['total'].toString())),
                  DataCell(Text(record['details'])),
                  DataCell(Text(record['accounting_date'])),
                  DataCell(Text(record['quantity'].toString())),
                  DataCell(Text(record['transaction_type'])),
                ],
              );
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
      drawer: SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
          Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _rows.isNotEmpty
                  ? DataTable(
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Label')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Details')),
                        DataColumn(label: Text('Accounting Date')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Transaction Type')),
                      ],
                      rows: _rows,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

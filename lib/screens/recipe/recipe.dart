import 'dart:convert';
import 'package:admin/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../responsive.dart';
import '../main/components/side_menu.dart';
import '../../constants.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<List<dynamic>> _rows = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://permatropia-grp2.webturtle.fr/items/transactions?filter[transaction_type][_eq]=income');
    var authService = Provider.of<AuthService>(context, listen: false);
    var headers = await authService.getAuthenticatedHeaders();

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            _rows = List<List<dynamic>>.from(data['data'].map((record) {
              return [
                record['id'].toString(),
                record['label'],
                record['details'],
                record['document_id'],
                record['accounting_date'],
                record['user_id'],
                record['share_id'],
                record['quantity'],
                record['unit_price'],
                record['total'],
                record['exercice_id'],
                record['validated'],
                record['service_dates'],
              ];
            }));
            _isLoading = false;
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
        title: Text('Recettes'),
      ),
      body: Row(
        children: [
          // Side Menu
          SideMenu(),
          // Main Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.4,
                  child: DataTable(
                    columnSpacing:
                    MediaQuery.of(context).size.width / 20,
                    dataRowHeight:40,
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Label')),
                      DataColumn(label: Text('Details')),
                      DataColumn(label: Text('Document ID')),
                      DataColumn(
                          label: Text('Accounting Date')),
                      DataColumn(label: Text('User ID')),
                      DataColumn(label: Text('Share ID')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Unit Price')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Exercice ID')),
                      DataColumn(label: Text('Validated')),
                      DataColumn(label: Text('Service Dates')),
                    ],
                    rows: _rows.asMap().entries.map((entry) {
                      final rowIndex = entry.key;
                      final rowData = entry.value;
                      return DataRow(
                        cells: rowData
                            .map((data) =>
                            DataCell(Text(data.toString())))
                            .toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

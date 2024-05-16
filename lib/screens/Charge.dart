import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main/components/side_menu.dart'; // Import du widget du side menu

class ChargesScreen extends StatefulWidget {
  const ChargesScreen({Key? key}) : super(key: key);

  @override
  _ChargesScreenState createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
  List<Map<String, dynamic>> _charges = [];
  bool _isLoading = true; // Variable pour le chargement

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true; // Mettre isLoading à true au début de la requête
    });

    final url = Uri.parse(
        'https://flutter-api.webturtle.fr/items/users?filter[is_associate][_eq]=true&deep[transactions][_filter][item_id][_eq]=16&deep[transactions][_filter][accounting_date][_gt]=2022-12-31&deep[transactions][_aggregate][sum]=total&deep[transactions][_groupBy]=user_id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            _charges = List<Map<String, dynamic>>.from(data['data'].map((charge) {
              final id = charge['id'];
              final fullname = charge['fullname'];
              final transactions = charge['transactions'] as List<dynamic>;

              int totalPaid = 0;
              if (transactions.isNotEmpty) {
                totalPaid = transactions[0]['sum']['total'] ?? 0;
              }

              final remainingAmount = 1400 - totalPaid; // Total amount is 1400

              return {
                'id': id,
                'fullname': fullname,
                'total_paid': totalPaid,
                'remaining_amount': remainingAmount,
              };
            }));
            _isLoading = false; // Mettre isLoading à false une fois que les données sont chargées
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
        title: Text('Charges Payées par les Associés'),
      ),
      body: Row(
        children: [
          // Side Menu
          SideMenu(),
          // Main Content
          Expanded(
            child: _isLoading // Vérifier si les données sont en cours de chargement
                ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
                : SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Full Name')),
                  DataColumn(label: Text('Total Paid')),
                  DataColumn(label: Text('Remaining Amount')),
                  DataColumn(label: Text('Payment Progress')),
                ],
                rows: _charges.map((charge) {
                  return DataRow(cells: [
                    DataCell(Text(charge['id'].toString())),
                    DataCell(Text(charge['fullname'])),
                    DataCell(Text(charge['total_paid'].toString())),
                    DataCell(Text(charge['remaining_amount'].toString())), // New cell
                    DataCell(
                      Column(
                        children: [
                          LinearProgressIndicator(
                            value: charge['total_paid'] / 1400, // 1400 is the total amount
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(height: 5),
                          Text('${(charge['total_paid'] / 1400 * 100).toStringAsFixed(2)}%'),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

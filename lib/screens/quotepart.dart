import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../responsive.dart';
import '../../constants.dart';
import 'main/components/side_menu.dart';

class QuotePartScreen extends StatefulWidget {
  const QuotePartScreen({Key? key}) : super(key: key);

  @override
  _QuotePartScreenState createState() => _QuotePartScreenState();
}

class _QuotePartScreenState extends State<QuotePartScreen> {
  List<Map<String, dynamic>> _quoteParts = [];
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
        'https://permatropia-grp2.webturtle.fr/Items/shares?fields[]=*,user_id.fullname,transactions.total&_aggregation=transactions.total:sum');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            _quoteParts = List<Map<String, dynamic>>.from(data['data'].map((quotePart) {
              final userId = quotePart['user_id'];
              final userFullName = userId != null ? userId['fullname'] : "N/A";

              int totalPaid = 0;
              if (quotePart['transactions'] is List) {
                totalPaid = quotePart['transactions'].fold(0, (prev, transaction) => prev + (transaction['total'] ?? 0));
              }

              final remainingAmount = 50000 - totalPaid;
              final paymentPercentage = (totalPaid / 50000) * 100;

              return {
                'id': quotePart['id'],
                'fullname': userFullName,
                'remaining_amount': remainingAmount,
                'payment_percentage': paymentPercentage,
                'total_paid': totalPaid, // Ajout de la valeur totale payée
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
        title: Text('Quote Parts'),
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
                  DataColumn(label: Text('Remaining Amount')),
                  DataColumn(label: Text('Payment Progress')),
                ],
                rows: _quoteParts.map((quotePart) {
                  return DataRow(cells: [
                    DataCell(Text(quotePart['id'].toString())),
                    DataCell(Text(quotePart['fullname'])),
                    DataCell(Text(quotePart['remaining_amount'].toString())),
                    DataCell(Column(
                      children: [
                        Text('${quotePart['payment_percentage'].toStringAsFixed(2)}%'),
                        SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: (quotePart['payment_percentage'] / 100),
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        SizedBox(height: 5),
                        Text('Total Paid: ${quotePart['total_paid']}'), // Affichage de la valeur totale payée
                      ],
                    )),
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

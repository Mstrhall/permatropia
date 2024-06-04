import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/auth.service.dart';

class UserTransactionsWidget extends StatefulWidget {
  final int userId;

  const UserTransactionsWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _UserTransactionsWidgetState createState() => _UserTransactionsWidgetState();
}

class _UserTransactionsWidgetState extends State<UserTransactionsWidget> {
  List<dynamic> _shares = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://permatropia-grp2.webturtle.fr/items/shares?filter[user_id][_eq]=${widget.userId}');
    var authService = Provider.of<AuthService>(context, listen: false);
    var headers = await authService.getAuthenticatedHeaders();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] is List) {
          setState(() {
            _shares = data['data'];
            _isLoading = false;
          });
        } else {
          // Affichez un message d'erreur ou gérez la situation de manière appropriée
          print('Error: Data is not a List');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: _shares.length,
      itemBuilder: (context, index) {
        final share = _shares[index];
        final shareId = share['id'];
        final transactions = share['transactions'] as List<dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share ID: $shareId'),
            if (transactions.isNotEmpty)
              DataTable(
                columns: [
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Amount')),
                ],
                rows: transactions.map((transaction) {
                  final transactionId = transaction['id'];
                  return DataRow(cells: [
                    DataCell(Text(transactionId.toString())),
                  ]);
                }).toList(),
              ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

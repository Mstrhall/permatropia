import 'dart:convert';
import 'package:http/http.dart' as http;

class Transaction {
  final int? id;
  final String? label;
  final String? details;
  final String? documentId;
  final String? accountingDate;
  final int? userId;
  final int? total;
  final String? transactionType;


  Transaction({
    required this.id,
    required this.label,
    required this.details,
    required this.documentId,
    required this.accountingDate,
    required this.userId,
    required this.total,
    required this.transactionType,

  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      label: json['label'],
      details: json['details'],
      documentId: json['document_id'],
      accountingDate: json['accounting_date'],
      userId: json['user_id'],
      total: json['total'],
      transactionType: json['transaction_type'],
    );
  }

  static Future<List<Transaction>> fetchTransactions(int userId, int itemId) async {
    final response = await http.get(
      Uri.parse('https://permatropia-grp2.webturtle.fr/items/transactions?filter[user_id][_eq]=$userId&filter[item_id][_eq]=$itemId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((transaction) => Transaction.fromJson(transaction)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}

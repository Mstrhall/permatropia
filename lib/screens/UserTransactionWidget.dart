import 'package:flutter/material.dart';
import '../models/transaction.dart';

class UserTransactionsWidget extends StatelessWidget {
  final int userId;
  final int itemId;
  final String title;

  UserTransactionsWidget({required this.userId, required this.itemId, required this.title});

  double calculateTotal(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.total!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: Transaction.fetchTransactions(userId, itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucune transaction trouvée'));
        } else {
          List<Transaction> transactions = snapshot.data!;
          double total = calculateTotal(transactions);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              'Transaction ID: ${transaction.id}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Label: ${transaction.label}'),
                                Text('Details: ${transaction.details}'),
                                Text('Document ID: ${transaction.documentId}'),
                                Text('Date: ${transaction.accountingDate}'),
                                Text('Montant: ${transaction.total}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'UserTransactionWidget.dart';

class DetailUserPage extends StatefulWidget {
  const DetailUserPage({Key? key}) : super(key: key);

  @override
  _DetailUserPageState createState() => _DetailUserPageState();
}

class _DetailUserPageState extends State<DetailUserPage> {
  final TextEditingController _userIdController = TextEditingController();
  int? _userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(
                labelText: 'ID de l\'utilisateur',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _userId = int.tryParse(value);
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_userId != null) {
                  // Lancer la recherche des transactions
                  FocusScope.of(context).unfocus();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez saisir un ID valide')));
                }
              },
              child: Text('Rechercher'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _userId != null
                  ? Column(
                children: [
                  Expanded(
                    child: UserTransactionsWidget(userId: _userId!, itemId: 16, title: 'charges',),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: UserTransactionsWidget(userId: _userId!, itemId: 17, title: 'quotes part',),
                  ),
                ],
              )
                  : Center(child: Text('Veuillez saisir un ID pour afficher les transactions')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}

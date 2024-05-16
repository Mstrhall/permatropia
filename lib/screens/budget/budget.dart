import 'dart:convert';
import 'package:admin/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart library
import 'dart:math' as Math;

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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Display the pie chart
                      PieChartSample2(categories: snapshot.data),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<List<dynamic>> getCategories(BuildContext context) async {
    final categories = await getTotalByCategories(context);
    return categories;
  }

  Future<List<dynamic>> getTotalByCategories(BuildContext context) async {
    final url = Uri.parse(
        'https://permatropia-grp1.webturtle.fr/items/sections?fields=id,label,transactions.total&_aggregation=transactions.total:sum');

    var authService = Provider.of<AuthService>(context, listen: false);
    var headers = await authService.getAuthenticatedHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      data.forEach((element) {
        var total = 0.0;
        element['transactions'].forEach((el) {
          total += el['total'];
        });
        element['total'] = total;
      });
      return data;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

class PieChartSample2 extends StatelessWidget {
  final List<dynamic>? categories;

  PieChartSample2({Key? key, this.categories}) : super(key: key);

  // Define fixed colors for the pie chart sections
  final List<Color> sectionColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pink,
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 800,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections:
                    showingSections(), // Generate pie chart sections based on categories
              ),
            ),
          ),
          SizedBox(width: 200), // Add margin between chart and legend
          Expanded(
            child: ListView(
              children:
                  legendItems(), // Generate legend items based on categories
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    var total = 0.0;

    // Calculate total amount
    categories?.forEach((category) {
      total += category['total'];
    });

    // Generate pie chart sections dynamically based on category totals
    return List.generate(categories?.length ?? 0, (i) {
      final category = categories?[i];
      final percentage =
          (category['total'] / total) * 100; // Calculate percentage
      return PieChartSectionData(
        color: sectionColors[i % sectionColors.length], // Use fixed colors
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%', // Display percentage
        radius: 60,
      );
    });
  }

  List<Widget> legendItems() {
    return List.generate(categories?.length ?? 0, (i) {
      final category = categories?[i];
      final totalTransactions =
          category['transactions']?.length ?? 0; // Total number of transactions
      final totalAmount = category['total'] ?? 0.0; // Exact total amount

      if (totalAmount != 0.0) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Container(
                    width: 20,
                    height: 20,
                    color: sectionColors[i %
                        sectionColors
                            .length], // Use the same color as the corresponding pie chart section
                  ),
                  title: Text(category['label'] ?? ''),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Transactions: $totalTransactions',
                        style: TextStyle(fontSize: 12), // Reduce font size
                      ),
                      Text(
                        'Total Amount: $totalAmount €',
                        style: TextStyle(fontSize: 12), // Reduce font size
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
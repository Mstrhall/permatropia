import 'dart:convert';
import 'package:admin/responsive.dart';
import 'package:admin/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart library
import 'package:admin/screens/main/components/side_menu.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int _selectedYear = 2022;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
              child: SideMenu(), // Display side menu for desktop
            ),
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                children: [
                  DropdownButton<int>(
                    value: _selectedYear,
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value!;
                      });
                    },
                    items: List.generate(
                      3,
                      (index) => DropdownMenuItem<int>(
                        value: 2022 + index,
                        child: Text((2022 + index).toString()),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getCategories(context),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final filteredCategories = snapshot.data!.where((category) {
                            final transactions = category['transactions'] as List<dynamic>;
                            return transactions.any((transaction) {
                              final accountingDate = transaction['accounting_date'] as String;
                              final year = int.parse(accountingDate.substring(0, 4));
                              return year == _selectedYear;
                            });
                          }).toList();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // Display the pie chart
                                PieChartSample2(categories: filteredCategories),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> getCategories(BuildContext context) async {
    final categories = await getTotalByCategories(context);
    return categories;
  }

  Future<List<dynamic>> getTotalByCategories(BuildContext context) async {
    final url = Uri.parse(
        'https://permatropia-grp1.webturtle.fr/items/sections?fields=id,label,transactions.total,transactions.accounting_date&_aggregation=transactions.total:sum');

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
    const Color.fromRGBO(33, 150, 243, 1),
    Color.fromRGBO(76, 175, 80, 1),
    const Color.fromRGBO(244, 67, 54, 1),
    const Color.fromRGBO(255, 152, 0, 1),
    const Color.fromRGBO(156, 39, 176, 1),
    const Color.fromRGBO(255, 235, 59, 1),
    const Color.fromRGBO(233, 30, 99, 1),
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 700,
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

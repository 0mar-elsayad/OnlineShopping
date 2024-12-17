import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BestSellingChart extends StatefulWidget {
  const BestSellingChart({Key? key}) : super(key: key);

  @override
  State<BestSellingChart> createState() => _BestSellingChartState();
}

class _BestSellingChartState extends State<BestSellingChart> {
  List<String> labels = []; // Product names
  List<int> dataValues = []; // Total sales

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  /// Fetches sales data from Firestore
  Future<void> _fetchSalesData() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('sales').get();

      // Process the data
      final Map<String, int> salesMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String productName = data['productName'] ?? 'Unknown';
        final int quantitySold = data['quantity'] ?? 0;

        // Accumulate quantities for each product
        salesMap[productName] = (salesMap[productName] ?? 0) + quantitySold;
      }

      // Sort and update state
      final sortedSales = salesMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)); // Sort descending

      setState(() {
        labels = sortedSales.map((e) => e.key).toList();
        dataValues = sortedSales.map((e) => e.value).toList();
      });
    } catch (e) {
      print("Error fetching sales data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Best Selling Products"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: labels.isEmpty || dataValues.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Top Selling Products",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        barGroups: List.generate(labels.length, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: dataValues[index].toDouble(),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurpleAccent,
                                    Colors.purpleAccent,
                                  ],
                                ),
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: dataValues.reduce((a, b) => a > b ? a : b)
                                          .toDouble() +
                                      10,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ),
                            ],
                            showingTooltipIndicators: [0],
                          );
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              interval: 10,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    labels.length > index
                                        ? _shortenText(labels[index], 8)
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Utility: Shortens product name for display
  String _shortenText(String text, int maxLength) {
    return text.length > maxLength
        ? "${text.substring(0, maxLength)}..."
        : text;
  }
}

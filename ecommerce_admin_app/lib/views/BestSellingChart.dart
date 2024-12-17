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
      appBar: AppBar(title: const Text("Best Selling Products")),
      body: labels.isEmpty || dataValues.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  barGroups: List.generate(labels.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dataValues[index].toDouble(),
                          color: Colors.deepPurple,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              labels.length > index ? labels[index] : '',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
    );
  }
}

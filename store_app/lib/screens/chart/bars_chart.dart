import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:store_app/api/api_order.dart';
import 'package:store_app/widgets/statistics/status_data.dart';

class BarsChart extends StatefulWidget {
  const BarsChart({super.key});

  @override
  State<BarsChart> createState() => _BarsChartState();
}

class _BarsChartState extends State<BarsChart> {
  final List<Color> gradientColors = [
    Colors.blue,
    Colors.green,
  ];
  final ApiOrder _apiOrder = ApiOrder();

  Future<dynamic> _getDataOrderByStatus() async {
    try {
      final response = await _apiOrder.getDataOrderByStatus();
      final orderCounts = response['orderCounts'] as Map;
      return orderCounts;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Line Chart',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
              future: _getDataOrderByStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                  );
                } else {
                  final orderCounts = snapshot.data;

                  return AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 6,
                        right: 11,
                        top: 18,
                        bottom: 12,
                      ),
                      margin: const EdgeInsets.all(12),
                      child: BarChart(
                        BarChartData(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.7),
                          minY: 0,
                          maxY: 20,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          alignment: BarChartAlignment.spaceAround,
                          gridData: const FlGridData(
                            show: false,
                          ),
                          barTouchData: BarTouchData(
                            enabled: false,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (group) => Colors.transparent,
                              tooltipPadding: EdgeInsets.zero,
                              tooltipMargin: 8,
                              getTooltipItem: (
                                group,
                                groupIndex,
                                rod,
                                rodIndex,
                              ) {
                                return BarTooltipItem(
                                  rod.toY.round() == 0
                                      ? ''
                                      : rod.toY.round().toString(),
                                  const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: BarTitles.getTitleData(),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: orderCounts['NewOrder'].toDouble(),
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                              showingTooltipIndicators: [
                                0,
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: orderCounts['Confirmed'].toDouble(),
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                              showingTooltipIndicators: [
                                0,
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: orderCounts['Processing'].toDouble(),
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                              showingTooltipIndicators: [
                                0,
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: orderCounts['Shipped'].toDouble(),
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                              showingTooltipIndicators: [
                                0,
                              ],
                            ),
                            BarChartGroupData(
                              x: 4,
                              barRods: [
                                BarChartRodData(
                                  toY: orderCounts['Delivered'].toDouble(),
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                              showingTooltipIndicators: [
                                0,
                              ],
                            ),
                            BarChartGroupData(
                              x: 5,
                              barRods: [
                                BarChartRodData(
                                  toY: orderCounts['Cancel'].toDouble(),
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                              showingTooltipIndicators: [
                                0,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

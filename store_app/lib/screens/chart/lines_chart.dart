import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/widgets/statistics/titles_data.dart';

class LinesChart extends StatefulWidget {
  const LinesChart({super.key});

  @override
  State<LinesChart> createState() => _LinesChartState();
}

class _LinesChartState extends State<LinesChart> {
  final Map lineData = {
    0: 0,
    1: 200,
    2: 100,
    3: 126,
    4: 321,
    5: 111,
    6: 712,
    7: 1092,
    8: 1000,
    9: 0,
    10: 2989,
    11: 736,
    12: 0,
  };

  final List<Color> gradientColors = [
    Colors.blue,
    Colors.green,
  ];

  bool isCurved = true;
  int touchedIndex = -1;

  final ApiUser _apiUser = ApiUser();

  Future<dynamic> _getAmountOfUser() async {
    try {
      final response = await _apiUser.getAmountOfUser(
        2024,
      );
      final monthlyTotalAmounts = response['monthlyTotalAmounts'] as List;
      return monthlyTotalAmounts;
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
    final keys = lineData.keys.toList();
    final values = lineData.values.toList();

    final List<FlSpot> spots = [];
    for (var i = 0; i < keys.length; i++) {
      spots.add(
        FlSpot(
          keys[i].toDouble(),
          values[i].toDouble(),
        ),
      );
    }
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
              future: _getAmountOfUser(),
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
                  final monthlyTotalAmounts = snapshot.data;
                  final List<FlSpot> spots = [];
                  for (var i = 0; i < 12; i++) {
                    spots.add(
                      FlSpot(
                        monthlyTotalAmounts[i]['month'].toDouble() - 1,
                        double.parse(
                          monthlyTotalAmounts[i]['totalAmount']
                              .toStringAsFixed(2),
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 6,
                            right: 11,
                            top: 18,
                            bottom: 12,
                          ),
                          margin: const EdgeInsets.all(12),
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.7),
                              minX: 0,
                              maxX: 11,
                              minY: 0,
                              maxY: 3000,
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (value) {
                                  return const FlLine(
                                    strokeWidth: 0.1,
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return const FlLine(
                                    strokeWidth: 0.1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  width: 1,
                                ),
                              ),
                              titlesData: LineTitles.getTitleData(),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: isCurved,
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.topLeft,
                                  ),
                                  barWidth: 5,
                                  dotData: const FlDotData(
                                    show: false,
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: gradientColors
                                          .map(
                                            (e) => e.withOpacity(0.4),
                                          )
                                          .toList(),
                                      begin: Alignment.topLeft,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isCurved = !isCurved;
                            });
                          },
                          child: const Text(
                            'Curved',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(
              height: 22,
            ),
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 6,
                      right: 11,
                      top: 18,
                      bottom: 12,
                    ),
                    margin: const EdgeInsets.all(12),
                    child: LineChart(
                      LineChartData(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        minX: 0,
                        maxX: 12,
                        minY: 0,
                        maxY: 3000,
                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              strokeWidth: 0.3,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return const FlLine(
                              strokeWidth: 0.3,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        titlesData: LineTitles.getTitleData(),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: isCurved,
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                            ),
                            barWidth: 5,
                            dotData: const FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: gradientColors
                                    .map(
                                      (e) => e.withOpacity(0.4),
                                    )
                                    .toList(),
                                begin: Alignment.topLeft,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 34,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isCurved = !isCurved;
                      });
                    },
                    child: const Text(
                      'Curved',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:store_app/widgets/statistics/sections_data.dart';

class PiesChart extends StatefulWidget {
  const PiesChart({super.key});

  @override
  State<PiesChart> createState() => _PiesChartState();
}

class _PiesChartState extends State<PiesChart> {
  final Map pieData = {
    'Accessories': 2,
    'Phones': 3,
    'Camera': 1,
    'Tablets': 2,
    'Headphones': 5,
    'Smartwatchs': 3,
  };

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    num total = 0;
    for (var key in pieData.keys.toList()) {
      total = total + pieData[key];
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
              'Pie Chart',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'What type of products did you buy !!!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: AspectRatio(
                aspectRatio: 1.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (p0, p1) {
                              setState(
                                () {
                                  if (!p0.isInterestedForInteractions ||
                                      p1 == null ||
                                      p1.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex =
                                      p1.touchedSection!.touchedSectionIndex;
                                },
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 52,
                          centerSpaceColor:
                              Theme.of(context).colorScheme.surface,
                          sections: PieSections.getPieSections(
                            touchedIndex,
                            pieData,
                            total.toDouble(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: PieSections.getPieIndicators(
                        pieData,
                        true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

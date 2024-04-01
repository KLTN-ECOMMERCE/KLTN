import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieSections {
  static getPieSections(
    int touchedIndex,
    Map pieData,
    double total,
  ) =>
      List.generate(
        pieData.keys.toList().length,
        (index) {
          final isTouched = index == touchedIndex;
          final fontSize = isTouched ? 25.0 : 16.0;
          final radius = isTouched ? 60.0 : 50.0;
          const shadows = [
            Shadow(color: Colors.black, blurRadius: 2),
            Shadow(color: Colors.teal, blurRadius: 2),
          ];
          final key = pieData.keys.toList()[index];
          final value = pieData[key];

          return PieChartSectionData(
            color: _getColor(index),
            value: value.toDouble(),
            title: '${(value.toDouble() / total) * 100}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        },
      );

  static getPieIndicators(Map pieData, bool isSquare) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 12,
              right: 8,
            ),
            shrinkWrap: true,
            itemCount: pieData.length,
            itemBuilder: (context, index) {
              final key = pieData.keys.toList()[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                      color: _getColor(index),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.brown;
      case 5:
        return Colors.deepPurple;
      case 6:
        return Colors.indigoAccent;
      case 7:
        return Colors.orange;
      case 8:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}

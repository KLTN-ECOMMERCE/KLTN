import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        topTitles: AxisTitles(
          axisNameSize: 30,
          axisNameWidget: Container(
            padding: const EdgeInsets.all(4),
            child: const Center(
              child: Text(
                'You Order A Lot !!!!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          sideTitles: const SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              String text;
              switch (value.toInt()) {
                case 0:
                  text = 'NewOrder';
                  break;
                case 1:
                  text = 'Confirmed';
                  break;
                case 2:
                  text = 'Processing';
                  break;
                case 3:
                  text = 'Shipped';
                  break;
                case 4:
                  text = 'Delivered';
                  break;
                case 5:
                  text = 'Cancel';
                  break;
                default:
                  text = '';
                  break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

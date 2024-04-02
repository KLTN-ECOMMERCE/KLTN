import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        topTitles: AxisTitles(
          axisNameSize: 30,
          axisNameWidget: Container(
            padding: const EdgeInsets.all(4),
            child: const Center(
              child: Text(
                'You Spent A Lot In This Year (\$\$\$)',
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
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 45,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 500:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '500 \$',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 1000:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '1K \$',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 1500:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '1K5 \$',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 2000:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '2K \$',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 2500:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '2K5 \$',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 3000:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '3K \$',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
              }
              return const Text('');
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 0:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'JAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 1:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'FEB',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 2:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'MAR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 3:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'APR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 4:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'MAY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 5:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'JUN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 6:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'JUL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 7:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'AUG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 8:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'SEP',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 9:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'OCT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 10:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'NOV',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                case 11:
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'DEC',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
              }
              return const Text('');
            },
          ),
        ),
      );
}

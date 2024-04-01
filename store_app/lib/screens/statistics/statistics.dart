import 'package:flutter/material.dart';
import 'package:store_app/screens/chart/lines_chart.dart';
import 'package:store_app/screens/chart/pies_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<String> tabs = [
    'Line Chart',
    'Pie Chart',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  tabs = tabs;
                });
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
          title: const Text(
            'Statistics',
          ),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            unselectedLabelColor: Colors.black54,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 5,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            tabs: tabs
                .map(
                  (e) => Tab(
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: const TabBarView(
          children: [
            LinesChart(),
            PiesChart(),
          ],
        ),
      ),
    );
  }
}

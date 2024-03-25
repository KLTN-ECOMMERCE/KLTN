import 'package:flutter/material.dart';
import 'package:store_app/widgets/order/orders_by_status.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({
    super.key,
  });

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<String> tabs = [
    'NewOrder',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancel',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  tabs = tabs;
                });
              },
              icon: const Icon(
                Icons.refresh,
                //size: 30,
              ),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
        body: TabBarView(
          children: [
            ...tabs.map(
              (e) => OrdersByStatus(
                status: e,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

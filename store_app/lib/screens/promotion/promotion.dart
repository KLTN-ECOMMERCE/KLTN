import 'package:flutter/material.dart';
import 'package:store_app/screens/promotion/voucher.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  List<String> tabs = [
    'Promotions',
    'My Promotion',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Promotions',
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
              (e) => VoucherScreen(
                typeOfPromotion: e,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

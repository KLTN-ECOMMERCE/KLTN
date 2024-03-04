import 'package:flutter/material.dart';

class SortsScreen extends StatefulWidget {
  const SortsScreen({super.key});

  @override
  State<SortsScreen> createState() => _SortsState();
}

class _SortsState extends State<SortsScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price: lowest to high',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.arrow_upward_outlined,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price: highest to low',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.arrow_downward_outlined,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Alphabet: A-Z',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.sort_by_alpha_outlined,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Alphabet: Z-A',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Icon(
                                Icons.sort_by_alpha_outlined,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

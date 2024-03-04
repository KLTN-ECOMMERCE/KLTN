import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({
    super.key,
    required this.filtersValue,
  });

  final Map<String, RangeValues> filtersValue;

  @override
  State<FiltersScreen> createState() => _FiltersState();
}

class _FiltersState extends State<FiltersScreen> {
  RangeValues _currentRangePriceValues = const RangeValues(500, 1320);
  RangeValues _currentRangeRatingValues = const RangeValues(0, 5);

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    Map<String, RangeValues> filtersValue = widget.filtersValue;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 4,
            title: const Text(
              'Filters',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          bottomNavigationBar: Container(
            height: 135,
            width: double.infinity,
            alignment: Alignment.center,
            color: surfaceColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(170, 50),
                      backgroundColor: surfaceColor,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    child: const Text('DISCARD'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                        final data = {
                          'rangePriceValue': filtersValue['rangePriceValue'] ??
                              _currentRangePriceValues,
                          'rangeRatingValue': filtersValue['rangeRatingValue'] ??
                              _currentRangeRatingValues,
                        };
                      Navigator.of(context).pop(data);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(170, 50),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: const Text('APPLY'),
                  ),
                ],
              ),
            ),
          ),
          body: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: keyboardSpace + 16,
                  top: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Price range',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filtersValue.isNotEmpty
                                    ? '\u{1F4B0} ${filtersValue['rangePriceValue']?.start.round().toString()}'
                                    : '\u{1F4B0} ${_currentRangePriceValues.start.round().toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                filtersValue.isNotEmpty
                                    ? '\u{1F4B0} ${filtersValue['rangePriceValue']?.end.round().toString()}'
                                    : '\u{1F4B0} ${_currentRangePriceValues.end.round().toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: RangeSlider(
                              min: 0,
                              max: 2000,
                              divisions: 200,
                              values: filtersValue.isNotEmpty
                                  ? filtersValue['rangePriceValue']!
                                  : _currentRangePriceValues,
                              labels: filtersValue.isNotEmpty
                                  ? RangeLabels(
                                      '\u{1F4B2} ${filtersValue['rangePriceValue']?.start.round().toString()}',
                                      '\u{1F4B2} ${filtersValue['rangePriceValue']?.end.round().toString()}',
                                    )
                                  : RangeLabels(
                                      '\u{1F4B2} ${_currentRangePriceValues.start.round().toString()}',
                                      '\u{1F4B2} ${_currentRangePriceValues.end.round().toString()}',
                                    ),
                              onChanged: (value) {
                                setState(() {
                                  if (filtersValue.isNotEmpty) {
                                    filtersValue['rangePriceValue'] = value;
                                  } else {
                                    _currentRangePriceValues = value;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'Rating range',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filtersValue.isNotEmpty
                                    ? '\u{1F31F} ${filtersValue['rangeRatingValue']?.start.toString()}'
                                    : '\u{1F31F} ${_currentRangeRatingValues.start.toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                filtersValue.isNotEmpty
                                    ? '\u{1F31F} ${filtersValue['rangeRatingValue']?.end.toString()}'
                                    : '\u{1F31F} ${_currentRangeRatingValues.end.toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: RangeSlider(
                              min: 0,
                              max: 5,
                              divisions: 10,
                              values: filtersValue.isNotEmpty
                                  ? filtersValue['rangeRatingValue']!
                                  : _currentRangeRatingValues,
                              labels: filtersValue.isNotEmpty
                                  ? RangeLabels(
                                      '\u{2B50} ${filtersValue['rangeRatingValue']?.start.toString()}',
                                      '\u{2B50} ${filtersValue['rangeRatingValue']?.end.toString()}',
                                    )
                                  : RangeLabels(
                                      '\u{2B50} ${_currentRangeRatingValues.start.toString()}',
                                      '\u{2B50} ${_currentRangeRatingValues.end.toString()}',
                                    ),
                              onChanged: (value) {
                                setState(() {
                                  filtersValue['rangeRatingValue'] = value;
                                  _currentRangeRatingValues = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

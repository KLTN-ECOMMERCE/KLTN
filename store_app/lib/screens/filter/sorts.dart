import 'package:flutter/material.dart';
import 'package:store_app/data/type_of_sort.dart';
import 'package:store_app/widgets/sort/sort_item.dart';

class SortsScreen extends StatefulWidget {
  const SortsScreen({super.key});

  @override
  State<SortsScreen> createState() => _SortsState();
}

class _SortsState extends State<SortsScreen> {
  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 4,
            title: const Text(
              'Sorts',
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
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(170, 50),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    child: const Text('DISCARD'),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
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
                    ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: typeOfSort.length,
                      itemBuilder: (context, index) {
                        return SortItemWidget(
                          typeOfSort: typeOfSort[index],
                          icon: iconOfSort[index],
                        );
                      },
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

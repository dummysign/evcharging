import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../appcolor.dart';

class SearchableMultiSelectionDialog<T> extends StatefulWidget {
  final List<T> options;
  final List<T> selectedItems;
  final String title;
  final String Function(T) displayText;
  final String Function(T) filterCriteria;

  const SearchableMultiSelectionDialog({
    Key? key,
    required this.options,
    required this.title,
    required this.selectedItems,
    required this.displayText,
    required this.filterCriteria,
  }) : super(key: key);

  static Future<List<T>?> show<T>(
      BuildContext context, {
        required List<T> options,
        required String title,
        required List<T> selectedItems,
        required String Function(T) displayText,
        required String Function(T) filterCriteria,
      }) {
    return showDialog<List<T>>(
      context: context,
      builder: (context) => SearchableMultiSelectionDialog<T>(
        options: options,
        title: title,
        selectedItems: List<T>.from(selectedItems),
        displayText: displayText,
        filterCriteria: filterCriteria,
      ),
    );
  }

  @override
  _SearchableMultiSelectionDialogState<T> createState() =>
      _SearchableMultiSelectionDialogState<T>();
}

class _SearchableMultiSelectionDialogState<T>
    extends State<SearchableMultiSelectionDialog<T>> {
  late List<T> filteredOptions;
  late List<T> selectedItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
    selectedItems = List<T>.from(widget.selectedItems);
    searchController.addListener(_filterOptions);
  }

  void _filterOptions() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredOptions = widget.options
          .where((option) =>
          widget.filterCriteria(option).toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: AppColors.blue_color, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: filteredOptions.length,
          itemBuilder: (context, index) {
            final item = filteredOptions[index];
            final isSelected = selectedItems.contains(item);
            return CheckboxListTile(
              title: Text(widget.displayText(item)),
              value: isSelected,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedItems);
          },
          child: const Text("Done"),
        ),
      ],
    );
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../appcolor.dart';


class SearchableSelectionDialog<T> extends StatefulWidget {
  final List<T> options;
  final String title;
  final String Function(T) displayText;
  final String Function(T) filterCriteria;

  const SearchableSelectionDialog({
    Key? key,
    required this.options,
    required this.title,
    required this.displayText,
    required this.filterCriteria,
  }) : super(key: key);

  static Future<T?> show<T>(
      BuildContext context, {
        required List<T> options,
        required String title,
        required String Function(T) displayText,
        required String Function(T) filterCriteria,
      }) {
    return showDialog<T>(
      context: context,
      builder: (context) => SearchableSelectionDialog<T>(
        options: options,
        title: title,
        displayText: displayText,
        filterCriteria: filterCriteria,
      ),
    );
  }

  @override
  _SearchableSelectionDialogState<T> createState() =>
      _SearchableSelectionDialogState<T>();
}

class _SearchableSelectionDialogState<T>
    extends State<SearchableSelectionDialog<T>> {
  late List<T> filteredOptions;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
    searchController.addListener(_filterOptions);
  }

  void _filterOptions() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredOptions = widget.options
          .where((option) => widget.filterCriteria(option)
          .toLowerCase()
          .contains(query))
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
        children: [
          Text(widget.title),
          SizedBox(height: 10),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:AppColors.blue_color, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          )
        ],
      ),
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: filteredOptions.length,
          itemBuilder: (context, index) {
            final item = filteredOptions[index];
            return ListTile(
              title: Text(widget.displayText(item)),
              onTap: () => Navigator.of(context).pop(item),
            );
          },
        ),
      ),
    );
  }
}
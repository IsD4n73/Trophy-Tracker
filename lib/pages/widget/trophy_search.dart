import 'package:flutter/material.dart';

class TrophySearch extends StatefulWidget {
  final void Function(String)? onSearched;
  const TrophySearch({super.key, this.onSearched});

  @override
  State<TrophySearch> createState() => _TrophySearchState();
}

class _TrophySearchState extends State<TrophySearch> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: search,
        onChanged: widget.onSearched,
        decoration: InputDecoration(
          labelText: "Search Trophy",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              search.clear();
              widget.onSearched!('');
              setState(() {});
            },
            icon: Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}

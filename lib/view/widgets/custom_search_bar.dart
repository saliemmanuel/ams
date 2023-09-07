import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final void Function(String)? onChanged;
  const CustomSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45.0,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12.0)),
      child: Row(
        children: [
          const SizedBox(width: 15.0),
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 15.0),
          Expanded(
              child: Column(
            children: [
              const SizedBox(height: 12.0),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ],
          )),
          SizedBox(width: 15.0),
        ],
      ),
    );
  }
}

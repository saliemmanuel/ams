import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final void Function()? onTap;
  const CustomSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45.0,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        child: const Row(
          children: [
            SizedBox(
              width: 15.0,
            ),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 15.0),
            CustomText(data: "Search", color: Colors.grey)
          ],
        ),
      ),
    );
  }
}

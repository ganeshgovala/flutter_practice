import 'package:flutter/material.dart';

class TaskPageSlide extends StatelessWidget {
  final Icon icon;
  final String title;
  final String containerText;
  const TaskPageSlide({
    required this.containerText,
    required this.title,
    required this.icon,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(children: [
          icon,
          SizedBox(width: 8),
          Text(title, style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 36, 36, 36),
          )),
        ],),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(containerText),
        )
      ],),
    );
  }
}
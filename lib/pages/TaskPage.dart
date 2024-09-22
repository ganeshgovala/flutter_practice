import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/components/TaskPageSlide.dart';

class TaskPage extends StatefulWidget {
  final String name;
  final String id;
  const TaskPage({
    required this.name,
    required this.id,
    super.key
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(widget.name, style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              )),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: Text("Add Description"),
                    content: TextField(),
                    actions: [
                      TextButton(onPressed: () {
                        print("Pressed");
                      }, child: Text("Add"))
                    ],
                  ));
                },
                child: Row(children: [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text("Add Description"),
                ],),
              )
            ],)
          ),
          Divider(),
          TaskPageSlide(icon: Icon(Icons.calendar_month_outlined, size: 18), title: "Due Date", containerText: "17/09/2024",),
          Divider(),
          TaskPageSlide(icon: Icon(Icons.alarm_outlined, size: 18), title: "Time & Reminder", containerText: "No",),
          Divider(),
          TaskPageSlide(containerText: "No", title: "Repeat Task", icon: Icon(Icons.repeat_outlined, size: 18)),
          Divider(),
          TaskPageSlide(containerText: "ADD", title: "Notes", icon: Icon(Icons.note_outlined, size: 18)),
          Divider(),
          TaskPageSlide(containerText: "ADD", title: "Attachment", icon: Icon(Icons.attachment, size: 18)),
        ],),
      )
    );
  }
}
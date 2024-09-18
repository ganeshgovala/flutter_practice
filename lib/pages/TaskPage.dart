import 'package:flutter/material.dart';
import 'package:flutter_practice/components/TaskPageSlide.dart';

class TaskPage extends StatefulWidget {
  final String taskName;
  const TaskPage({
    required this.taskName,
    super.key
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.8,
              width: MediaQuery.of(context).size.width / 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.taskName, style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),),
                  Padding(
                    padding: const EdgeInsets.only(bottom : 10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(children: [
                        Icon(Icons.add, color: Colors.orange[400]),
                        Text("Add Sub-task", style: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 20,
                        ),)
                      ],),
                    ),
                  )
                ],
              ),
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
          ],
        ),
      ),
    );
  }
}
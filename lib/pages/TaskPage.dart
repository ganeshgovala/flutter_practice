import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/components/TaskPageSlide.dart';

class TaskPage extends StatefulWidget {
  final String taskName;
  final String id;
  TextEditingController descController = TextEditingController();
  TaskPage({
    required this.taskName,
    required this.id,
    super.key
  });

  Future<String> getDesc(id) async {
    DocumentSnapshot docs = await FirebaseFirestore.instance
      .collection('tasks')
      .doc(id)
      .get();
    
    return docs.get('desc').toString();
  }

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  Future<void> addDesc(id, String description) async {
    try {
      await FirebaseFirestore.instance
      .collection('tasks')
      .doc(id)
      .update({
        'desc' : description,
      });
      print("desc added");
    } catch(e) {
      print(e.toString());
    }
    setState(() {});
  }

  void showDescBox() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Describe your Task"),
      content: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 232, 197),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.symmetric(vertical : 2, horizontal: 10),
        child: TextField(
          controller: widget.descController,
          decoration: InputDecoration(
            hintText: "Description....",
            border: null,
          ),
        )
      ),
      actions: [
          TextButton(
            onPressed: () {
              addDesc(widget.id, widget.descController.text);
              Navigator.pop(context);
            },
            child: Text("Add", style: TextStyle(
              color: Colors.orange,
            ),),
          ),
      ],
    ));
  }

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
                children: [
                  Text(widget.taskName, style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom : 10.0),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('tasks').doc(widget.id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading...");
                        }
                        if (snapshot.hasError) {
                          return Text("Error loading description");
                        }
                        if (snapshot.hasData && snapshot.data != null) {
                          var data = snapshot.data!.data() as Map<String, dynamic>?;
                          if (data != null && data['desc'] != null) {
                            return Text(
                              data['desc'].toString(),
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            );
                          } else {
                            return GestureDetector(
                            onTap: showDescBox,
                            child: Row(
                              children: [
                                Icon(Icons.add, color: const Color.fromARGB(255, 93, 93, 93), size: 16),
                                SizedBox(width: 8),
                                Text("Describe your task"),
                              ],
                            ),
                          );
                          }
                        } else {
                          return GestureDetector(
                            onTap: showDescBox,
                            child: Row(
                              children: [
                                Icon(Icons.add, color: const Color.fromARGB(255, 93, 93, 93), size: 16),
                                SizedBox(width: 8),
                                Text("Describe your task"),
                              ],
                            ),
                          );
                        }
                      }
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
// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/components/TaskPageSlide.dart';

class TaskPage extends StatefulWidget {
  final String name;
  final String id;
  TextEditingController _descController = TextEditingController();
  TaskPage({
    required this.name,
    required this.id,
    super.key
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  Future<DocumentSnapshot> getDesc(String id) async {
    DocumentSnapshot data =  await FirebaseFirestore.instance.collection('tasks').doc(id).get();
    return data;
  }

  Future<void> addDesc(String id) async {
    DocumentReference data = await FirebaseFirestore.instance.collection('tasks').doc(id);
    try{
      print(id);
      await data.update(
      {
        'desc' : widget._descController.text,
      }
      );
      print("Data added successfully");
      setState((){});
    }
    catch(e) {
      print(e);
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              FutureBuilder(
                future: getDesc(widget.id), 
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading....");
                  }
                  if(snapshot.hasError) {
                    return Text("There is an Error");
                  }

                  final data = snapshot.data;
                  if(data != null && data.get('desc') != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.35,
                          child: Text(data.get('desc'))
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(context: context, builder: (context) => AlertDialog(
                              title: Text("Add Description"),
                              content: TextField(
                                controller: widget._descController,
                                decoration: InputDecoration(
                                  hintText: "Description",
                                ),
                              ),
                              actions: [
                                TextButton(onPressed: () {
                                  print("Pressed");
                                  addDesc(widget.id);
                                  Navigator.pop(context);
                                }, child: Text("Add"))
                              ],
                            ));
                          },
                          icon: Icon(Icons.edit, size: 18),
                        ),
                      ],
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text("Add Description"),
                        content: TextField(
                          controller: widget._descController,
                          decoration: InputDecoration(
                            hintText: "Description",
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () {
                            print("Pressed");
                            addDesc(widget.id);
                            Navigator.pop(context);
                          }, child: Text("Add"))
                        ],
                      ));
                    },
                    child: Row(children: [
                      Icon(Icons.add),
                      SizedBox(width: 5),
                      Text("Add Description"),
                    ],),
                  );
                }
              ),
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
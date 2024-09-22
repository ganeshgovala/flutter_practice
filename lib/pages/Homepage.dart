// ignore_for_file: unused_field, unused_import, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/TaskPage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  Stream<QuerySnapshot> getTasks() {
    return FirebaseFirestore.instance.collection('tasks').snapshots();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> deleteTask(String id) {
    return FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("To-do List", style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),),
            SizedBox(height: 5),
            Text("Today", style: TextStyle(
              color: const Color.fromARGB(255, 72, 72, 72),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: widget.getTasks(), 
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: Text(snapshot.error.toString()),
                      )
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(
                      color: Colors.orange.shade400,  
                    ));
                  }

                  final data = snapshot.requireData;

                  if(data.size == 0) {
                    return Center(
                      child: Text("No tasks to show", style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromARGB(255, 255, 245, 230),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(
                              name : data.docs[index]['task'].toString(),
                              id : data.docs[index].id,  
                            )));
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            title: Text(data.docs[index]['task'].toString()[0].toUpperCase() + data.docs[index]['task'].toString().substring(1, data.docs[index]['task'].toString().length),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),),
                            trailing: IconButton(
                              onPressed: () {
                                deleteTask(data.docs[index].id);
                              }, 
                              icon: Icon(Icons.delete_outlined)
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }
              )
            )
          ],
        ),
      ),
    );
  }
}


// Divider(),
// TaskPageSlide(icon: Icon(Icons.calendar_month_outlined, size: 18), title: "Due Date", containerText: "17/09/2024",),
// Divider(),
// TaskPageSlide(icon: Icon(Icons.alarm_outlined, size: 18), title: "Time & Reminder", containerText: "No",),
// Divider(),
// TaskPageSlide(containerText: "No", title: "Repeat Task", icon: Icon(Icons.repeat_outlined, size: 18)),
// Divider(),
// TaskPageSlide(containerText: "ADD", title: "Notes", icon: Icon(Icons.note_outlined, size: 18)),
// Divider(),
// TaskPageSlide(containerText: "ADD", title: "Attachment", icon: Icon(Icons.attachment, size: 18)),
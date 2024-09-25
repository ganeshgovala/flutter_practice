// ignore_for_file: unused_field, unused_import, must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/Models/DataModel.dart';
import 'package:flutter_practice/pages/TaskPage.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  Stream<QuerySnapshot> getTasks() {
    return FirebaseFirestore.instance.collection('tasks').snapshots();
  }

  Future<DocumentSnapshot> getDate(String id) async {
    DocumentSnapshot data =
        await FirebaseFirestore.instance.collection('tasks').doc(id).get();
    return data;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To-do List",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            TableCalendar(
              focusedDay: _focusedDay, 
              firstDay: DateTime.utc(2000, 10, 16), 
              lastDay: DateTime(2050, 11, 28),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.red[300],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.red[800],
                  shape: BoxShape.circle,
                )
              ),
              headerStyle: HeaderStyle(
                headerMargin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                )
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    "Today",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 72, 72, 72),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                      child: StreamBuilder(
                          stream: widget.getTasks(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(snapshot.error.toString()),
                                      ));
                            }
                  
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: const Color.fromARGB(224, 255, 59, 24),
                              ));
                            }
                  
                            final data = snapshot.requireData;
                  
                            if (data.size == 0) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'lib/images/NoTask.png',
                                      height: 250,
                                    ),
                                    Text("No tasks to show",
                                        style: TextStyle(
                                          color:
                                              const Color.fromARGB(255, 84, 84, 84),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   data.docs[index]['time'] == null
                                      //       ? "-"
                                      //       : data.docs[index]['time'].toString(),
                                      //   style: TextStyle(
                                      //     color:
                                      //         const Color.fromARGB(255, 56, 56, 56),
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => TaskPage(
                                                          name: data.docs[index]
                                                                  ['taskName']
                                                              .toString(),
                                                          id: data.docs[index].id,
                                                        )));
                                          },
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            title: Text(
                                              data.docs[index]['taskName']
                                                      .toString()[0]
                                                      .toUpperCase() +
                                                  data.docs[index]['taskName']
                                                      .toString()
                                                      .substring(
                                                          1,
                                                          data.docs[index]['taskName']
                                                              .toString()
                                                              .length),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            leading: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            trailing: IconButton(
                                                onPressed: () {
                                                  Datamodel().deleteTask(
                                                      data.docs[index].id);
                                                },
                                                icon: Icon(Icons.delete_outlined)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

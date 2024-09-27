// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice/pages/TaskPage.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  Stream<QuerySnapshot> getTasks() {
    return FirebaseFirestore.instance.collection('tasks').snapshots();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
Widget build(BuildContext context) {
  BoxController boxController = BoxController();
  return Scaffold(
    body: SlidingBox(
      controller: boxController,
      minHeight: MediaQuery.of(context).size.height * 0.3,
      maxHeight: MediaQuery.of(context).size.height, 
      style: BoxStyle.none,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      body: Expanded(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;

                if (data.size == 0) {
                  return Center(
                    child: Text(
                      "No tasks to show",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskPage(
                              name: data.docs[index]['taskName'],
                              id: data.docs[index].id,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        title: Text(
                          data.docs[index]['taskName'],
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
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(data.docs[index].id)
                                .delete();
                          },
                          icon: Icon(Icons.delete_outlined),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      backdrop: Backdrop(
        color: const Color.fromARGB(255, 255, 37, 70),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Date",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              TableCalendar(
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.white),
                  weekdayStyle: TextStyle(color: Colors.white),
                ),
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
                  outsideTextStyle: TextStyle(
                      color: const Color.fromARGB(142, 228, 228, 228)),
                  weekendTextStyle: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  defaultTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 188, 0, 0),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 174, 0, 0),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  headerMargin: EdgeInsets.only(bottom: 12),
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
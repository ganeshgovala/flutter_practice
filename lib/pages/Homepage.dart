import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_practice/pages/TaskPage.dart';
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 63, 63),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "To-do List",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
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
                      outsideTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                      defaultTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: Colors.red[300],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.red[800],
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      headerMargin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: DraggableScrollableSheet(
                minChildSize: 0.3,
                maxChildSize: 1.0,
                initialChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
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
                          controller: scrollController,
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
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                  weekNumberTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  defaultTextStyle: TextStyle(
                    color: Colors.white,
                  ),
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
                  leftChevronVisible: false,  // Enable chevrons if needed
                  rightChevronVisible: false,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: StreamBuilder(
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
                        child: Text("No tasks to show",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                      );
                    }
                        
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

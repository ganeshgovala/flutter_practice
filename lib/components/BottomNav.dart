// ignore_for_file: unused_import, unused_field, must_be_immutable

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/Models/DataModel.dart';
import 'package:flutter_practice/pages/DashboardPage.dart';
import 'package:flutter_practice/pages/Homepage.dart';
import 'package:flutter_practice/pages/ProfilePage.dart';
import 'package:flutter_practice/pages/SettingsPage.dart';
import 'package:intl/intl.dart';

class BottomNav extends StatefulWidget {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2010),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void inputTask() {
    _selectedDate = null;
    widget._taskController.text = "";
    widget._descController.text = "";
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                ),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    Center(
                      child: Container(
                        height: 4,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text("Add Task",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                          )),
                    ),
                    SizedBox(height: 20),

                    // TASK NAME

                    Text(
                      "Task",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: widget._taskController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Write Task here...",
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 91, 91, 91),
                            )),
                      ),
                    ),
                    SizedBox(height: 15),

                    // DESCRIPTION

                    Text(
                      "Note",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: widget._descController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Is there anything to be noted?"),
                      ),
                    ),
                    SizedBox(height: 25),

                    // TIME AND DATE

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TIME
                        StatefulBuilder(builder: (context, setState) {
                          return Container(
                            alignment: Alignment(0, 0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 238, 238),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: GestureDetector(
                                onTap: () async {
                                  await selectTime(context);
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.alarm_outlined,
                                        size: 20, color: Colors.grey[800]),
                                    SizedBox(width: 25),
                                    _selectedTime == null
                                        ? Center(
                                            child: Text(
                                              "Time",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                                _selectedTime!.format(context),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ),
                                  ],
                                )),
                          );
                        }),

                        // DATE
                        StatefulBuilder(builder: (context, setState) {
                          return Container(
                            alignment: Alignment(0, 0),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 238, 238),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: GestureDetector(
                                onTap: () async {
                                  await selectDate(context);
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined,
                                        size: 20, color: Colors.grey[800]),
                                    SizedBox(width: 25),
                                    _selectedDate == null
                                        ? Center(
                                            child: Text(
                                              "Date",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                                DateFormat('dd-MM')
                                                    .format(_selectedDate!),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ),
                                  ],
                                )),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 25),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          await Datamodel().addData(
                              widget._taskController.text,
                              widget._descController.text,
                              _selectedTime!.format(context).toString(),
                              _selectedDate!.year.toString() +"-"+ _selectedDate!.month.toString() +"-"+ _selectedDate!.day.toString()
                            );
                          print("pressed");
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(224, 255, 59, 24),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text("ADD",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  final iconList = [
    Icons.home,
    Icons.dashboard,
    Icons.settings,
    Icons.person,
  ];

  int _bottomNavIndex = 0;

  List<Widget> _pages = [
    HomePage(),
    DashboardPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomNavIndex], //destination screen
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: FloatingActionButton(
          onPressed: () {
            _selectedTime = null;
            inputTask();
          },
          child: Icon(Icons.add, color: Colors.white, size: 28),
          backgroundColor: const Color.fromARGB(224, 255, 59, 24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        activeColor: const Color.fromARGB(224, 255, 59, 24),
      ),
    );
  }
}

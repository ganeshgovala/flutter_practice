// ignore_for_file: unused_import, unused_field, must_be_immutable

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/DashboardPage.dart';
import 'package:flutter_practice/pages/Homepage.dart';
import 'package:flutter_practice/pages/ProfilePage.dart';
import 'package:flutter_practice/pages/SettingsPage.dart';

class BottomNav extends StatefulWidget {
    TextEditingController _taskController = TextEditingController();
  BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  TimeOfDay ? _selectedTime;

  Future<void> addTask() async {
    CollectionReference user = FirebaseFirestore.instance.collection('tasks');
    return user.add(
      {
        'task' : '${widget._taskController.text}',
        'desc' : null,
      }
    )
    .then((value) => print(value))
    .catchError((err) {
      print(err);
    });
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
    );

    if(picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
 
  void inputTask() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          content: TextField(
            controller: widget._taskController,
            decoration: InputDecoration(
              hintText: "Enter Your Task here",
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDatePicker(
                  context: context, 
                  firstDate: DateTime(2024), 
                  lastDate: DateTime(2025),
                );
              },
              icon: Icon(Icons.calendar_today_rounded)
            ),
            Text("-"),
            IconButton(
              onPressed: () {
                selectTime();
              },
              icon: Icon(Icons.alarm),
            ),
            SizedBox(width: 50),
            TextButton(
              onPressed: () {
                if(widget._taskController.text.isNotEmpty) {
                   addTask();
                   widget._taskController.text = "";
                }
                Navigator.pop(context);
              }, 
              child: Text("Add"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange[500],
              ),
            )
          ],
        );
      }) 
    );
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
              inputTask();
            },
            child: Icon(Icons.add, color: Colors.white, size: 28),
            backgroundColor: Colors.orange.shade400,
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
          activeColor: Colors.orange.shade600,
      ),
    );
  }
}
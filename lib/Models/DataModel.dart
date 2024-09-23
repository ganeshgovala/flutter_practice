import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Datamodel {
  Future<void> addData(String taskName, String? description, TimeOfDay? time) async {
    CollectionReference data = await FirebaseFirestore.instance.collection('tasks');
    data.add({
      'taskName' : taskName,
      'description' : description,
      'time' : time,
    });
  }

  Future<void> addDescription(String id, String description) async {
    DocumentReference data = await FirebaseFirestore.instance.collection('tasks').doc(id);
    data.update({
      'description' : description,
    });
  }

  Future<void> deleteTask(String id) async {
    DocumentReference data = FirebaseFirestore.instance.collection('tasks').doc(id);
    data.delete();
  }
}
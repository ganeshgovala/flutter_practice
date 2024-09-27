// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Datamodel {
  Future<void> addData(String taskName, String? description, String? time, String? date) async {
    try {
      CollectionReference data = await FirebaseFirestore.instance.collection('tasks');
        data.add({
          'taskName' : taskName,
          'description' : description,
          'time' : time,
          'date' : date,
        });
      print(data);
    }
    catch(err) {
      print("There is an Errorrrrr");
    }
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
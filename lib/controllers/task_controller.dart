import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:insta_todo/models/task.dart';
import 'package:insta_todo/models/task.dart' as model;

class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var taskList = <TaskTodo>[].obs;

  @override
  void onReady() {
    getTask();
    super.onReady();
  }

  Future<String> addTask(
      String? uid,
      String? title,
      String? note,
      int? isCompleted,
      String? date,
      String? startTime,
      String? endTime,
      int? color,
      int? remind,
      String? repeat) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String taskId = const Uuid().v1(); // creates unique id based on time
      TaskTodo task = TaskTodo(
          id: taskId,
          uid: uid,
          note: note,
          title: title,
          isCompleted: isCompleted,
          date: date,
          startTime: startTime,
          endTime: endTime,
          color: color,
          remind: remind,
          repeat: repeat);
      _firestore.collection('tasks').doc(taskId).set(task.toJson());
      res = "success";
      getTask();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future deleteData(String id) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(id).delete();
      getTask();
    } catch (e) {
      return false;
    }
  }

  Future markTaskCompleted(String id) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(id).update({'isCompleted' : 1});
      getTask();
    } catch (e) {
      return false;
    }
  }

  void getTask() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<QueryDocumentSnapshot> tasks = snapshot.docs;
    taskList.removeRange(0, taskList.length);
    for (var value in tasks) {
      taskList.add(model.TaskTodo.fromSnap(value));
    }
    print(taskList.length);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskTodo {
  String? uid;
  String? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  TaskTodo({
    required this.uid,
    this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.remind,
    required this.repeat,
  });
  static TaskTodo fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TaskTodo(
        uid: snapshot["uid"],
        id: snapshot["id"],
        title: snapshot["title"],
        note: snapshot["note"],
        isCompleted: snapshot["isCompleted"],
        date: snapshot["date"],
        startTime: snapshot["startTime"],
        endTime: snapshot['endTime'],
        color: snapshot['color'],
        remind: snapshot['remind'],
        repeat: snapshot['repeat']
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "id": id,
    "title": title,
    "note": note,
    "isCompleted": isCompleted,
    "date": date,
    "startTime": startTime,
    "endTime": endTime,
    "color": color,
    "remind": remind,
    "repeat": repeat
  };
}

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../model/task.dart' as task;
import '../services/notification_service.dart';

class TaskBloc {

  final NotificationService _notificationService = NotificationService();
  final fireStore = FirebaseFirestore.instance;
  var rng = Random();

  List<QueryDocumentSnapshot> todayList = [];
  List<QueryDocumentSnapshot> tomorrowList = [];
  List<QueryDocumentSnapshot> upcomingList = [];

  Stream<QuerySnapshot> getAllTasks(){
      Stream<QuerySnapshot> querySnapshotStream = fireStore.collection('tasks').snapshots();
      return querySnapshotStream;
  }

  List<task.Task> getSelectedTasks(int selectedValue, List<QueryDocumentSnapshot> queryList){
    List<QueryDocumentSnapshot> taskList = [];

    todayList.clear();
    tomorrowList.clear();
    upcomingList.clear();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);

    for(var item in queryList){
      DateTime scheduledDateTime = DateFormat("yyyy-MM-dd hh:mm").parse('${item["date"]} ${item["time"]}');
      DateTime scheduledDate = DateFormat("yyyy-MM-dd").parse('${item["date"]}');

      if(scheduledDate == today){
        todayList.add(item);
      }

      if(scheduledDate == tomorrow){
        tomorrowList.add(item);
      }

      if(scheduledDateTime.isAfter(now)){
        upcomingList.add(item);
      }
    }

    if(selectedValue == 0){
      taskList = todayList;
    }else if(selectedValue == 1){
      taskList = tomorrowList;
    }else if(selectedValue == 2){
      taskList = upcomingList;
    }
    
    List<task.Task> list = List<task.Task>.from(taskList.map((json) => task.Task.fromJson(json)));

    return list;
  }

  Future addTasks({required task.Task taskItem}) async {

    int notificationId = rng.nextInt(100);

    DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskName': taskItem.taskName,
        'taskDesc': taskItem.taskDesc,
        'taskTag': taskItem.taskTag,
        'date': taskItem.date,
        'time': taskItem.time,
        'imageUrl': "",
        'notificationId': notificationId
      },
    );

    String taskId = docRef.id;
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(
      {'id': taskId},
    );

    if(taskItem.taskImagePath != "") {
      await saveFileToFirebase(taskItem.taskImagePath, taskId);
    }

    if(taskItem.date != '' && taskItem.time != ''){
      DateTime scheduledDateTime = DateFormat("yyyy-MM-dd hh:mm").parse('${taskItem
          .date} ${taskItem.time}');

      await _notificationService.scheduleNotifications(
          id: notificationId,
          title: taskItem.taskName,
          body: taskItem.taskDesc,
          time: scheduledDateTime);
    }
  }

  Future deleteTasks(String taskId) async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection
        .doc(taskId)
        .delete()
        .then(
          (_) {
/*
            Fluttertoast.showToast(
                msg: "Task deleted successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 14.0);
*/
      },
    )
        .catchError(
          (error) {
/*
            Fluttertoast.showToast(
                msg: "Failed: $error",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 14.0);
*/
      },
    );
  }

  Future updateTasks(task.Task task) async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection
        .doc(task.taskId)
        .update({'taskName': task.taskName, 'taskDesc': task.taskDesc, 'taskTag': task.taskTag, 'date': task.date, 'time': task.time, 'imageUrl' : ''})
        .then(
          (_) async {

            if(task.taskImagePath != '' && !task.taskImagePath.contains('https')){
              await saveFileToFirebase(task.taskImagePath, task.taskId);
            }

            if(task.date != '' && task.time != ''){
              DateTime scheduledDateTime = DateFormat("yyyy-MM-dd hh:mm").parse('${task.date} ${task.time}');

              await _notificationService.scheduleNotifications(
                  id: task.notifId,
                  title: task.taskName,
                  body: task.taskDesc,
                  time: scheduledDateTime);
            }
          },
    ).catchError(
          (error) {
/*
            Fluttertoast.showToast(
                msg: "Failed: $error",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 14.0);
*/
      },
    );
  }

  saveFileToFirebase(String filePath, String taskId) async {
    try{
      File tempFile = File(filePath);

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('image${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': filePath},
      );

      await ref.putFile(tempFile, metadata);

      String downloadUrl = await getDownloadUrl(ref);

      var collection = FirebaseFirestore.instance.collection('tasks');
      collection
          .doc(taskId)
          .update({'imageUrl': downloadUrl});

    }catch(e){
      print('Error while uploading file to firebase storage: $e');
    }
  }

  Future<String> getDownloadUrl(Reference ref) async {
    String link = "";
    link = await ref.getDownloadURL();
    return link;
  }



}

TaskBloc bloc = TaskBloc();
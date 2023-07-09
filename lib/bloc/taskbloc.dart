import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/notification_service.dart';

class TaskBloc {
  final NotificationService _notificationService = NotificationService();

  Future addTasks({required String taskName, required String taskDesc, required String taskTag, required String date, required String time}) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskName': taskName,
        'taskDesc': taskDesc,
        'taskTag': taskTag,
        'date': date,
        'time': time
      },
    );
    String taskId = docRef.id;
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(
      {'id': taskId},
    );
    if(date != '' && time != ''){
      DateTime scheduledDateTime = DateFormat("yyyy-MM-dd hh:mm").parse('$date $time');

      var rng = Random();

      await _notificationService.scheduleNotifications(
          id: rng.nextInt(100),
          title: taskName,
          body: taskDesc,
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

  Future updateTasks(String taskId, String taskName, String taskDesc, String taskTag) async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection
        .doc(taskId)
        .update({'taskName': taskName, 'taskDesc': taskDesc, 'taskTag': taskTag})
        .then(
          (_) {
/*
            Fluttertoast.showToast(
                msg: "Task updated successfully",
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


}

TaskBloc bloc = TaskBloc();
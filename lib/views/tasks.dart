import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/task_item.dart';
import 'package:todo_app/widgets/update_task_dialog.dart';

import '../utils/colors.dart';
import '../widgets/delete_task_dialog.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No tasks to display');
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                Color taskColor = AppColors.blueShadeColor;
                var taskTag = data['taskTag'];
                if (taskTag == 'Work') {
                  taskColor = AppColors.salmonColor;
                } else if (taskTag == 'School') {
                  taskColor = AppColors.greenShadeColor;
                }
                return TaskItem(taskColor: taskColor, taskName: data['taskName'], taskDesc: data['taskDesc'], taskId: data['id'], date: data['date'], time: data['time'], taskTag: data['taskTag']);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
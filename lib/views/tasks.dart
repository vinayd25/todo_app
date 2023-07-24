import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/views/task_details.dart';
import 'package:todo_app/widgets/task_item.dart';

import '../bloc/task_bloc.dart';
import '../model/task.dart';
import '../utils/colors.dart';

class Tasks extends StatefulWidget {
  final int selectedValue;

  const Tasks({Key? key, required this.selectedValue}) : super(key: key);
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
        stream: bloc.getAllTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No tasks to display');
          } else {
            List<QueryDocumentSnapshot> queryList = snapshot.data!.docs;

            List<Task> taskFilteredList = bloc.getSelectedTasks(widget.selectedValue, queryList);

            return ListView.builder(
              itemCount: taskFilteredList.length,
                itemBuilder: (context, index) {
                  var data = taskFilteredList[index];
                  Color taskColor = AppColors.blueShadeColor;

                  var taskTag = data.taskTag;
                  if (taskTag == 'Work') {
                    taskColor = AppColors.salmonColor;
                  } else if (taskTag == 'School') {
                    taskColor = AppColors.greenShadeColor;
                  }

                  return TaskItem(task: data, onClick: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetails(data, taskColor)));
                  });
                },
            );
          }
        },
      ),
    );
  }
}
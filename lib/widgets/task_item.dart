import 'package:flutter/material.dart';
import 'package:todo_app/widgets/update_task_dialog.dart';

import '../utils/colors.dart';
import 'delete_task_dialog.dart';

class TaskItem extends StatelessWidget {
  final Color taskColor;
  final String taskName;
  final String taskDesc;
  final String taskId;
  final String taskTag;
  final String date;
  final String time;


  const TaskItem({super.key, required this.taskColor, required this.taskName, required this.taskDesc, required this.taskId, required this.date, required this.time, required this.taskTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 5.0,
            offset: Offset(0, 5), // shadow direction: bottom right
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: taskColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(taskName, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
              const SizedBox(height: 2),
              Text(taskDesc, style: const TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400)),
              const SizedBox(height: 5),
              Text('$date $time', style: const TextStyle(color: Colors.black26, fontSize: 12, fontWeight: FontWeight.w400))
            ],
          )),
          const SizedBox(width: 10),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'edit',
                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 13.0),
                  ),
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                          () => showDialog(
                        context: context,
                        builder: (context) => UpdateTaskAlertDialog(taskId: taskId, taskName: taskName, taskDesc: taskDesc, taskTag: taskTag, date: date, time: time),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 13.0),
                  ),
                  onTap: (){
                    Future.delayed(
                      const Duration(seconds: 0),
                          () => showDialog(
                        context: context,
                        builder: (context) => DeleteTaskDialog(taskId: taskId, taskName:taskName),
                      ),
                    );
                  },
                ),
              ];
            },
          )
        ],
      ),
    );
  }

}
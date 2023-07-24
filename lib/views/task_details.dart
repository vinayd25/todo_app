import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';

import '../model/task.dart';

class TaskDetails extends StatefulWidget {
  static const String routeName = "/taskDetails";

  Task task;
  Color taskColor;

  TaskDetails(this.task, this.taskColor, {super.key}){
    task = task;
  }

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.taskColor,
        title: const Text('Task Details', style: TextStyle(color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.timer_outlined, size: 15, color: AppColors.descColor),
                const SizedBox(width: 5),
                Text('${task.date} ${task.time}', style: const TextStyle(color: AppColors.descColorLight, fontSize: 12, fontWeight: FontWeight.w400)),
              ],
            ),
            const SizedBox(height: 10),
            task.taskImagePath != '' ? Image.network(task.taskImagePath, height: 200, width: double.infinity, fit: BoxFit.fill) : Container(),
            task.taskImagePath != '' ? const SizedBox(height: 10) : Container(),
            Text(task.taskName, style: const TextStyle(color: AppColors.titleColor, fontSize: 16, fontWeight: FontWeight.w400)),
            Text(task.taskDesc, style: const TextStyle(color: AppColors.descColor, fontSize: 14, fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
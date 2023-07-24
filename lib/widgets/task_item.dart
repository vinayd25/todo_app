import 'package:flutter/material.dart';
import 'package:todo_app/widgets/update_task.dart';
import 'package:share_plus/share_plus.dart';

import '../model/task.dart';
import '../utils/colors.dart';
import 'delete_task_dialog.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final void Function() onClick;

  const TaskItem({super.key, required this.task, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            task.taskImagePath != '' ? Image.network(task.taskImagePath, width: 50)
            : Container(),
            const SizedBox(width: 10),
            Expanded(
                child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.taskName, style: const TextStyle(color: AppColors.titleColor, fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 2),
                Text(task.taskDesc, style: const TextStyle(color: AppColors.descColor, fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),
                Text('${task.date} ${task.time}', style: const TextStyle(color: AppColors.descColorLight, fontSize: 12, fontWeight: FontWeight.w400))
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
                            () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateTask(task: task))),
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
                          builder: (context) => DeleteTaskDialog(taskId: task.taskId, taskName: task.taskName),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: const Text(
                      'Share',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    onTap: (){
                      Share.share('${task.taskName}\n${task.taskDesc}', subject: 'To-Do app');
                    },
                  ),
                ];
              },
            )
          ],
        ),
      ),
    );
  }

}
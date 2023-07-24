import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/widgets/pickers.dart';

import '../bloc/task_bloc.dart';
import '../model/task.dart';
import '../utils/colors.dart';
import 'disabled_focus.dart';

class UpdateTask extends StatefulWidget {
  static const String routeName = "/editTask";

  final Task task;

  const UpdateTask(
      {Key? Key, required this.task})
      : super(key: Key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final List<String> taskTags = ['Work', 'School', 'Other'];
  String selectedValue = '';
  String selectedFilePath = '';
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    dateController.text = task.date;
    timeController.text = task.time;
    selectedFilePath = task.taskImagePath;
  }

  @override
  Widget build(BuildContext context) {
    taskNameController.text = task.taskName;
    taskDescController.text = task.taskDesc;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Task',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w400),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: taskNameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        icon: const Icon(CupertinoIcons.square_list, color: AppColors.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: taskDescController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        icon: const Icon(CupertinoIcons.bubble_left_bubble_right, color: AppColors.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        const Icon(CupertinoIcons.tag, color: AppColors.primaryColor),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: DropdownButtonFormField2(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            isExpanded: true,
                            value: task.taskTag,
                            buttonHeight: 60,
                            buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            items: taskTags
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (String? value) => setState(
                                  () {
                                if (value != null) selectedValue = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Icon(CupertinoIcons.clock, color: AppColors.primaryColor),
                        SizedBox(width: 15.0),
                        Text("Set Reminder", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14))
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            focusNode: AlwaysDisabledFocusNode(),
                            onTap: () async {
                              String date = await displayDatePicker(context, initialDate: task.date);
                              if(date != "") {
                                dateController.text = date;
                              }
                            },
                            controller: dateController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              hintText: 'Date',
                              hintStyle: const TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            focusNode: AlwaysDisabledFocusNode(),
                            onTap: () async {
                              String time = await displayTimePicker(context, initialTime: task.time);
                              if(time != "") {
                                timeController.text = time;
                              }
                            },
                            controller: timeController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              hintText: 'Time',
                              hintStyle: const TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.attachment_outlined, color: AppColors.primaryColor),
                  const SizedBox(width: 15),
                  Expanded(
                    child: PopupMenuButton(
                      child: selectedFilePath != ""
                          ? Container(
                        height: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.descColor), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            selectedFilePath != "" && selectedFilePath.contains('https') ?
                            Expanded(child: Image.network((selectedFilePath), width: double.infinity, height: 100, fit: BoxFit.fill))
                            : Expanded(child: Image.file(File(selectedFilePath), width: double.infinity, height: 100, fit: BoxFit.fill)),
                            const SizedBox(width: 10),
                            IconButton(onPressed: (){
                              setState(() {
                                selectedFilePath = "";
                              });
                            }, icon: const Icon(Icons.cancel_rounded, color: AppColors.descColor))
                          ],
                        ),
                      )
                          : Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.descColor), borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 25, color: AppColors.descColor),
                            SizedBox(width: 5),
                            Text('Upload image', style: TextStyle(color: AppColors.descColorLight, fontWeight: FontWeight.w400, fontSize: 16)),
                          ],
                        ),
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'camera',
                            child: const Text(
                              'Camera',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              Future.delayed(
                                const Duration(seconds: 0),
                                    () async {
                                  XFile? file = await pickCameraImage();
                                  if(file != null){
                                    //await bloc.saveFileToFirebase(file);
                                    setState(() {
                                      selectedFilePath = file.path;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                          PopupMenuItem(
                            value: 'gallery',
                            child: const Text(
                              'Gallery',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: (){
                              Future.delayed(
                                const Duration(seconds: 0),
                                    () async {
                                  XFile? file = await pickGalleryImage();
                                  if(file != null){
                                    //await bloc.saveFileToFirebase(file);
                                    setState(() {
                                      selectedFilePath = file.path;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ];
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      final taskName = taskNameController.text;
                      final taskDesc = taskDescController.text;
                      var taskTag = '';
                      selectedValue == '' ? taskTag = task.taskTag : taskTag = selectedValue;
                      final date = dateController.text;
                      final time = timeController.text;
                      final notifId = task.notifId;

                      Task taskItem = Task(taskId: task.taskId, taskTag: taskTag, taskName: taskName, taskDesc: taskDesc, date: date, time: time, notifId: notifId, taskImagePath: selectedFilePath);
                      bloc.updateTasks(taskItem);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('Update'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

}
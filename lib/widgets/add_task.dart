import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/bloc/task_bloc.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/widgets/disabled_focus.dart';
import 'package:todo_app/widgets/pickers.dart';

import '../model/task.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final List<String> taskTags = ['Work', 'School', 'Other'];
  late String selectedValue = '';

  String selectedFilePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task',
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
                        hintText: 'Task',
                        hintStyle: const TextStyle(fontSize: 14),
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
                        hintText: 'Description',
                        hintStyle: const TextStyle(fontSize: 14),
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
                            hint: const Text(
                              'Add a task tag',
                              style: TextStyle(fontSize: 14),
                            ),
                            buttonHeight: 60,
                            buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // validator: (value) => value == null
                            //     ? 'Please select the task tag' : null,
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
                            onChanged: (String? value) => setState(() {
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
                              String date = await displayDatePicker(context);
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
                              String time = await displayTimePicker(context);
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
                            Expanded(child: Image.file(File(selectedFilePath), width: double.infinity, height: 100, fit: BoxFit.fill)),
                            const SizedBox(width: 10),
                            IconButton(onPressed: (){
                              setState(() {
                                selectedFilePath = "";
                              });
                            }, icon: const Icon(Icons.cancel_rounded, color: AppColors.descColor))
                          ],
                        ),
                      ) : Container(
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
                      final taskTag = selectedValue;
                      final date = dateController.text;
                      final time = timeController.text;

                      Task task = Task(taskId: "", taskName: taskName, taskDesc: taskDesc, taskTag: taskTag, date: date, time: time, notifId: 0, taskImagePath: selectedFilePath);
                      bloc.addTasks(taskItem: task);
                      Navigator.of(context, rootNavigator: true).pop();
                      _clearAll();
                    },
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _clearAll() {
    taskNameController.text = '';
    taskDescController.text = '';
    dateController.text = '';
    timeController.text = '';
  }

}
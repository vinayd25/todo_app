import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

///Date
DateTime first = DateTime.now();
DateTime last = DateTime(2025);

///Time
TimeOfDay timeOfDay = TimeOfDay.now();

Future<String> displayDatePicker(BuildContext context, {String initialDate = ""}) async {
  String selectedDate = "";

  DateTime initialDateTime = DateTime.now();

  if(initialDate != ""){
    initialDateTime = DateFormat("yyyy-MM-dd").parse(initialDate);
  }

  var date = await showDatePicker(
    context: context,
    initialDate: initialDateTime,
    firstDate: first,
    lastDate: last,
  );

  if(date != null){
    selectedDate = date.toLocal().toString().split(" ")[0];
  }

  return selectedDate;
}

Future<String> displayTimePicker(BuildContext context, {String initialTime = ""}) async {

  String selectedTime = "";

  TimeOfDay initialTimeOfDay = TimeOfDay.now();

  if(initialTime != ""){
    List splitTime = initialTime.split(":");
    initialTimeOfDay = TimeOfDay(hour: int.parse(splitTime[0]), minute: int.parse(splitTime[1]));
  }

  var time = await showTimePicker(
      context: context,
      initialTime: initialTimeOfDay);

  if (time != null) {
    selectedTime = "${time.hour}:${time.minute}";
  }

  return selectedTime;
}

Future<XFile?> pickGalleryImage() async {
  try{
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    return photo;
  }catch(e){
    print('Error while picking image from gallery: $e');
  }
}

Future<XFile?> pickCameraImage() async {
  try{
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);

    return photo;
  }catch(e){
    print('Error while picking image from camera: $e');
  }
}
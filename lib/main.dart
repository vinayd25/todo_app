import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/views/tasks.dart';
import 'package:todo_app/widgets/add_task.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init(); // init notification service
  //await NotificationService().requestIOSPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedValue = 0;

  Map<int, Widget> children = <int, Widget>{
    0: const Text("Today"),
    1: const Text("Tomorrow "),
    2: const Text("Upcoming"),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.titleColor)),
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTask()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CupertinoSegmentedControl(
              children: children,
              onValueChanged: (value){
                selectedValue = value;
                setState(() {
                });
              },
              groupValue: selectedValue,
              selectedColor: CupertinoColors.black,
              unselectedColor: CupertinoColors.white,
              borderColor: CupertinoColors.inactiveGray,
              pressedColor: CupertinoColors.inactiveGray,
            ),
          ),
          Expanded(child: Tasks(selectedValue: selectedValue)),
        ],
      ),
    );
  }
}

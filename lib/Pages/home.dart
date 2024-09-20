import 'package:flutter/material.dart';
import 'package:geekhaven/Pages/Predict.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:geekhaven/Widgets/date_util.dart' as date_util;

import '../Widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  Map<String, List<String>> tasksByDate = {};
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController = ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);

    // Load tasks when the app starts
    _loadTasks();
  }

  String _getFormattedDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void _addTask(String task) {
    String dateKey = _getFormattedDate(currentDateTime);
    setState(() {
      tasksByDate[dateKey] = tasksByDate[dateKey] ?? [];
      tasksByDate[dateKey]!.add(task);
      _saveTasks(); // Save tasks after adding
    });
  }

  void _deleteTask(int index) {
    String dateKey = _getFormattedDate(currentDateTime);
    setState(() {
      tasksByDate[dateKey]?.removeAt(index);
      _saveTasks(); // Save tasks after deleting
    });
  }

  // Save tasks to SharedPreferences
  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> tasksJson = tasksByDate.map((key, value) => MapEntry(key, jsonEncode(value)));
    await prefs.setString('tasks', jsonEncode(tasksJson));
  }

  // Load tasks from SharedPreferences
  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      Map<String, dynamic> decodedTasks = jsonDecode(tasksString);
      setState(() {
        tasksByDate = decodedTasks.map((key, value) => MapEntry(key, List<String>.from(jsonDecode(value))));
      });
    }
  }

  Widget hrizontalCapsuleListView() {
    return Container(
      width: width,
      height: 130,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentDateTime = currentMonthList[index];
          });
        },
        child: Container(
          width: 70,
          height: 110,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: (currentMonthList[index].day != currentDateTime.day)
                      ? [
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.1),
                  ]
                      : [
                    Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(4, 4),
                  blurRadius: 4,
                  spreadRadius: 2,
                  color: Colors.black12,
                )
              ]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  currentMonthList[index].day.toString(),
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: (currentMonthList[index].day != currentDateTime.day)
                          ? Colors.blueGrey
                          : Colors.white),
                ),
                Text(
                  date_util.DateUtils.weekdays[currentMonthList[index].weekday - 1],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: (currentMonthList[index].day != currentDateTime.day)
                          ? Colors.blueGrey
                          : Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topView() {
    return Container(
      height: height * 0.27,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.5),
              Colors.grey.withOpacity(0.3),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: const [
          BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(4, 4),
              spreadRadius: 2),
        ],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hrizontalCapsuleListView(),
        ],
      ),
    );
  }

  Widget floatingActionBtn() {
    return FloatingActionButton(
      onPressed: () {
        controller.text = "";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  child: Container(
                    height: 250,
                    width: 320,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        const Text(
                          "Add Todo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Add your new todo item',
                              hintStyle: TextStyle(color: Colors.white60)),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 320,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                _addTask(controller.text);
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Add Todo"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget todoList() {
    String dateKey = _getFormattedDate(currentDateTime);
    List<String> todosForSelectedDay = tasksByDate[dateKey] ?? [];

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: width,
      child: todosForSelectedDay.isEmpty
          ? const Center(child: Text("No Todos yet", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: todosForSelectedDay.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onLongPress: () {
              _deleteTask(index);
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.3)),
              child: Row(
                children: <Widget>[
                  //const Icon(Icons.check_box_outline_blank, color: Colors.white),
                  //const SizedBox(width: 28),
                  Center(
                    child: Text(
                      todosForSelectedDay[index],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            '${date_util.DateUtils.weekdays[currentDateTime.weekday - 1]}, '
                '${date_util.DateUtils.months[currentDateTime.month - 1]} '
                '${currentDateTime.day}, ${currentDateTime.year}',
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          todoList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: floatingActionBtn(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey!",
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Good Morning", style: AppWidget.lightTextStyle()),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: AppWidget.lightTextStyle(),
                    suffixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "What are you searching for?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                height: 310,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    buildCard("Flights", "Images/Flight.jpg"),
                    buildCard("Trains", "Images/Trains.jpg"),
                    buildCard("Hotels", "Images/Hotel.jpg"),
                  ],
                ),
              ),

              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white,
                            width: 1.5
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => Predict()) );
                        },
                        child: Center(
                          child: Text(
                            "Forecast",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {

                        },
                        child: Center(
                          child: Text(
                            "Reminder",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),
              const Text(
                "Planning Something?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 30),
              topView(),
              bottomView(),
            ],
          ),
        ),
      ),
    );

  }

  Widget buildCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      margin: EdgeInsets.only(right: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              height: 230,
              width: 190,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 26,
            ),
          ),
        ],
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do/model/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<TaskModel> taskBox = Hive.box('tasks');
  final TextEditingController _taskTitle = TextEditingController();

  void takeTaskInput() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            title: const Text(
              'Add Task',
              style: TextStyle(color: Colors.blue),
            ),
            content: TextField(
              controller: _taskTitle,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  taskBox.add(
                      TaskModel(title: _taskTitle.text, isCompleted: false));
                  _taskTitle.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }

  void confirmDeletion(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Are you sure to delete the task ?',
              style: TextStyle(color: Colors.blue),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    taskBox.deleteAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _taskTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isEmpty = taskBox.isEmpty;

    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'To-Do',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.8,
                child: !isEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: taskBox.length,
                        itemBuilder: (context, index) {
                          bool isCompleted =
                              taskBox.values.elementAt(index).isCompleted;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Checkbox.adaptive(
                                  value: isCompleted,
                                  activeColor: Colors.blueAccent[100],
                                  checkColor: Colors.black,
                                  onChanged: (value) {
                                    setState(() {
                                      taskBox.values
                                          .elementAt(index)
                                          .isCompleted = !isCompleted;
                                    });
                                  }),
                              title: Text(
                                taskBox.values.elementAt(index).title,
                                style: TextStyle(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationThickness: 2,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  confirmDeletion(index);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.blueAccent[100],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No tasks added yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          takeTaskInput();
        },
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blue[100]!),
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

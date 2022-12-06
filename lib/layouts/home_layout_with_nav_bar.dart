import 'package:flutter/material.dart';
import 'package:task_app/shared/components/default_form_field.dart';
import 'archived_task_screen.dart';
import 'package:intl/intl.dart';
import 'done_task_screen.dart';
import 'new_task_screen.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  late Database dataBase;

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> appBarTitles = [
    'Task screen',
    'Done screen',
    'Archived screen',
  ];

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(builder: (builderContext) {
        return FloatingActionButton(
          onPressed: () {
            if (isBottomSheetShown) {
              if (formKey.currentState!.validate()) {
                insertToDataBase(
                  date: dateController.text,
                  time: timeController.text,
                  title: titleController.text,
                ).then(
                  (value) {
                    isBottomSheetShown = false;
                    setState(
                      () {
                        fabIcon = Icons.edit;
                      },
                    );
                    Navigator.pop(context);
                  },
                );
              }
            } else {
              Scaffold.of(builderContext)
                  .showBottomSheet(
                    (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultFormField(
                                controller: titleController,
                                textInputType: TextInputType.text,
                                isPassword: false,
                                onFieldSubmitted: (value) {},
                                onTap: () {},
                                onChanged: (value) {},
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                },
                                prefixIcon: Icons.title,
                                label: const Text('Task Title'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DefaultFormField(
                                label: const Text('Task Time'),
                                controller: timeController,
                                textInputType: TextInputType.datetime,
                                isPassword: false,
                                onFieldSubmitted: (value) {},
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                onChanged: (value) {},
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return 'time must not be empty';
                                  }
                                },
                                prefixIcon: Icons.watch_later_outlined,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DefaultFormField(
                                label: const Text('Task Date'),
                                controller: dateController,
                                textInputType: TextInputType.datetime,
                                isPassword: false,
                                onFieldSubmitted: (value) {},
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse(
                                      '2022-12-31',
                                    ),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                onChanged: (value) {},
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return 'date must not be empty';
                                  }
                                },
                                prefixIcon: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  .closed
                  .then((value) {
                    isBottomSheetShown = false;
                    setState(
                      () {
                        fabIcon = Icons.edit;
                      },
                    );
                  });

              isBottomSheetShown = true;
              setState(() {
                fabIcon = Icons.add;
              });
            }
          },
          child: Icon(
            fabIcon,
          ),
        );
      }),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        title: Text('${appBarTitles[currentIndex]}'),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'New Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived Tasks',
          ),
        ],
      ),
    );
  }

  void createDataBase() async {
    dataBase = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then(
          (value) {
            print(
              'table created',
            );
          },
        ).catchError(
          (error) {
            print('Error when creating TABLE ${error.toString()}');
          },
        );
      },
      onOpen: (db) {
        print('Database opened');
      },
    );
  }

  Future insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await dataBase.transaction(
      (txn) {
        return txn
            .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","NEW")',
        )
            .then(
          (value) {
            print('$value inserted succefully');
          },
        ).catchError(
          (error) {
            print('Error when inserting new value ${error.toString()}');
          },
        );
      },
    );
  }

  void getDataFromDataBase() async {
    List<Map> tasks = await dataBase.rawQuery(
      'SELECT * FROM tasks',
    );
  }
}

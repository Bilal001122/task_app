import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import '../../layouts/archived_task_screen.dart';
import '../../layouts/done_task_screen.dart';
import '../../layouts/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
  late Database dataBase;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
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

  List<Map> tasks = [];

  AppCubit()
      : super(
          AppInitialState(),
        );

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDataBase() {
    openDatabase(
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
        getDataFromDataBase(db).then(
          (value) {
            tasks = value;
            emit(AppGetDataBaseState());
          },
        );
        print('Database opened');
      },
    ).then(
      (value) {
        dataBase = value;
        emit(AppCreateDataBaseState());
      },
    );
  }

  void insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await dataBase.transaction(
      (txn) {
        return txn
            .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","NEW")',
        )
            .then(
          (value) {
            print('$value inserted succefully');
            emit(AppInsertDataBaseState());
            getDataFromDataBase(dataBase).then(
              (value) {
                tasks = value;
                emit(AppGetDataBaseState());
              },
            );
          },
        ).catchError(
          (error) {
            print('Error when inserting new value ${error.toString()}');
          },
        );
      },
    );
  }

  Future<List<Map>> getDataFromDataBase(Database dataBase) async {
    emit(AppGetDataBaseLoadingState());
    return await dataBase.rawQuery(
      'SELECT * FROM tasks',
    );
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}

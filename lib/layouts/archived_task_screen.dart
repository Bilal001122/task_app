import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/task_widget.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).archivedTasks;
        return tasks.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return TaskWidget(
                    title: tasks[index]['title'],
                    time: tasks[index]['time'],
                    date: tasks[index]['date'],
                    id: tasks[index]['id'],
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 2,
                    color: Colors.grey[200],
                  );
                },
                itemCount: tasks.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.menu,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No Archived Tasks, Yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

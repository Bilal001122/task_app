import 'package:flutter/material.dart';
import 'package:task_app/shared/components/default_form_field.dart';
import '../shared/constants.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import 'archived_task_screen.dart';
import 'package:intl/intl.dart';
import 'done_task_screen.dart';
import 'new_task_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return AppCubit()..createDataBase();
        },
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is AppInsertDataBaseState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              floatingActionButton: Builder(builder: (builderContext) {
                return FloatingActionButton(
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState!.validate()) {
                        cubit.insertToDataBase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text,
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
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
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
                                                DateFormat.yMMMd()
                                                    .format(value!);
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
                            cubit.changeBottomSheetState(
                                isShow: false, icon: Icons.edit);
                          });
                      cubit.changeBottomSheetState(
                          isShow: true, icon: Icons.add);
                    }
                  },
                  child: Icon(
                    cubit.fabIcon,
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
                title: Text(cubit.appBarTitles[cubit.currentIndex]),
              ),
              body: state is AppGetDataBaseLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.changeIndex(value);
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
          },
        ));
  }
}

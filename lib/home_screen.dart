import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_manage/add_student.dart';
import 'package:student_manage/edit_student.dart';
import 'package:student_manage/student.dart';
import 'package:student_manage/student_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon myIcon = const Icon(Icons.search);
  Widget myField = const Text('Students List');
  String searchInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myField,
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (myIcon.icon == Icons.search) {
                    myIcon = const Icon(Icons.clear);
                    myField = TextField(
                      onChanged: (value) {
                        searchInput = value;
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: 'Search here',
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    );
                  } else {
                    setState(() {
                      searchInput = '';
                    });
                    myIcon = const Icon(Icons.search);
                    myField = const Text('Students list');
                  }
                });
              },
              icon: myIcon),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Student>('student').listenable(),
        builder: (context, Box<Student> value, child) {
          List keys = value.keys.toList();
          if (keys.isEmpty) {
            return const Center(
              child: Text('List is empty add some Students'),
            );
          } else {
            List<Student> data = value.values
                .toList()
                .where((element) => element.name
                    .toLowerCase()
                    .contains(searchInput.toLowerCase()))
                .toList();
            if (data.isEmpty) {
              return Center(
                child: Text('Sorry, no results found :('),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                // Student? data = value.getAt(index);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              StudentView(obj: data, index: index))),
                      tileColor: Colors.lightGreen[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(data[index].name),
                      leading: data[index].imagePath == null
                          ? CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              radius: 20,
                            )
                          : CircleAvatar(
                              child: ClipOval(
                                child: Image.file(
                                  File(data[index].imagePath),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditStudent(obj: data, index: index))),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Are you sure? '),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No')),
                                        TextButton(
                                            onPressed: () {
                                              data[index].delete();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Yes'))
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )),
                );
              },

              itemCount: data.length,
              // separatorBuilder: Divider(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddStudent()));
        },
      ),
    );
  }
}

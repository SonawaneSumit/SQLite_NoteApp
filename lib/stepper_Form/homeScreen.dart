// ignore_for_file: file_names, camel_case_types, unnecessary_null_comparison, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:sqlite_client/stepper_Form/Model/photo.dart';
import 'package:sqlite_client/stepper_Form/Model/sqLite_DB.dart';
import 'package:sqlite_client/stepper_Form/Utility.dart';
import 'package:sqlite_client/stepper_Form/stepper_Form.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _home_ScreenState();
}

class _home_ScreenState extends State<homeScreen> {
  DB_Main? dbHelper;
  Future<List<form_Model>>? notesList;
  late List<form_Model> images;

  loadData() async {
    notesList = dbHelper!.getPhotos();
  }

  @override
  void initState() {
    dbHelper = DB_Main();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drivers"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<form_Model>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notes available'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      var note = snapshot.data?[index];
                      return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            color: Colors.grey.shade100,
                            padding: const EdgeInsets.all(8.0),
                            child: DataTable(
                                headingRowColor: MaterialStatePropertyAll(
                                    Colors.blue.withOpacity(0.4)),
                                key: ValueKey<int>(note!.id!),
                                columns: const [
                                  DataColumn(
                                    label: Text('First Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Last Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Email'),
                                  ),
                                  DataColumn(
                                    label: Text('Mobile No'),
                                  ),
                                  DataColumn(
                                    label: Text('City'),
                                  ),
                                  DataColumn(
                                    label: Text('Image'),
                                  ),
                                ],
                                rows: snapshot.data!.map(
                                  (form) {
                                    return DataRow(
                                      key: ValueKey<int>(form.id!),
                                      cells: [
                                        DataCell(
                                          Text("${form.F_Name.toString()}"),
                                        ),
                                        DataCell(
                                            Text("${form.L_Name.toString()}")),
                                        DataCell(
                                            Text("${form.Email.toString()}")),
                                        DataCell(Text(
                                            "${form.M_number.toString()}")),
                                        DataCell(Text(
                                            "${form.cityName.toString() + "${form.id}"}")),
                                        DataCell(
                                          form.photoName != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Utility
                                                      .imageFromBase64String(
                                                          form.photoName),
                                                )
                                              : const Text("No Image"),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList()

                                // Table(
                                //   border: TableBorder.all(color: Colors.black),
                                //   children: [

                                //     TableRow(
                                //         decoration:
                                //             BoxDecoration(color: Colors.orange.shade600),
                                //         children: const [
                                //           Text('Cell 1',
                                //               textAlign: TextAlign.center,
                                //               style:
                                //                   TextStyle(fontWeight: FontWeight.bold)),
                                //           Text(
                                //             'Cell 2',
                                //             textAlign: TextAlign.center,
                                //             style: TextStyle(fontWeight: FontWeight.bold),
                                //           ),
                                //           Text('Cell 3',
                                //               textAlign: TextAlign.center,
                                //               style:
                                //                   TextStyle(fontWeight: FontWeight.bold)),
                                //         ])
                                //   ],
                                // ),
                                ),
                          ));
                    },
                  );

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Container(
                  //       color: Colors.grey.shade100,
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: DataTable(columns: const [
                  //         DataColumn(
                  //           label: Text('Name'),
                  //         ),
                  //         DataColumn(
                  //           label: Text('Mobile No'),
                  //         ),
                  //         DataColumn(
                  //           label: Text('Email'),
                  //         ),
                  //         DataColumn(
                  //           label: Text('City'),
                  //         ),
                  //       ], rows: [
                  //         DataRow(cells: [
                  //           DataCell(
                  //             Text('1'),
                  //           ),
                  //           DataCell(Text('Arshik')),
                  //           DataCell(Text('5644645')),
                  //           DataCell(Text('3')),
                  //         ])
                  //       ])

                  //       // Table(
                  //       //   border: TableBorder.all(color: Colors.black),
                  //       //   children: [

                  //       //     TableRow(
                  //       //         decoration:
                  //       //             BoxDecoration(color: Colors.orange.shade600),
                  //       //         children: const [
                  //       //           Text('Cell 1',
                  //       //               textAlign: TextAlign.center,
                  //       //               style:
                  //       //                   TextStyle(fontWeight: FontWeight.bold)),
                  //       //           Text(
                  //       //             'Cell 2',
                  //       //             textAlign: TextAlign.center,
                  //       //             style: TextStyle(fontWeight: FontWeight.bold),
                  //       //           ),
                  //       //           Text('Cell 3',
                  //       //               textAlign: TextAlign.center,
                  //       //               style:
                  //       //                   TextStyle(fontWeight: FontWeight.bold)),
                  //       //         ])
                  //       //   ],
                  //       // ),
                  //       ),
                  // );

                  /* ListView.builder(
                    shrinkWrap: true,
                    reverse:
                        false, // For Latest Update Value show at the Top in list..
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      var note = snapshot.data?[index];
                      return InkWell(
                        onTap: () {
                          dbHelper!.updateNotes(NotesModel(
                              id: snapshot.data?[index].id,
                              title: 'Lates Note Three',
                              age: 22,
                              description: "The First Updated Note",
                              email: "email@gmail.com"));
                          setState(() {
                            notesList = dbHelper!.getNotesList();
                          });
                        },
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.redAccent,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete_forever,
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {});
                            dbHelper!.noteDelete(snapshot.data![index].id!);
                            notesList = dbHelper!.getNotesList();
                            snapshot.data!.remove(snapshot.data![index]);
                          },
                          key: ValueKey<int>(snapshot.data![index].id!),
                          child: Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(5),
                              title: Text("${note?.title.toString()}"),
                              subtitle: Text("${note?.description.toString()}"),
                              trailing: Text("${note?.age.toString()}"),
                            ),
                          ),
                        ),
                      );
                    },
                  ); */
                }
              },
            ),
          ),
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   // color: Colors.grey,
          //   // height: 100,
          //   // width: 200,
          //   child: IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const Add_driver(),
          //             ));
          //       },
          //       icon: const Icon(Icons.add_box)),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const stepper_Form(),
              ));
          // dbHelper!
          //     .insert(NotesModel(
          //         title: 'Second Note',
          //         age: '24',
          //         description: 'Welcome To SQF-Lite App',
          //         email: 'email.com'))
          //     .then((value) {
          //   setState(() {
          //     notesList = dbHelper!.getNotesList();
          //   });
          //   print("data added");
          // }).onError((error, stackTrace) {
          //   print(error.toString());
          // });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

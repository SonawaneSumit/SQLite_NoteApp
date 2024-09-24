// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:sqlite_client/AddForm/Model/dbSQ_handler.dart';
import 'package:sqlite_client/AddForm/add_Form.dart';
import 'package:sqlite_client/AddForm/notes.dart';

class home_Screen extends StatefulWidget {
  const home_Screen({super.key});

  @override
  State<home_Screen> createState() => _home_ScreenState();
}

class _home_ScreenState extends State<home_Screen> {
  DB_Helper? dbHelper;
  Future<List<NotesModel>>? notesList;

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  void initState() {
    dbHelper = DB_Helper();
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
            // The FutureBuilder widget is used to create widgets based on the latest snapshot of interaction with a Future. It listens to a Future and rebuilds the UI whenever the Future completes.
            child: FutureBuilder(
              // The future parameter is used to specify the Future that the FutureBuilder should listen to. When the state of the Future changes, the FutureBuilder rebuilds its widget tree.
              future: notesList,
              // Type: AsyncSnapshot<List<NotesModel>>,
              // Description: This is an instance of AsyncSnapshot that holds the state and data of the asynchronous computation being handled by the FutureBuilder. The generic type List<NotesModel> indicates that this FutureBuilder is dealing with a Future that returns a list of NotesModel objects when it completes.
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                // Explanation: This checks if the Future is still in progress (i.e., the data is being fetched). If it is, it returns a centered CircularProgressIndicator to show a loading spinner to the user.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());

                  // Explanation: This checks if there was an error during the Future execution. If there was, it returns a centered Text widget displaying the error message.
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));

                  // Explanation: This checks if the Future completed successfully but returned no data (null or an empty list). If so, it returns a centered Text widget indicating that no notes are available.
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
                                key: ValueKey<int>(note!.id!),
                                columns: const [
                                  DataColumn(
                                    label: Text('Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Mobile No'),
                                  ),
                                  DataColumn(
                                    label: Text('Email'),
                                  ),
                                  DataColumn(
                                    label: Text('City'),
                                  ),
                                ],
                                rows: snapshot.data!.map(
                                  (note) {
                                    return DataRow(
                                      key: ValueKey<int>(note.id!),
                                      cells: [
                                        DataCell(
                                          Text("${note?.title.toString()}"),
                                        ),
                                        DataCell(
                                            Text("${note?.age.toString()}")),
                                        DataCell(
                                            Text("${note?.email.toString()}")),
                                        DataCell(Text(
                                            "${note?.description.toString()}")),
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
                builder: (context) => const Add_driver(),
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

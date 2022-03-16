import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/models/hisab_database.dart';
import 'package:flutter_doc_sqflite/util/data_search.dart';
import 'package:flutter_doc_sqflite/util/user_profile.dart';
import 'package:flutter_doc_sqflite/widgets/customer_detail_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'customer_entry_page.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var helper = HisabDatabase.hisabDatabase;
  var list;
  //var hisab = Hive.box<CustomerHisab>("hisab");

  @override
  Widget build(BuildContext context) {
    //var list = helper.fetchUserProfile() as List<UserProfile>;
    // var list = hisab.values.toList();
    // var sortList = list.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Color.fromARGB(255, 54, 224, 247),
          shadowColor: Colors.transparent,
          elevation: 4.0,
          centerTitle: true,
          title: const Text(
            "EasyLoad Khata",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                showSearch(
                    context: context, delegate: DataSearch(itemlist: list));
              },
            )
          ],
        ),
        body: FutureBuilder<List<UserProfile>>(
          future: helper.fetchUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              list = snapshot.data!;
              return Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(255, 85, 201, 247),
                      child: ListTile(
                        iconColor: Colors.black,
                        textColor: Colors.black,
                        leading: const Icon(Icons.book),
                        title: Text(
                          snapshot.data![index].getName,
                          //customerhisab.getAt(index)!.name,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(snapshot.data![index].getDesc),
                        //customerhisab.getAt(index)!.description),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDialog(context, helper.userProfile,
                                snapshot.data![index].id!);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CustomerDetailList(
                                        profile: snapshot.data![index],
                                        // instance: customerhisab.getAt(index)!,
                                      )));
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(255, 54, 224, 247),
            label: const Text(
              "Add Customer",
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailPage(
                            profile: UserProfile(name: "", description: ""),
                            appTitle: "New Customer",
                          )));
            },
          ),
        ));
  }

  void _showDialog(BuildContext context, String tableName, int id) {
    var okBtn = TextButton(
      child: Text("Ok"),
      onPressed: () {
        helper.deleteData(tableName, id);
        helper.deleteUserDetail(id);
        setState(() {});
        //instance.deleteAt(index);
        Navigator.pop(context);
      },
    );
    var cancleBtn = TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Cancle"));

    var alertDialog = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Do you want to delete this Customer?"),
      actions: [okBtn, cancleBtn],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/models/hisab_database.dart';
import 'package:flutter_doc_sqflite/util/user_profile.dart';
import 'package:flutter_doc_sqflite/widgets/customer_detail_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataSearch extends SearchDelegate<String> {
  var hisab = Hive.box<CustomerHisab>("hisab");
  var list = [];
  List<UserProfile>? maplist;
  //var maplist;
  var helper = HisabDatabase.hisabDatabase;
  List<UserProfile> itemlist;

  DataSearch({required this.itemlist});

  @override
  List<Widget>? buildActions(BuildContext context) {
    // (() async {
    //   await helper.fetchUserProfile().then((value) {
    //     maplist = value;
    //   });
    // })();
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, "");
          } else {
            query = "";
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: maplist!.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.book),
          title: Text(maplist![index].getName),
          subtitle: Text(maplist![index].getDesc),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerDetailList(
                          profile: UserProfile(name: maplist![index].getName, description: maplist![index].getDesc,id:maplist![index].id ),
                        )));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    list = query.isEmpty
        ? hisab.values.toList()
        : hisab.values
            .where((value) => value.name.toLowerCase().contains(query))
            .toList();

    //maplist = getList();
    maplist = query.isEmpty
        ? itemlist
        : itemlist
            .where((value) => value.getName.toLowerCase().contains(query))
            .toList();
    return maplist!.isEmpty
        ? const Center(
            child: Text("no data found"),
          )
        : ListView.builder(
            itemCount: maplist!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    showResults(context);
                  },
                  title: RichText(
                    text: TextSpan(
                        text:
                            maplist![index].getName.substring(0, query.length),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                            children: [
                              TextSpan(
                                text: maplist![index].getName.substring(query.length),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                )
                              )
                            ]),
                  ),
                  subtitle: Text(maplist![index].getDesc),
                ),
              );
            },
          );
    // return FutureBuilder<List<UserProfile>>(
    //     future: helper.fetchUserProfile(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return ListView.builder(
    //           itemCount: snapshot.data!.length,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               onTap: () {
    //                 showResults(context);
    //               },
    //               leading: const Icon(Icons.book),
    //               title: RichText(
    //                 text: TextSpan(
    //                     text: snapshot.data![index].getName
    //                         .substring(0, query.length),
    //                     style: const TextStyle(
    //                         color: Colors.black,
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 20.0),
    //                     children: [
    //                       TextSpan(
    //                           text: snapshot.data![index].getName
    //                               .substring(query.length),
    //                           style: const TextStyle(
    //                               color: Colors.grey, fontSize: 20.0))
    //                     ]),
    //               ),
    //               subtitle: Text(snapshot.data![index].getDesc),
    //             );
    //           },
    //         );
    //       } else {
    //         return const Center(
    //             child: Text(
    //           "No Data Found",
    //           style: TextStyle(fontSize: 22.0),
    //         ));
    //       }
    //     });
  }
}

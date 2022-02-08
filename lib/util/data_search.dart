import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/widgets/show_list_detail.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataSearch extends SearchDelegate<String> {
  var hisab = Hive.box<CustomerHisab>("hisab");

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
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
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    var list = query.isEmpty
        ? hisab.values.toList()
        : hisab.values
            .where((value) => value.name.toLowerCase().contains(query))
            .toList();
    return list.isEmpty
        ? Center(
            child: Text(
            "No Data Found",
            style: TextStyle(fontSize: 22.0),
          ))
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ListDetail(list: list)));
                },
                leading: Icon(Icons.book),
                title: Text(list[index].name),
                subtitle: Text(list[index].price.toString()),
              );
            },
          );
  }
}

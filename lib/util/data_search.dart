import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataSearch extends SearchDelegate<String> {
  var hisab = Hive.box<CustomerHisab>("hisab");
  var list;

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.book),
          title: Text(list[index].name),
          subtitle: Text("Rs ${list[index].price}   ${list[index].date}"),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    list = query.isEmpty
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
                  showResults(context);
                },
                leading: Icon(Icons.book),
                title: RichText(
                  text: TextSpan(
                    text: list[index].name.substring(0,query.length),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                    children: [
                      TextSpan(
                        text: list[index].name.substring(query.length),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0
                        )
                      )
                    ]
                  ),
                ),
                subtitle: Text(list[index].price.toString()),
              );
            },
          );
  }
}

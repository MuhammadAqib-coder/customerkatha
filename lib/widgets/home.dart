import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/util/data_search.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'detail_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //getList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Hisab List"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
        body: ValueListenableBuilder<Box<CustomerHisab>>(
          valueListenable: Hive.box<CustomerHisab>("hisab").listenable(),
          builder: (context, customerhisab, widget) {
            return ListView.builder(
              itemCount: customerhisab.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.book),
                    title: Text(
                      customerhisab.getAt(index)!.name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Rs ${customerhisab.getAt(index)!.price}      ${customerhisab.getAt(index)!.date}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        customerhisab.deleteAt(index);
                        // getList();
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailPage(
                                    hisab: customerhisab.getAt(index)!,
                                    appTitle: "Edit Hisab",
                                  )));
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DetailPage(
                          hisab: CustomerHisab(name: "", date: ""),
                          appTitle: "New Hisab",
                        )));
          },
        ));
  }
}
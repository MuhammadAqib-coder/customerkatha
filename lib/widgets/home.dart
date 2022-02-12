import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/util/data_search.dart';
import 'package:flutter_doc_sqflite/widgets/customer_detail_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'detail_page.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //getList();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("EasyLoad Khata"),
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
                    subtitle: Text(customerhisab.getAt(index)!.description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        customerhisab.deleteAt(index);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CustomerDetailList(
                                    instance: customerhisab.getAt(index)!,
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
                          hisab: CustomerHisab(name: "", description: ""),
                          appTitle: "New Customer",
                        )));
          },
        ));
  }
}

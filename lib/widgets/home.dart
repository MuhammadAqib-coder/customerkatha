import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/util/data_search.dart';
import 'package:flutter_doc_sqflite/widgets/customer_detail_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'detail_page.dart';

class Home extends StatelessWidget {
  var hisab = Hive.box<CustomerHisab>("hisab");
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var list = hisab.values.toList();
    var sortList = list.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("EasyLoad Khata"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
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
                    leading: const Icon(Icons.book),
                    title: Text(
                      customerhisab.getAt(index)!.name,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(customerhisab.getAt(index)!.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDialog(context, customerhisab, index);
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
        floatingActionButton: DraggableFab(
          child: FloatingActionButton.extended(
            label: const Text("Add Customer"),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailPage(
                            hisab: CustomerHisab(name: "", description: ""),
                            appTitle: "New Customer",
                          )));
            },
          ),
        ));
  }

  void _showDialog(
      BuildContext context, Box<CustomerHisab> instance, int index) {
    var okBtn = TextButton(
      child: Text("Ok"),
      onPressed: () {
        instance.deleteAt(index);
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
